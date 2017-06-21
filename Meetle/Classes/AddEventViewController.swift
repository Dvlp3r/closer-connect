//
//  AddEventViewController.swift
//  closer-connect
//
//  Created by Mahendra Singh on 6/15/17.
//  Copyright © 2017 AppsFoundation. All rights reserved.
//

import Foundation
import Eureka
import CoreLocation
import Firebase
import FirebaseDatabase
import GeoFire

class AddEventViewController : FormViewController {
    
    var ref: DatabaseReference!
    var profilesDict = NSMutableDictionary()
    var keysArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //keysArray = ["asdasdasdas","erewrwerwer", "adaddasdasd"]
        ref = Database.database().reference()
        initializeForm()
        //navigationItem.leftBarButtonItem?.target = self
        //navigationItem.leftBarButtonItem?.action = #selector(NativeEventFormViewController.cancelTapped(_:))
    }
    private func initializeForm() {
        //MARK: Emoji
        
        form +++
            TextRow("Title").cellSetup { cell, row in
                cell.textField.placeholder = row.tag
            }
            
            <<< TextRow("Place").cellSetup {
                $1.cell.textField.placeholder = $0.row.tag
            }
            
            +++
            
            LocationRow("Location"){
                $0.title = "Location"
                $0.value = CLLocation(latitude: -34.91, longitude: -56.1646)
            }
            <<< SwitchRow("All-day") {
                $0.title = $0.tag
                }.onChange { [weak self] row in
                    let startDate: DateTimeInlineRow! = self?.form.rowBy(tag: "Starts")
                    let endDate: DateTimeInlineRow! = self?.form.rowBy(tag: "Ends")
                    
                    if row.value ?? false {
                        startDate.dateFormatter?.dateStyle = .medium
                        startDate.dateFormatter?.timeStyle = .none
                        endDate.dateFormatter?.dateStyle = .medium
                        endDate.dateFormatter?.timeStyle = .none
                    }
                    else {
                        startDate.dateFormatter?.dateStyle = .short
                        startDate.dateFormatter?.timeStyle = .short
                        endDate.dateFormatter?.dateStyle = .short
                        endDate.dateFormatter?.timeStyle = .short
                    }
                    startDate.updateCell()
                    endDate.updateCell()
                    startDate.inlineRow?.updateCell()
                    endDate.inlineRow?.updateCell()
            }
            
            <<< DateTimeInlineRow("Starts") {
                $0.title = $0.tag
                $0.value = Date().addingTimeInterval(60*60*24)
                }
                .onChange { [weak self] row in
                    let endRow: DateTimeInlineRow! = self?.form.rowBy(tag: "Ends")
                    if row.value?.compare(endRow.value!) == .orderedDescending {
                        endRow.value = Date(timeInterval: 60*60*24, since: row.value!)
                        endRow.cell!.backgroundColor = .white
                        endRow.updateCell()
                    }
                }
                .onExpandInlineRow { [weak self] cell, row, inlineRow in
                    inlineRow.cellUpdate() { cell, row in
                        let allRow: SwitchRow! = self?.form.rowBy(tag: "All-day")
                        if allRow.value ?? false {
                            cell.datePicker.datePickerMode = .date
                        }
                        else {
                            cell.datePicker.datePickerMode = .dateAndTime
                        }
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
            }
            
            <<< DateTimeInlineRow("Ends"){
                $0.title = $0.tag
                $0.value = Date().addingTimeInterval(60*60*25)
                }
                .onChange { [weak self] row in
                    let startRow: DateTimeInlineRow! = self?.form.rowBy(tag: "Starts")
                    if row.value?.compare(startRow.value!) == .orderedAscending {
                        row.cell!.backgroundColor = .red
                    }
                    else{
                        row.cell!.backgroundColor = .white
                    }
                    row.updateCell()
                }
                .onExpandInlineRow { [weak self] cell, row, inlineRow in
                    inlineRow.cellUpdate { cell, dateRow in
                        let allRow: SwitchRow! = self?.form.rowBy(tag: "All-day")
                        if allRow.value ?? false {
                            cell.datePicker.datePickerMode = .date
                        }
                        else {
                            cell.datePicker.datePickerMode = .dateAndTime
                        }
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
        }
        
        form +++
            
            PushRow<RepeatInterval>("Repeat") {
                $0.title = $0.tag
                $0.options = RepeatInterval.allValues
                $0.value = .Never
                }.onPresent({ (_, vc) in
                    vc.enableDeselection = false
                    vc.dismissOnSelection = false
                })
        
        form +++
            
            PushRow<EventAlert>() {
                $0.title = "Alert"
                $0.options = EventAlert.allValues
                $0.value = .Never
                }
                .onPresent({ (_, vc) in
                    vc.enableDeselection = false
                    vc.dismissOnSelection = false
                })
                .onChange { [weak self] row in
                    if row.value == .Never {
                        if let second : PushRow<EventAlert> = self?.form.rowBy(tag: "Another Alert"), let secondIndexPath = second.indexPath {
                            row.section?.remove(at: secondIndexPath.row)
                        }
                    }
                    else{
                        guard let _ : PushRow<EventAlert> = self?.form.rowBy(tag: "Another Alert") else {
                            let second = PushRow<EventAlert>("Another Alert") {
                                $0.title = $0.tag
                                $0.value = .Never
                                $0.options = EventAlert.allValues
                            }
                            row.section?.insert(second, at: row.indexPath!.row + 1)
                            return
                        }
                    }
        }
        
        form +++
            MultipleSelectorRow<String>("Invities") { row in
                row.title = "Invite Friends"
                row.options = self.keysArray
                row.cellUpdate { cell, row in
                        if (row.value != nil)
                        {
                            if (row.value!.count == 0)
                            {
                                cell.detailTextLabel?.text =  ""
                            }
                            else if (row.value!.count == 1)
                            {
                                cell.detailTextLabel?.text =  String(format: "%d friend",row.value!.count)
                            }
                            else
                            {
                                cell.detailTextLabel?.text =  String(format: "%d friends",row.value!.count)
                            }
                            
                        }
                    else
                        {
                            cell.detailTextLabel?.text =  ""
                    }
                }
                row.onPresent({ from, to in
                    // Decode the value in row title
                    to.selectableRowCellSetup = { cell, row in
                        if let value = row.selectableValue {
                            if let userData = self.profilesDict.object(forKey: value)
                            {
                                row.title = ((userData as AnyObject).object(forKey: "Name") as! String?)!
                            }
                        }
                    }
                })
        }
        
        
        form +++
            
            URLRow("URL") {
                $0.placeholder = "URL"
            }
            
            <<< TextAreaRow("notes") {
                $0.placeholder = "Notes"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 50)
        }
        
    }
    func multipleSelectorDone(_ item:UIBarButtonItem) {
            _ = navigationController?.popViewController(animated: true)
    }
    func cancelTapped(_ barButtonItem: UIBarButtonItem) {
        //(navigationController as? NativeEventNavigationController)?.onDismissCallback?(self)
    }
    @IBAction func SavePressed(_ sender: UIBarButtonItem) {
        //(navigationController as? NativeEventNavigationController)?.onDismissCallback?(self)
//        
//        let row: MultipleSelectorRow <String> = form.rowBy(tag: "Invities")!
//        let value = row.value
//        print (value)
        
        
        let valuesDictionary = form.values() as NSDictionary
        print(valuesDictionary)
        
        
        
        if valuesDictionary.object(forKey: "Title") as? String != nil
        {
            if valuesDictionary.object(forKey: "Place") as? String != nil
            {
                let keyValueDict = NSMutableDictionary ()
                for key in valuesDictionary.allKeys
                {
                    if let val = valuesDictionary.object(forKey: key)
                    {
                        let keyStr = key as! String
                        if (keyStr == "Invities")
                        {
                            
                        }
                        else
                        {
                            let value = String(format:"%@", val as! CVarArg)
                            keyValueDict.setObject(value, forKey: keyStr as NSCopying)
                        }
                        
                    }
                }
                let timeInterval = Date().timeIntervalSince1970
                print(timeInterval)
                let eventId = String(format: "%@%d",(Auth.auth().currentUser?.uid)!, timeInterval)
                print(eventId)
                self.ref.child("events").child(eventId).setValue(keyValueDict, withCompletionBlock: { (error, ref) -> Void in
                    if (!(error != nil))
                    {
                        let locationVal = valuesDictionary.object(forKey: "Location")
                        let geofireRef = self.ref.child("eventsLocation")//.childByAutoId()//.child((Auth.auth().currentUser?.uid)!)
                        let geoFire = GeoFire(firebaseRef: geofireRef)
                        geoFire?.setLocation(locationVal as! CLLocation!, forKey: eventId)
                        
                        if let second : MultipleSelectorRow <String> = self.form.rowBy(tag: "Invities"){
                            if let participients = second.value
                            {
                                print (participients)
                                //print ((val as AnyObject).map({ $0.first! }) ?? [])
                                var ct = 0
                                for item in participients
                                {
                                    self.ref.child("eventsLocation").child(eventId).child(item).setValue(["Invited": true, "IsGoing": -1], withCompletionBlock: { (error, ref) -> Void in
                                        if (!(error != nil))
                                        {
                                            ct += 1
                                            if (ct == participients.count)
                                            {
                                                let startDate = valuesDictionary.object(forKey: "Starts")
                                                let startDateStr = String(format:"%@", startDate as! CVarArg)
                                                self.ref.child("eventsLocation").child(eventId).child("StartDate").setValue(startDateStr, withCompletionBlock: { (error, ref) -> Void in
                                                    if (!(error != nil))
                                                    {
                                                        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("MyEvents").child(eventId).child("StartDate").setValue(startDateStr, withCompletionBlock: { (error, ref) -> Void in
                                                            if (!(error != nil))
                                                            {
                                                                self.navigationController?.popViewController(animated: true)
                                                            }
                                                        })
                                                    }
                                                })
                                            }
                                        }
                                    })
                                }
                            }
                            else
                            {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        else
                        {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                })
            }
            else
            {
                self.displayAlertMessage(messageToDisplay:  "Please add place of event.")
            }
        }
        else
        {
            self.displayAlertMessage(messageToDisplay:  "Please add title to event.")
        }
        
    }
    func displayAlertMessage(messageToDisplay: String)
    {
        let alertController = UIAlertController(title: "Message", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    enum RepeatInterval : String, CustomStringConvertible {
        case Never = "Never"
        case Every_Day = "Every Day"
        case Every_Week = "Every Week"
        case Every_2_Weeks = "Every 2 Weeks"
        case Every_Month = "Every Month"
        case Every_Year = "Every Year"
        
        var description : String { return rawValue }
        
        static let allValues = [Never, Every_Day, Every_Week, Every_2_Weeks, Every_Month, Every_Year]
    }
    
    enum EventAlert : String, CustomStringConvertible {
        case Never = "None"
        case At_time_of_event = "At time of event"
        case Five_Minutes = "5 minutes before"
        case FifTeen_Minutes = "15 minutes before"
        case Half_Hour = "30 minutes before"
        case One_Hour = "1 hour before"
        case Two_Hour = "2 hours before"
        case One_Day = "1 day before"
        case Two_Days = "2 days before"
        
        var description : String { return rawValue }
        
        static let allValues = [Never, At_time_of_event, Five_Minutes, FifTeen_Minutes, Half_Hour, One_Hour, Two_Hour, One_Day, Two_Days]
    }
    
    enum EventState {
        case busy
        case free
        
        static let allValues = [busy, free]
    }
}
