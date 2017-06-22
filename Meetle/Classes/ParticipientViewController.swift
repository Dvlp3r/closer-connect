//
//  ParticipientViewController.swift
//  closer-connect
//
//  Created by Mahendra Singh on 6/22/17.
//  Copyright © 2017 AppsFoundation. All rights reserved.
//

import Foundation
import Firebase
import NVActivityIndicatorView
import FirebaseDatabase

class ParticipientViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource,NVActivityIndicatorViewable {
    //MARK: - IBOutlets
    @IBOutlet var pipelineTblView: UITableView!
    var ref: DatabaseReference!
    //MARK: - Variables & Constants
    var myProfile: NSDictionary?
    let cellReuseIdentifier = "PipelineTableViewCell"
    
    //MARK: - Arrays & Dictionaries
    var pipelinesDict = NSMutableDictionary()
    var profilesDict = NSMutableDictionary()
    var keysArray = [String]()
    //MARK: -ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pipelinesDict.removeObject(forKey: "StartDate")
         self.pipelinesDict.removeObject(forKey: "g")
         self.pipelinesDict.removeObject(forKey: "l")
        
        self.keysArray = self.pipelinesDict.allKeys as! [String]
        // Do any additional setup after loading the view.
        self.pipelineTblView.delegate = self
        self.pipelineTblView.dataSource = self
        ref = Database.database().reference()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
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
        //let location = self.pipelineTblView.convert(sender.bounds.origin, from:sender)
        //let indexPath = self.pipelineTblView.indexPathForRow(at: location)
        /*if let cell = self.pipelineTblView.cellForRow(at: indexPath!) as? PipelineTableViewCell
         {
         
         }*/
        
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
        let val = self.pipelinesDict.object(forKey: key) as! NSDictionary
        cell.messageLbl?.text = ""
        cell.acceptBtn?.isHidden = true
        if let userData = self.profilesDict.object(forKey: key)
        {
            if let goingval = val.object(forKey: "IsGoing") as? NSNumber
            {
                if (goingval.intValue == -1)
                {
                    cell.messageLbl?.text = String(format: "%@ Not yet decided.", ((userData as AnyObject).object(forKey: "Name") as! String?)!)
                }
                else
                {
                    if (goingval.intValue == 0)
                    {
                        cell.messageLbl?.text = String(format: "%@ is going.", ((userData as AnyObject).object(forKey: "Name") as! String?)!)
                    }
                    else if (goingval.intValue == 1)
                    {
                        cell.messageLbl?.text = String(format: "%@ is may be going.", ((userData as AnyObject).object(forKey: "Name") as! String?)!)
                    }
                    else
                    {
                        cell.messageLbl?.text = String(format: "%@ is not going.", ((userData as AnyObject).object(forKey: "Name") as! String?)!)
                    }
                    
                }
            }
            else
            {
                cell.messageLbl?.text = String(format: "%@ Not yet decided.", ((userData as AnyObject).object(forKey: "Name") as! String?)!)
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
            self.ref.child("users").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                if let value = snapshot.value as? NSDictionary
                {
                    if let goingval = val.object(forKey: "IsGoing") as? NSNumber
                    {
                        if (goingval.intValue == -1)
                        {
                            cell.messageLbl?.text = String(format: "%@ Not yet decided.", ((value as AnyObject).object(forKey: "Name") as! String?)!)
                        }
                        else
                        {
                            if (goingval.intValue == 0)
                            {
                                cell.messageLbl?.text = String(format: "%@ is going.", ((value as AnyObject).object(forKey: "Name") as! String?)!)
                            }
                            else if (goingval.intValue == 1)
                            {
                                cell.messageLbl?.text = String(format: "%@ is may be going.", ((value as AnyObject).object(forKey: "Name") as! String?)!)
                            }
                            else
                            {
                                cell.messageLbl?.text = String(format: "%@ is not going.", ((value as AnyObject).object(forKey: "Name") as! String?)!)
                            }
                            
                        }
                    }
                    else
                    {
                        cell.messageLbl?.text = String(format: "%@ Not yet decided.", ((value as AnyObject).object(forKey: "Name") as! String?)!)
                    }
                    if let imageArr = value.object(forKey: "Photos" as NSString)
                    {
                        let imgArr = imageArr as! NSArray
                        LazyImage.show(imageView:cell.userIcon!, url:imgArr[0] as? String)
                        
                    }
                    else
                    {
                        let gender = value.object(forKey: "Gender") as! Int?
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
