//
//  PipelineViewController.swift
//  closer-connect
//
//  Created by Mahendra Singh on 6/2/17.
//  Copyright © 2017 AppsFoundation. All rights reserved.
//

import Foundation
import Firebase
import NVActivityIndicatorView
import FirebaseDatabase

class PipelineViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource,NVActivityIndicatorViewable {
    //MARK: - IBOutlets
    @IBOutlet var pipelineTblView: UITableView!
    var ref: DatabaseReference!
    //MARK: - Variables & Constants
    var myProfile: NSDictionary?
    let cellReuseIdentifier = "PipelineTableViewCell"
    
    //MARK: - Arrays & Dictionaries
    var pipelinesDict = NSMutableDictionary()
    var profilesDict = NSMutableDictionary()
    var keysArray = NSMutableArray()
    //MARK: -ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.pipelineTblView.delegate = self
        self.pipelineTblView.dataSource = self
        ref = Database.database().reference()
        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).observe(.value, with: { (snapshot) in
            
            // Success
            let value = snapshot.value as? NSDictionary
            //let username = value?["username"] as? String ?? ""
            //let user = User.init(username: username)
            //print(value!)
            if (value != nil)
            {
                print("You have successfully logged in")
                if let requests = value?.object(forKey: "Requests" as NSString)
                {
                    self.pipelinesDict.setDictionary(requests as! [AnyHashable : Any])
                    print(self.pipelinesDict);
                    self.keysArray.removeAllObjects()
                    self.keysArray.addObjects(from: self.pipelinesDict.allKeys)
                    self.pipelineTblView.reloadData()
                }
                else
                {
                    self.keysArray.removeAllObjects()
                    self.pipelineTblView.reloadData()
                }
                self.myProfile=value
                
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(userUpdatedProfile(_:)), name: NSNotification.Name(rawValue: "userUpdatedProfile"), object: nil)
    }
    func userUpdatedProfile(_ notification: Notification) {
        
        if (notification.object! as AnyObject).isEqual(to: "logoutController") {
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
    
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    //MARK: - Class Methods
    
    func AlertMessage(messageToDisplay: String)
    {
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    
    //MARK: - Action Methods
    @IBAction func BackPressed(sender: UIButton)
    {
        _=self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func selectionButtonClicked(sender: UIButton) {
        let location = self.pipelineTblView.convert(sender.bounds.origin, from:sender)
        let indexPath = self.pipelineTblView.indexPathForRow(at: location)
        /*if let cell = self.pipelineTblView.cellForRow(at: indexPath!) as? PipelineTableViewCell
        {
            
        }*/
        let key = keysArray[(indexPath?.row)!]
        let val = self.pipelinesDict.object(forKey: key) as! String
        if (val == "Connect")
        {
            if let user = Auth.auth().currentUser
            {
                let dbLocation = "users/\(user.uid)/\("Requests")"
                self.ref.child(dbLocation).child(key as! String).removeValue()
                
                let dbLocation2 = "users/\(key as! String)/\("Requests")"
                self.ref.child(dbLocation2).child(user.uid).removeValue()
                
            }
        }
        else if (val == "Meet")
        {
            if let user = Auth.auth().currentUser
            {
                let dbLocation = "users/\(user.uid)/\("Requests")"
                self.ref.child(dbLocation).child(key as! String).setValue("Friend")
                
                let dbLocation2 = "users/\(key as! String)/\("Requests")"
                self.ref.child(dbLocation2).child(user.uid).setValue("Friend")
                
            }
        }
        else if (val == "Friend")
        {
        }
    }
    //MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (keysArray.count) > 0
        {
            return  keysArray.count
        }
        self.pipelineTblView.separatorStyle = UITableViewCellSeparatorStyle.none
        return 0
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0;//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.pipelineTblView.separatorStyle = UITableViewCellSeparatorStyle.none
        // create a new cell if needed or reuse an old one
        let cell:PipelineTableViewCell = self.pipelineTblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)  as! PipelineTableViewCell
        let key = keysArray[indexPath.row]
        let val = self.pipelinesDict.object(forKey: key) as! String
        cell.messageLbl?.text = ""
        cell.acceptBtn?.isHidden = true
        if let userData = self.profilesDict.object(forKey: key)
        {
            cell.acceptBtn?.isHidden = false
            if (val == "Connect")
            {
                cell.messageLbl?.text = String(format: "You sent a connection request to %@.", ((userData as AnyObject).object(forKey: "Name") as! String?)!)
                cell.acceptBtn?.setTitle("Cancel", for: .normal)
            }
            else if (val == "Meet")
            {
                cell.messageLbl?.text = String(format: "%@ sent you a connection request.", ((userData as AnyObject).object(forKey: "Name") as! String?)!)
                cell.acceptBtn?.setTitle("Accept", for: .normal)
            }
            else if (val == "Friend")
            {
                cell.messageLbl?.text = String(format: "You and %@ are connected now", ((userData as AnyObject).object(forKey: "Name") as! String?)!)
                cell.acceptBtn?.setTitle("Chat", for: .normal)
            }
            if let imageArr = (userData as AnyObject).object(forKey: "Photos" as NSString)
            {
                let imgArr = imageArr as! NSArray
                LazyImage.show(imageView:cell.userIcon!, url:imgArr[0] as? String)
                
            }
            else
            {
                let gender = (userData as AnyObject).object(forKey: "Gender") as! Int?
                if (gender == 0)
                {
                    cell.userIcon?.image = UIImage(named: "GirlIcon")
                }
                else
                {
                    cell.userIcon?.image = UIImage(named: "BoyIcon")
                }
                
            }
        }
        else
        {
            self.ref.child("users").child(key as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                if (value != nil)
                {
                    cell.acceptBtn?.isHidden = false
                    self.profilesDict.setObject(value!, forKey: key as! NSCopying)
                    if (val == "Connect")
                    {
                        cell.messageLbl?.text = String(format: "You sent a connection request to %@.", ((value as AnyObject).object(forKey: "Name") as! String?)!)
                        cell.acceptBtn?.setTitle("Cancel", for: .normal)
                    }
                    else if (val == "Meet")
                    {
                        cell.messageLbl?.text = String(format: "%@ sent you a connection request.", ((value as AnyObject).object(forKey: "Name") as! String?)!)
                        cell.acceptBtn?.setTitle("Accept", for: .normal)
                    }
                    else if (val == "Friend")
                    {
                        cell.messageLbl?.text = String(format: "You and %@ are connected now", ((value as AnyObject).object(forKey: "Name") as! String?)!)
                        cell.acceptBtn?.setTitle("Chat", for: .normal)
                    }
                    if let imageArr = value?.object(forKey: "Photos" as NSString)
                    {
                        let imgArr = imageArr as! NSArray
                        LazyImage.show(imageView:cell.userIcon!, url:imgArr[0] as? String)
                        
                    }
                    else
                    {
                        let gender = value?.object(forKey: "Gender") as! Int?
                        if (gender == 0)
                        {
                            cell.userIcon?.image = UIImage(named: "GirlIcon")
                        }
                        else
                        {
                            cell.userIcon?.image = UIImage(named: "BoyIcon")
                        }
                        
                    }
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        

        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        
    }
}
