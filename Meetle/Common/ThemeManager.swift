//
//  ThemeManager.swift
//  Meetle
//
//  Created by AppsFoundation on 8/5/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit

class ThemeManager: NSObject {
	
	class func menuItemBackgroundColor() -> UIColor {
		return UIColor(red: 2.0/255.0, green:27.0/255.0, blue:49.0/255.0, alpha:1.0)
	}
	
	class func selectedMenuItemBackgroundColor() -> UIColor {
		return UIColor(red: 0.0/255.0, green:105.0/255.0, blue:194.0/255.0, alpha:1.0)
	}
	
	class func profileLikeBackgroundColor() -> UIColor {
		return UIColor(red: 43.0/255.0, green:182.0/255.0, blue:123.0/255.0, alpha:1.0)
	}
	
	class func profileNextBackgroundColor() -> UIColor {
		return UIColor(red: 178.0/255.0, green:78.0/255.0, blue:79.0/255.0, alpha:1.0)
	}
	
	class func settingsLightGreenColor() -> UIColor {
		return UIColor(red: 242.0/255.0, green:253.0/255.0, blue:249.0/255.0, alpha:1.0)
	}
	
	class func settingsLightGreyColor() -> UIColor {
		return UIColor(red: 238.0/255.0, green:241.0/255.0, blue:242.0/255.0, alpha:1.0)
	}
	
}
