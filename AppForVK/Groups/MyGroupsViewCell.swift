//
//  MyGroupsViewCell.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 15.10.17.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import UIKit

class MyGroupsViewCell: UITableViewCell {

    @IBOutlet weak var groupsAva: UIImageView!
    @IBOutlet weak var groupsName: UILabel!
    
    func configure(whithGroups groups: Groups) {
        self.groupsName.text = String(groups.name)
        groupsAva.image = UIImage(named: groups.photo)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
