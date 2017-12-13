//
//  SettingsController.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 20.11.2017.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import UIKit
import VK_ios_sdk

class SettingsController: UIViewController {
    
    let segue = "goToMainView"
    let logout = VKSdk.accessToken().userId

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func LogoutBtn(_ sender: Any) {
        VKSdk.forceLogout()
        let log = VKSdk.isLoggedIn()
        print("logout", log)
        
    }
    
    func stopWork() {
        performSegue(withIdentifier: segue, sender: LogoutBtn((Any).self))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
