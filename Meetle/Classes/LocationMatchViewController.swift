//
//  LocationMatchViewController.swift
//  Meetle
//
//  Created by AppsFoundation on 8/6/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LocationMatchViewController: BaseViewController {

    @IBOutlet weak var dealButton: UIButton?
    @IBOutlet weak var noDealButton: UIButton?
    @IBOutlet weak var SendMessageButton: UIButton?
    @IBOutlet weak var dealMessageLbl: UILabel?
    @IBOutlet weak var requestDealMessageLbl: UILabel?
    @IBOutlet weak var dealView: UIView?
    
    var ref: DatabaseReference!
    
    var friendId: String!
    var requestType: String!
    var messageId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		//initMenuIcon()
		//initMessageIcon()
        
        ref = Database.database().reference()
        
        self.ref.child("users").child(friendId!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            //let username = value?["username"] as? String ?? ""
            //let user = User.init(username: username)
            //print(value!)
            if (value != nil)
            {
                self.title = value?.object(forKey: "Name") as! String?
                self.dealMessageLbl?.text = String(format:"You and %@ are now connected.", (value?.object(forKey: "Name") as! String?)!)
                self.requestDealMessageLbl?.text = String(format:"%@ is looking to connect with you.", (value?.object(forKey: "Name") as! String?)!)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        if (requestType == "Connect")
        {
            dealButton?.isEnabled = false
            dealButton?.isHidden = true
            noDealButton?.isHidden = false
            SendMessageButton?.isHidden = true
            requestDealMessageLbl?.isHidden = false
            dealView?.isHidden = true
        }
        else if (requestType == "Meet")
        {
            dealButton?.isEnabled = true
            dealButton?.isHidden = false
            noDealButton?.isHidden = false
            SendMessageButton?.isHidden = true
            requestDealMessageLbl?.isHidden = false
            dealView?.isHidden = true
        }
        else if (requestType == "Friend")
        {
            dealButton?.isEnabled = true
            dealButton?.isHidden = true
            noDealButton?.isHidden = true
            SendMessageButton?.isHidden = false
            requestDealMessageLbl?.isHidden = true
            dealView?.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	//MARK: - User actions
	
	@IBAction func dealBtnClicked(_ sender: AnyObject) {
        if let user = Auth.auth().currentUser
        {
            let dbLocation = "users/\(user.uid)/\("Requests")"
            self.ref.child(dbLocation).child(friendId as String).setValue("Friend", withCompletionBlock: { (error, ref) -> Void in
                if (!(error != nil))
                {
                    let dbLocation2 = "users/\(self.friendId as String)/\("Requests")"
                    self.ref.child(dbLocation2).child(user.uid).setValue("Friend", withCompletionBlock: { (error, ref) -> Void in
                        if (!(error != nil))
                        {
                            let dbLocation3 = "users/\(user.uid)/\("Messages")"
                            let timeInterval = Date().timeIntervalSince1970
                            self.messageId = String(format:"%d",timeInterval);
                            self.ref.child(dbLocation3).child(self.friendId as String).setValue(["ChatId": self.messageId,  "TotalMessages": 0,  "UnreadMessages": 0], withCompletionBlock: { (error, ref) -> Void in
                                if (!(error != nil))
                                {
                                    let dbLocation4 = "users/\(self.friendId as String)/\("Messages")"
                                    self.ref.child(dbLocation4).child(user.uid).setValue(["ChatId": self.messageId,  "TotalMessages": 0,  "UnreadMessages": 0], withCompletionBlock: { (error, ref) -> Void in
                                        if (!(error != nil))
                                        {
                                            self.dealButton?.isHidden = true
                                            self.noDealButton?.isHidden = true
                                            self.SendMessageButton?.isHidden = false
                                            self.requestDealMessageLbl?.isHidden = true
                                            self.dealView?.isHidden = false
                                        }
                                    })
                                }
                            })
                            
                        }
                    })
                }
            })
        }
	}
    @IBAction func noDealBtnClicked(_ sender: AnyObject) {
        if let user = Auth.auth().currentUser
        {
            let dbLocation = "users/\(user.uid)/\("Requests")"
            self.ref.child(dbLocation).child(friendId as String).removeValue(completionBlock: { (error, ref) -> Void in
                
                if (!(error != nil))
                {
                    let dbLocation2 = "users/\(self.friendId as String)/\("Requests")"
                    self.ref.child(dbLocation2).child(user.uid).removeValue(completionBlock: { (error, ref) -> Void in
                        
                        if (!(error != nil))
                        {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    })
                }
                
            })
        }
    }
    @IBAction func sendMessage(_ sender: AnyObject) {
        //messageIconClicked(sender)
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: ChatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        controller.friendId = self.messageId
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func backPressed(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
	
	@IBAction func keepSearching(_ sender: AnyObject) {
		NotificationCenter.default.post(name: Notification.Name(rawValue: "changeControllerNotification"), object: "homeController")

	}
	
}
