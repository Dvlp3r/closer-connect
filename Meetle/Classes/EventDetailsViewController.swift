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
    @IBOutlet var testLbl: UILabel!
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
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    //MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 7
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.row==0)
        {
            return 65.0;
        }
        else if (indexPath.row==1)
        {
            return 65.0;
        }
        else if (indexPath.row==2)
        {
            return 50.0;
        }
        else if (indexPath.row==3)
        {
            return 150.0;
        }
        else if (indexPath.row==4)
        {
            return 65.0;
        }
        else if (indexPath.row==5)
        {
            if let urlData = self.eventDetailsDict.object(forKey: "URL") as? String
            {
                print (urlData)
                if (urlData != "<null>")
                {
                    let height = heightForView(text: String(format:"%@", urlData), font: self.testLbl.font, width: self.testLbl.frame.size.width)
                    print (height)
                    if (height > 40)
                    {
                        return height + 10.0
                    }
                    else
                    {
                        return 50.0
                    }
                }
            }
            return 0.0;
        }
        else
        {
            if let urlData = self.eventDetailsDict.object(forKey: "notes") as? String
            {
                print (urlData)
                if (urlData != "<null>")
                {
                    let height = heightForView(text: urlData, font: self.testLbl.font, width: self.testLbl.frame.size.width)
                    print (height)
                    if (height > 40)
                    {
                        return height + 10.0
                    }
                    else
                    {
                        return 50.0
                    }
                }
            }
            return 0.0;
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.pipelineTblView.separatorStyle = UITableViewCellSeparatorStyle.none
        // create a new cell if needed or reuse an old one
        
        if (indexPath.row==0)
        {
            let cell:EventDetailCell1 = self.pipelineTblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier1)  as! EventDetailCell1
            //let key = keysArrayUpcoming[indexPath.row]
            cell.eventLbl?.text = ""
            cell.placeLbl?.text = ""
            if let eventTitle = self.eventDetailsDict.object(forKey: "Title")
            {
                cell.eventLbl?.text = eventTitle as? String
            }
            if let eventPlace = self.eventDetailsDict.object(forKey: "Place")
            {
                cell.placeLbl?.text = String(format: "Place: %@", (eventPlace as? String)!)
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        else if (indexPath.row==1)
        {
            let cell:EventDetailCell2 = self.pipelineTblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier2)  as! EventDetailCell2
            //let key = keysArrayUpcoming[indexPath.row]
            cell.startDateLbl?.text = ""
            cell.endDateLbl?.text = ""
            if let startDate = self.eventDetailsDict.object(forKey: "Starts")
            {
                cell.startDateLbl?.text = startDate as? String
            }
            if let endDate = self.eventDetailsDict.object(forKey: "Ends")
            {
                cell.endDateLbl?.text = endDate as? String
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        else if (indexPath.row==2)
        {
            let cell:EventDetailCell3 = self.pipelineTblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier3)  as! EventDetailCell3
            //let key = keysArrayUpcoming[indexPath.row]
            cell.statusLbl?.text = ""
            if let statusData = self.eventParticipientDict.object(forKey: (Auth.auth().currentUser?.uid)!) as? NSDictionary
            {
                if let goingval = statusData.object(forKey: "IsGoing") as? NSNumber
                {
                    if (goingval.intValue == -1)
                    {
                        cell.statusSegmentedControl?.selectedSegmentIndex = -1
                        cell.statusSegmentedControl?.isHidden = false
                        cell.statusLbl?.isHidden = true
                    }
                    else
                    {
                        cell.statusSegmentedControl?.isHidden = true
                        cell.statusLbl?.isHidden = false
                        if (goingval.intValue == 0)
                        {
                            cell.statusLbl?.text = "Going"
                        }
                        else if (goingval.intValue == 1)
                        {
                            cell.statusLbl?.text = "May be going"
                        }
                        else
                        {
                            cell.statusLbl?.text = "Not going"
                        }
                        
                    }
                }
                else
                {
                    cell.statusSegmentedControl?.selectedSegmentIndex = -1
                    cell.statusSegmentedControl?.isHidden = false
                    cell.statusLbl?.isHidden = true
                }
            }
            else
            {
                cell.statusSegmentedControl?.selectedSegmentIndex = -1
                cell.statusSegmentedControl?.isHidden = false
                cell.statusLbl?.isHidden = true
            }
            //cell.placeLbl?.text = String(format: "Place: %@", (self.eventDetailsDict.object(forKey: "Place") as? String)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        else if (indexPath.row==3)
        {
            let cell:EventDetailCell4 = self.pipelineTblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier4)  as! EventDetailCell4
            //let key = keysArrayUpcoming[indexPath.row]
            //cell.eventLbl?.text = (self.eventDetailsDict.object(forKey: "Title") as? String
            print (self.eventParticipientDict)
            if let latLongArr = self.eventParticipientDict.object(forKey: "l") as? [NSNumber]
            {
                print(latLongArr)
                let latitude = latLongArr[0]
                print(latitude)
                let longitude = latLongArr[1]
                print(longitude)
                let string = String(format:"%@,%@",latitude, longitude)
                print(string)
                let mapString = String(format: "https://maps.googleapis.com/maps/api/staticmap?size=640x300&scale=2&markers=label:A|scale:2|%@",string)
                print(mapString)
                let urlStr : NSString = mapString.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
                print (urlStr)
                let url = URL(string: urlStr as String)
                print (url)
                LazyImage.show(imageView:cell.mapImage!, url:url?.absoluteString)
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        else if (indexPath.row==4)
        {
            let cell:EventDetailCell5 = self.pipelineTblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier5)  as! EventDetailCell5
            //let key = keysArrayUpcoming[indexPath.row]
            cell.repeatLbl?.text = ""
            cell.allDayLbl?.text = ""
            if let repeatEvent = self.eventDetailsDict.object(forKey: "Repeat")
            {
                cell.repeatLbl?.text = repeatEvent as? String
            }
            if let allDayEvent = self.eventDetailsDict.object(forKey: "All-day")
            {
                cell.allDayLbl?.text = allDayEvent as? String
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        else if (indexPath.row==5)
        {
            let cell:EventDetailCell6 = self.pipelineTblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier6)  as! EventDetailCell6
            //let key = keysArrayUpcoming[indexPath.row]
            cell.txtLbl?.text = ""
            if let urlData = self.eventDetailsDict.object(forKey: "URL")
            {
                cell.txtLbl?.text = urlData as? String
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        else
        {
            let cell:EventDetailCell6 = self.pipelineTblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier6)  as! EventDetailCell6
            //let key = keysArrayUpcoming[indexPath.row]
            cell.txtLbl?.text = ""
            if let notesData = self.eventDetailsDict.object(forKey: "notes")
            {
                cell.txtLbl?.text = notesData as? String
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
    }
}
