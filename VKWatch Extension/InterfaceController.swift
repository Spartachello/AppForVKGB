//
//  InterfaceController.swift
//  VKWatch Extension
//
//  Created by Спартак Ермолаев on 05.12.2017.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    static var token : String?
    
    private override init() {
        super.init()
        startSession()
    }
    
    // наш сеанс
    private let session: WCSession = WCSession.default
    
    // активация, вызывается перед первым использованием
    func startSession() {
        session.delegate = self
        session.activate()
    }
    
    @IBOutlet var newsfeed: WKInterfaceTable!
    //lazy var servide = Service(container: newsfeed)
    var posts: Root?
    var token : String?
    let sessionURL: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    lazy var url: URL? = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/newsfeed.get"
        components.queryItems = [
            URLQueryItem(name: "access_token", value: (self.token)),
            URLQueryItem(name: "filters", value: "post, photo"),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        return components.url
    }()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
         if token != nil {
            setupSession()
        } else {
            showPopup()
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func showPopup(){
        let action = WKAlertAction(title: "Закрыть", style: .cancel) {}
        presentAlert(withTitle: "Войдите в приложение на телефоне", message: "", preferredStyle: .actionSheet, actions: [action])
    }
    
    func setupSession() {
        guard let url = url else {
            assertionFailure()
            return
        }
        print(url)
        
        sessionURL.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                assertionFailure()
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(Root.self, from: data)
                self?.posts = result
                self?.setupTable()
            } catch {
                print(error)
            }
            }.resume()
        
    }
    
    func setupTable() {
        newsfeed.setNumberOfRows((posts?.response.groups.count)!, withRowType: "NewsFeedRow")
        for i in (posts?.response.groups.enumerated())! {
            if let row = newsfeed.rowController(at: i.offset) as? NewsFeedRow {
                row.newsLabel.setText(self.posts?.response.groups[i.offset].name)
                //row.photo.setImage(servide.photo(atIndexpath: i.offset, byUrl: (self.posts?.response.groups[0].photo_50)!))
                print("ROW", row)
            }
        }
    }
}

    extension InterfaceController {
        func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
            print(activationState)
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print("USERINGO", userInfo)
        if let token = userInfo["token"] {
            self.token = token as? String
            setupSession()
        }
    }
}

struct Root : Codable {
    let response: Response
}

struct Response: Codable {
    let items: [Post]
    let groups: [Source]
}

struct Post: Codable {
    let type: String
    let text: String?
    let source_id: Int
}

struct Source: Codable {
    let id: Int
    let name: String
    let photo_50 : String
}

