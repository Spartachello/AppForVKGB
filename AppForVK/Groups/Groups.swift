//
//  Groups.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 27.10.17.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Groups: Object {
    @objc dynamic var name = ""
    @objc dynamic var photo = ""
    @objc dynamic var id = 0
    @objc dynamic var members = 0
    
    convenience init(json: JSON) {
        self.init()
        
        self.name = json["name"].stringValue
        self.photo = json["photo_50"].stringValue
        self.id = json["id"].intValue
        self.members = json["members_count"].intValue
    }
}
