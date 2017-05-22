//
//  LocationMatchViewController.swift
//  Meetle
//
//  Created by AppsFoundation on 8/6/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit

class LocationMatchViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		initMenuIcon()
		initMessageIcon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	//MARK: - User actions
	
	@IBAction func sendMessage(_ sender: AnyObject) {
		messageIconClicked(sender)
	}
	
	@IBAction func keepSearching(_ sender: AnyObject) {
		let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
		let controller: LocationMatchViewController = storyboard.instantiateViewController(withIdentifier: "LocationMatchViewController") as! LocationMatchViewController
		
		let viewControllers: NSMutableArray = NSMutableArray()
		viewControllers.add(navigationController!.viewControllers)
		viewControllers.removeLastObject()
		viewControllers.add(controller)
		
		let swiftArray = viewControllers as NSArray as? [UIViewController]
		navigationController!.setViewControllers(swiftArray!, animated: true)

	}
	
}
