//
//  TodayViewController.swift
//  TodayVK
//
//  Created by Спартак Ермолаев on 28.11.2017.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var vkNews: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults(suiteName: "group.AppForVKGroup")
        if let news = defaults?.string(forKey:"news"){
            vkNews.text = "\(news)"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
}
