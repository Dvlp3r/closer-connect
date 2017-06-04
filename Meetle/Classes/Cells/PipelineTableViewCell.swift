//
//  PipelineTableViewCell.swift
//  closer-connect
//
//  Created by Mahendra Singh on 6/2/17.
//  Copyright © 2017 AppsFoundation. All rights reserved.
//

import UIKit
class PipelineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userIcon: UIImageView?
    @IBOutlet weak var messageLbl: UILabel?
    @IBOutlet weak var acceptBtn: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
}
