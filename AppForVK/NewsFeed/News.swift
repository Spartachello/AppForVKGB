//
//  News.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 25.11.2017.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import Foundation
import SwiftyJSON

class News {
    
    var id = ""
    var sourceId = ""
    var postTime = ""
    var text = ""
    var type = ""
    var photoNews = ""
    var photoSize = ""
    var photoLink: String?
    
    var friends: [Friends]?
    var groups: [Groups]?
    
    var geoCoordinates = ""
    var geoPlaceTitle = ""
    
    init(json: JSON) {
    self.id = json["post_id"].stringValue + json["date"].stringValue + json["source_id"].stringValue + json["type"].stringValue
    self.type = json["type"].stringValue
    self.text = json["text"].stringValue
        
        self.photoNews = json["attachments"][0]["photo"]["photo_604"].stringValue
       // if !json["attachments"][0]["photo"]["width"].stringValue.isEmpty {
         //   photoSize = json["attachments"][0]["photo"]["width"].stringValue + "x" + json["attachments"][0]["photo"]["height"].stringValue
        //}
        
    self.geoCoordinates = json["geo"]["coordinates"].stringValue
    self.geoPlaceTitle = json["geo"]["place"]["title"].stringValue
        
        var defaults = UserDefaults(suiteName: "group.AppForVKGroup")
        defaults?.set(String(text), forKey:"news")
        defaults?.synchronize()
    }
}
