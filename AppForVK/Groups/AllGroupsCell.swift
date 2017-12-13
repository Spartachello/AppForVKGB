//
//  AllGroupsCell.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 16.10.17.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import UIKit

class AllGroupsCell: UITableViewCell {

    @IBOutlet weak var allGroupsAva: UIImageView!
    @IBOutlet weak var allGroupsName: UILabel!
    @IBOutlet weak var allGroupsNumberOfSub: UILabel!
    
    func configure(whithGroups allGroups: Groups) {
        self.allGroupsName.text = String(allGroups.name)
        allGroupsAva.image = UIImage(named: allGroups.photo)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
