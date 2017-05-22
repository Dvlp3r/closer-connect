//
//  MenuViewController.swift
//  Meetle
//
//  Created by AppsFoundation on 8/6/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit

enum MenuItem: Int {
	case home = 0
	case chat
	case location
	case settings
	case invite
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
        case MenuItem.home.rawValue:
            cell.menuItemIcon!.image = UIImage(named: "menu_home")
            cell.menuItemLabel!.text = "Home"
            break
        case MenuItem.chat.rawValue:
            cell.menuItemIcon!.image = UIImage(named: "menu_chat")
            cell.menuItemLabel!.text = "My Chat"
            break
        case MenuItem.location.rawValue:
            cell.menuItemIcon!.image = UIImage(named: "menu_location")
            cell.menuItemLabel!.text = "Location"
            break
        case MenuItem.settings.rawValue:
            cell.menuItemIcon!.image = UIImage(named: "menu_settings")
            cell.menuItemLabel!.text = "Settings"
            break
        case MenuItem.invite.rawValue:
            cell.menuItemIcon!.image = UIImage(named: "menu_invite")
            cell.menuItemLabel!.text = "Invite a Friend"
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
        case MenuItem.home.rawValue:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "changeControllerNotification"), object: "homeController")
            break
        case MenuItem.chat.rawValue:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "changeControllerNotification"), object: "chatController")
            break
        case MenuItem.location.rawValue:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "changeControllerNotification"), object: "locationController")
            break
        case MenuItem.settings.rawValue:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "changeControllerNotification"), object: "settingsController")
            break
        case MenuItem.invite.rawValue:
            inviteByMail()
            break
        default:
            break
        }
    }
}

