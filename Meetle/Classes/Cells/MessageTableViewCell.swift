//
//  MessageTableViewCell.swift
//  closer-connect
//
//  Created by Mahendra Singh on 6/13/17.
//  Copyright © 2017 AppsFoundation. All rights reserved.
//

import UIKit
class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userIcon: UIImageView?
    @IBOutlet weak var messageLbl: UILabel?
    @IBOutlet weak var countLbl: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        countLbl?.layer.cornerRadius = (countLbl?.frame.size.width)!/2.0
        countLbl?.layer.masksToBounds = true
        //countLbl?.layer.borderWidth = 2.0
        //countLbl?.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
}
