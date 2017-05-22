//
//  MyMessageCell.swift
//  Meetle
//
//  Created by AppsFoundation on 8/5/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel?
    @IBOutlet weak var backgroundMessageView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundMessageView!.layer.cornerRadius = 15
        backgroundMessageView!.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
