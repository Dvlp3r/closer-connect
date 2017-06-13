//
//  MenuViewController.swift
//  Meetle
//
//  Created by AppsFoundation on 8/6/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

enum MenuItem: Int {
	case home = 0
	case chat
    case pipeline
	case location
	case settings
    case logout
	case count
}

class MenuViewController: BaseViewController {

    @IBOutlet weak var NameLbl: UILabel?
    @IBOutlet weak var UserImage: UIImageView?
    
	@IBOutlet weak var tableView: UITableView?
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.UserImage?.layer.borderWidth = 1.0;
        self.UserImage?.layer.borderColor =  UIColor.lightGray.cgColor
        self.UserImage?.layer.cornerRadius = (self.UserImage?.frame.size.width)!/2.0
        self.UserImage?.layer.masksToBounds = true
        
        ref = Database.database().reference()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).observe(.value, with: { (snapshot) in
            
            // Success
            if let value = snapshot.value as? NSDictionary
            {
                self.NameLbl?.text = value.object(forKey: "Name") as! String?
                print("You have successfully logged in")
                
                if let imageArr = value.object(forKey: "Photos" as NSString)
                {
                    let imgArr = imageArr as! NSArray
                    LazyImage.show(imageView:self.UserImage!, url:imgArr[0] as? String)
                    
                }
                else
                {
                    let gender = value.object(forKey: "Gender") as! Int?
                    if (gender == 0)
                    {
                        self.UserImage!.image = UIImage(named: "GirlIcon")
                    }
                    else
                    {
                        self.UserImage!.image = UIImage(named: "BoyIcon")
                    }
                    
                }
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.ref.child("users").child(appDelegate.currentUserId).removeAllObservers()
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
    @IBAction func ProfilePressed(_ sender: AnyObject) {
        print("forgotPasswordPressed")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "changeControllerNotification"), object: "myResumeController")
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
            cell.menuItemIcon!.image = UIImage(named: "menu_home.png")
            cell.menuItemLabel!.text = "home"
            break
        case MenuItem.chat.rawValue:
            cell.menuItemIcon!.image = UIImage(named: "MenuMessage")
            cell.menuItemLabel!.text = "message"
            break
        case MenuItem.pipeline.rawValue:
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
        case MenuItem.logout.rawValue:
            cell.menuItemIcon!.image = UIImage(named: "MenuSettings")
            cell.menuItemLabel!.text = "logout"
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
        case MenuItem.pipeline.rawValue:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "changeControllerNotification"), object: "pipelineController")
            break
        case MenuItem.location.rawValue:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "changeControllerNotification"), object: "locationController")
            break
        case MenuItem.settings.rawValue:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "changeControllerNotification"), object: "settingsController")
            break
        case MenuItem.logout.rawValue:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "changeControllerNotification"), object: "logoutController")
            break
            
            
            
        default:
            break
        }
    }
}

