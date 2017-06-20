//
//  EventDetailsViewController.swift
//  closer-connect
//
//  Created by Mahendra Singh on 6/20/17.
//  Copyright © 2017 AppsFoundation. All rights reserved.
//

import Foundation
import Firebase
import NVActivityIndicatorView
import FirebaseDatabase

class EventDetailsViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource,NVActivityIndicatorViewable {
    //MARK: - IBOutlets
    @IBOutlet var pipelineTblView: UITableView!
    var ref: DatabaseReference!
    var eventId: String?
    
    let cellReuseIdentifier1 = "EventDetailCell1"
    let cellReuseIdentifier2 = "EventDetailCell2"
    let cellReuseIdentifier3 = "EventDetailCell3"
    let cellReuseIdentifier4 = "EventDetailCell4"
    let cellReuseIdentifier5 = "EventDetailCell5"
    let cellReuseIdentifier6 = "EventDetailCell6"
    
    
    //MARK: - Arrays & Dictionaries
    var eventDetailsDict = NSMutableDictionary()
    var eventParticipientDict = NSMutableDictionary()
    //MARK: -ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.currentUserId = Auth.auth().currentUser?.uid
        
        
        ref = Database.database().reference()
        
        
        
        // Do any additional setup after loading the view.
        self.pipelineTblView.delegate = self
        self.pipelineTblView.dataSource = self
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        self.ref.child("eventsLocation").child(eventId!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot)
            if let value = snapshot.value as? NSDictionary
            {
                print(value)
                self.eventParticipientDict.setDictionary(value as! [AnyHashable : Any])
                self.pipelineTblView.reloadData()
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.ref.child("events").child(eventId!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot)
            if let value = snapshot.value as? NSDictionary
            {
                print(value)
                self.eventDetailsDict.setDictionary(value as! [AnyHashable : Any])
                self.pipelineTblView.reloadData()
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
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
    
    
    //MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 6
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0;//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.pipelineTblView.separatorStyle = UITableViewCellSeparatorStyle.none
        // create a new cell if needed or reuse an old one
        let cell:EventDetailCell1 = self.pipelineTblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier1)  as! EventDetailCell1
        //let key = keysArrayUpcoming[indexPath.row]
        cell.eventLbl?.text = ""
        cell.placeLbl?.text = ""
        /*if let userData = self.eventDetailsDict.object(forKey: key)
        {
            cell.eventLbl?.text = ((userData as AnyObject).object(forKey: "Title") as! String?)!
            cell.placeLbl?.text = String(format: "Place: %@", ((userData as AnyObject).object(forKey: "Place") as! String?)!)
        }
        else
        {
            self.ref.child("events").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                if let value = snapshot.value as? NSDictionary
                {
                    print(value)
                    self.eventDetailsDict.setObject(value, forKey: key as NSCopying)
                    if let userData = self.eventDetailsDict.object(forKey: key)
                    {
                        cell.eventLbl?.text = ((userData as AnyObject).object(forKey: "Title") as! String?)!
                        cell.placeLbl?.text = String(format: "Place: %@", ((userData as AnyObject).object(forKey: "Place") as! String?)!)
                    }
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        }*/
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
    }
}
