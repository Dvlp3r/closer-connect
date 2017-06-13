//
//  LocationViewController.swift
//  Meetle
//
//  Created by AppsFoundation on 8/6/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit

class LocationViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		showStatusBarIcon()
		initMessageIcon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	//MARK: - User Actions
	
	@IBAction func inviteFriend(_ sender: AnyObject) {
		//inviteByMail()
	}
	
	@IBAction func searchAgain(_ sender: AnyObject) {
		NotificationCenter.default.post(name: Notification.Name(rawValue: "changeControllerNotification"), object: "homeController")
	}
	
	//MARK: - Private methods
	
	func showStatusBarIcon() {
		let photo = UIImage(named: "no_one_around_header_like")
		navigationItem.titleView = UIImageView(image: photo)
	}

}
