//
//  EventsCell.swift
//  closer-connect
//
//  Created by Mahendra Singh on 6/17/17.
//  Copyright © 2017 AppsFoundation. All rights reserved.
//

import UIKit
class EventsCell: UITableViewCell {
    
    @IBOutlet weak var eventLbl: UILabel?
    @IBOutlet weak var placeLbl: UILabel?
    @IBOutlet weak var startDateLbl: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
}
