//
//  MessagesViewController.swift
//  iMessage
//
//  Created by Спартак Ермолаев on 01.12.2017.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var newsLabel: UILabel!
    let defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func sendMessage(_ sender: Any) {
        
        let layout = MSMessageTemplateLayout()
        let defaults = UserDefaults(suiteName: "group.AppForVKGroup")
        if let news = defaults?.string(forKey:"news"){
            newsLabel.text = "\(news)"
            print("news", newsLabel)
        }
        layout.caption = newsLabel.text
        //layout.image = UIImage(named: "Stars")
        let message = MSMessage()
        message.layout = layout
        activeConversation?.insert(message, completionHandler: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    override func willBecomeActive(with conversation: MSConversation) {
  
    }
    
    override func didResignActive(with conversation: MSConversation) {
      
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
    
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
    
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
    
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
      
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
      
    }

}
