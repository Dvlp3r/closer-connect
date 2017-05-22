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
		inviteByMail()
	}
	
	@IBAction func searchAgain(_ sender: AnyObject) {
		let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
		let controller: LocationMatchViewController = storyboard.instantiateViewController(withIdentifier: "LocationMatchViewController") as! LocationMatchViewController
		
		let viewControllers: NSMutableArray = NSMutableArray()
		viewControllers.add(navigationController!.viewControllers)
		viewControllers.removeLastObject()
		viewControllers.add(controller)
		
		let swiftArray = viewControllers as NSArray as? [UIViewController]
		navigationController!.setViewControllers(swiftArray!, animated: true)
	}
	
	//MARK: - Private methods
	
	func showStatusBarIcon() {
		let photo = UIImage(named: "no_one_around_header_like")
		navigationItem.titleView = UIImageView(image: photo)
	}

}
