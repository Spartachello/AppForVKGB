//
//  Friends.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 26.10.17.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Friends: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var surname = ""
    @objc dynamic var photo = ""
    
    @objc dynamic var fullName: String {
        return name + " " + surname
    }
    
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.name = json["first_name"].stringValue
        self.surname = json["last_name"].stringValue
        self.photo = json["photo_50"].stringValue
    }
}

