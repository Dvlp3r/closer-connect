//
//  MenuViewController.swift
//  Meetle
//
//  Created by AppsFoundation on 8/6/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit

enum MenuItem: Int {
	case resume = 0
	case chat
    case home
	case location
	case settings
	case count
}

class MenuViewController: BaseViewController {

	@IBOutlet weak var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		let path = tableView?.indexPathForSelectedRow
		if path == nil {
			let indexPath = IndexPath(row: 0, section: 0)
			tableView?.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.bottom)
		}
	}
}

// MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItem.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "MenuCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! MenuTableViewCell
        
        switch indexPath.row {
        case MenuItem.resume.rawValue:
            cell.menuItemIcon!.image = UIImage(named: "MenuResume")
            cell.menuItemLabel!.text = "my resume"
            break
        case MenuItem.chat.rawValue:
            cell.menuItemIcon!.image = UIImage(named: "MenuMessage")
            cell.menuItemLabel!.text = "message"
            break
        case MenuItem.home.rawValue:
            cell.menuItemIcon!.image = UIImage(named: "MenuPipeline")
            cell.menuItemLabel!.text = "pipeline"
            break
        case MenuItem.location.rawValue:
            cell.menuItemIcon!.image = UIImage(named: "MenuEvent")
            cell.menuItemLabel!.text = "events"
            break
        case MenuItem.settings.rawValue:
            cell.menuItemIcon!.image = UIImage(named: "MenuSettings")
            cell.menuItemLabel!.text = "settings"
            break
        default:
            break
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MenuViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case MenuItem.resume.rawValue:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "changeControllerNotification"), object: "myResumeController")
            break
        case MenuItem.chat.rawValue:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "changeControllerNotification"), object: "chatController")
            break
        case MenuItem.home.rawValue:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "changeControllerNotification"), object: "homeController")
            break
        case MenuItem.location.rawValue:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "changeControllerNotification"), object: "locationController")
            break
        case MenuItem.settings.rawValue:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "changeControllerNotification"), object: "settingsController")
            break
        default:
            break
        }
    }
}

