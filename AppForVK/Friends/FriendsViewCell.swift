//
//  FriendsViewCell.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 15.10.17.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import UIKit

class FriendsViewCell: UITableViewCell {

    @IBOutlet weak var friendsName: UILabel!
    @IBOutlet weak var friendsAva: UIImageView!
    
    func configure(whithFriends friends: Friends) {
        self.friendsName.text = String(friends.fullName)
        self.friendsAva.image = UIImage(named: friends.photo)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
