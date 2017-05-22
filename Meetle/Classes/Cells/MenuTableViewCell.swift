//
//  MenuTableViewCell.swift
//  Meetle
//
//  Created by AppsFoundation on 8/5/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

	@IBOutlet weak var menuItemIcon: UIImageView?
	@IBOutlet weak var menuItemLabel: UILabel?
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		
		if selected {
			contentView.backgroundColor = ThemeManager.selectedMenuItemBackgroundColor()
		} else {
			contentView.backgroundColor = ThemeManager.menuItemBackgroundColor()
		}
    }
}
