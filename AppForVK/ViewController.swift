//
//  ViewController.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 15.10.17.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import UIKit
import Alamofire
import VK_ios_sdk
import WatchConnectivity

var access_Token: String = ""

class ViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate, WCSessionDelegate {

    let friendsService = FriendsService()
    let groupsService = GroupsService()
    let barController = TabBarController.self
    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var authButton: UIButton!
    
    let segueAuthorized = "goToTabBar"
    let appId = "*******"
    var scope = [Any]()
    
    var friends = [Friends]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        //присваиваем его UIScrollVIew
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    //АВТОРИЗАЦИЯ В VK/получение токена
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        access_Token = result.token.accessToken
        if (access_Token != nil) {
            //print("TOKEN", access_Token)
            self.userDefaults.set(access_Token, forKey: "token")
            connectWatch()
            UserDefaults.init(suiteName: "group.AppForVKGroup")?.setValue(access_Token, forKey: "token")
            print("authorization")
            performSegue(withIdentifier: segueAuthorized, sender: dismiss(animated: false, completion: nil))
        } else {
            print("no authorization")
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
       self.navigationController?.topViewController?.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        let vc = VKCaptchaViewController.captchaControllerWithError(captchaError)
        vc?.present(in: self.navigationController?.popViewController(animated: false))
    }
    
    func startWork() {
        performSegue(withIdentifier: segueAuthorized, sender: self)
    }
    
    //авторизация через VK
    @IBAction func authorizedVKButton(_ sender: Any) {
        
        VKSdk.initialize(withAppId: appId).register(self)
        VKSdk.instance().uiDelegate = self
        VKSdk.wakeUpSession(scope, complete: { (state, error) in
            if (state ==  VKAuthorizationState.authorized) {
                print("wakeUpSession")
                self.startWork()
            } else {
                print("NO")
            }
        })
        scope = [VK_PER_GROUPS, VK_PER_FRIENDS, VK_PER_PHOTOS, VK_PER_WALL]
        VKSdk.authorize(scope)
    }
    
    //Подписываемся на два уведомления, одно приходит при появляении клавиатуры
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //Второе когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //Метод отписки при наступлении события исчезновения контроллера с экрана
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        
        //получем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        
        //Добавляем отсуп внизу UIScrollView равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        //устанавливаем отступ внизу UIScrollView равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //Добавим исчезновение клавиатуры при клике по пустому месту на экране. Добавим метод который будет вызываться при клике
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
        
    func checkUserData() -> Bool {
            let login = loginTextField.text!
            let password = passwordTextField.text!
        
            if login == "admin" && password == "123456" {
                return true
            } else {
                return false
        }
    }
    
    //предупреждение неправильного ввода пароля
    func showLoginError() {
        //Создаем контроллер
        let alter = UIAlertController(title: "Ошибка", message: "Введены не верные данные пользователя", preferredStyle: .alert)
        //Создаем кнопку для UIAlertController
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        //Добавляем кнопку на UIAlertController
        alter.addAction(action)
        //показываем UIAlertController
        present(alter, animated: true, completion: nil)
    }
    
    //вход в приложение
    @IBAction func enterToApp(_ sender: Any) {
        //получаем текст логина
        let login = loginTextField.text!
        //получаем текст пароль
        let password = passwordTextField.text!
        
        //проверяем верны ли они
        if login == "admin" && password == "123456" {
            print("успешная авторизация")
        } else {
            print("неуспешная авторизация")
        }
    }
    
    //ДЛЯ APPLE WATCH
    func connectWatch()  {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    //ДЛЯ APPLE WATCH
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(activationState)
        guard activationState == .activated else {
            return
        }
        // передаем
        let sessionUserInfoTransfer = session.transferUserInfo(["token" : "\(access_Token)"])
        print("SSSSSSS", sessionUserInfoTransfer)
    }
    //ДЛЯ APPLE WATCH
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("ничего не делаем")
    }
    //ДЛЯ APPLE WATCH
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
}

