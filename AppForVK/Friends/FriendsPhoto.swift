//
//  FriendsPhoto.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 01.11.17.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class FriendsPhoto: Object {
    @objc dynamic var photo = ""
   
    var url: String {return "https://api.vk.com/method/photos.getAll?v=5.68&access_token=token"
    }
    
    convenience init(json: JSON) {
        self.init()
        
        self.photo = json["photo_130"].stringValue
    }
}
