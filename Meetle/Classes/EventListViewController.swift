//
//  EventListViewController.swift
//  closer-connect
//
//  Created by Mahendra Singh on 6/14/17.
//  Copyright © 2017 AppsFoundation. All rights reserved.
//

import Foundation
import Firebase
import NVActivityIndicatorView
import FirebaseDatabase
import GeoFire
import CoreLocation

class EventListViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource,NVActivityIndicatorViewable, CLLocationManagerDelegate {
    //MARK: - IBOutlets
    @IBOutlet var pipelineTblView: UITableView!
    var ref: DatabaseReference!
    var circleQuery: GFCircleQuery?
    //MARK: - Variables & Constants
    var segmentControl : HMSegmentedControl!
    let segmentedControlClass:HMSegmentedControl = HMSegmentedControl()
    var myProfile: NSDictionary?
    let cellReuseIdentifier = "EventsCell"
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    //MARK: - Arrays & Dictionaries
    var eventsDictMy = NSMutableDictionary()
    var keysArrayMy = [String]()
    var eventsDictExplore = NSMutableDictionary()
    var keysArrayExplore = [String]()
    var eventsDictUpcoming = NSMutableDictionary()
    var keysArrayUpcoming = [String]()
    var eventDetailsDict = NSMutableDictionary()
    var pipelinesDict = NSMutableDictionary()
    var profilesDict = NSMutableDictionary()
    //MARK: -ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.currentUserId = Auth.auth().currentUser?.uid
        
        
        ref = Database.database().reference()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let center = CLLocation(latitude: 0.0, longitude: 0.0)
        let geofireRef = ref.child("eventsLocation")//.childByAutoId()//.child((Auth.auth().currentUser?.uid)!)
        let geoFire = GeoFire(firebaseRef: geofireRef)
        //geoFire?.setLocation(center, forKey: "FHVajYei3cQ5SbcTbHxYDSmnIOT2")
        print(geofireRef.url)
        //print(geoFire!)
        // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
        circleQuery = geoFire?.query(at: center, withRadius: 500.0)
        
        // Do any additional setup after loading the view.
        self.pipelineTblView.delegate = self
        self.pipelineTblView.dataSource = self
        
        
        self.segmentedControlClass.frame = CGRect (x:0 , y:0, width:self.view.frame.size.width ,height: 50)
        self.segmentedControlClass.backgroundColor = UIColor.white
        self.segmentedControlClass.sectionTitles = ["Upcoming", "Explore", "My Events"]
        self.segmentedControlClass.selectionIndicatorHeight = 4.0
        self.segmentedControlClass.selectionIndicatorColor = UIColor.red
        self.segmentedControlClass.segmentWidthStyle = HMSegmentedControlSegmentWidthStyle.fixed
        self.segmentedControlClass.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        self.segmentedControlClass.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        self.segmentedControlClass.isVerticalDividerEnabled = true
        self.segmentedControlClass.verticalDividerColor = UIColor.clear
        self.segmentedControlClass.verticalDividerWidth = 1.0
        self.segmentedControlClass.addTarget(self, action: #selector(self.segmentedControlChanged), for: .valueChanged)
        self.view.addSubview(self.segmentedControlClass)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            DispatchQueue.main.async {
                self.locationManager.startUpdatingLocation()
            }
            
        }
        else
        {
            //self.displayAlertMessage(messageToDisplay:  "Please Turn on location services for this app from settings to see malls in your city")
            
        }
        
        
        self.ref.child("eventsLocation").queryOrdered(byChild: (Auth.auth().currentUser?.uid)!).queryEqual(toValue: true).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot)
            if let value = snapshot.value as? NSDictionary
            {
                print(value)
                self.eventsDictUpcoming.setDictionary(value as! [AnyHashable : Any])
                self.keysArrayUpcoming = self.eventsDictUpcoming.allKeys as! [String]
                self.pipelineTblView.reloadData()
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("MyEvents").queryOrdered(byChild: "StartDate").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot)
            if let value = snapshot.value as? NSDictionary
            {
                print(value)
                self.eventsDictMy.setDictionary(value as! [AnyHashable : Any])
                self.keysArrayMy = self.eventsDictMy.allKeys as! [String]
                self.pipelineTblView.reloadData()
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        self.startObservingAllData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        circleQuery?.removeAllObservers()
    }
    func startObservingAllData()
    {
        
        circleQuery?.removeAllObservers()
        circleQuery?.observe(.keyEntered, with: { (key: String?, location: CLLocation?) in
            print("In KeyEntered block ")
            print("Key '\(key)' entered the search area and is at location '\(location)'")
            self.ref.child("eventsLocation").child(key! as String).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                if let value = snapshot.value as? NSDictionary
                {
                    print(value)
                    if value.object(forKey: (Auth.auth().currentUser?.uid)!) != nil
                    {
                        self.eventsDictExplore.setObject(value, forKey: key as! NSCopying)
                        self.keysArrayExplore = self.eventsDictExplore.allKeys as! [String]
                        self.pipelineTblView.reloadData()
                    }
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        })
        
        circleQuery?.observe(.keyMoved, with: { (key: String?, location: CLLocation?) in
            print("In KeyEntered block ")
            print("Key '\(key)' entered the search area and is at location '\(location)'")
            self.ref.child("eventsLocation").child(key! as String).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                if let value = snapshot.value as? NSDictionary
                {
                    print(value)
                    if value.object(forKey: (Auth.auth().currentUser?.uid)!) == nil
                    {
                        self.eventsDictExplore.setObject(value, forKey: key as! NSCopying)
                        self.keysArrayExplore = self.eventsDictExplore.allKeys as! [String]
                        self.pipelineTblView.reloadData()
                    }
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        })
        
        circleQuery?.observe(.keyExited, with: { (key: String?, location: CLLocation?) in
            print("In KeyEntered block ")
            print("Key '\(key)' entered the search area and is at location '\(location)'")
            self.eventsDictExplore.removeObject(forKey: key!)
            self.keysArrayExplore = self.eventsDictExplore.allKeys as! [String]
            self.pipelineTblView.reloadData()
        })
    }
    func segmentedControlChanged(hmSegmentControl : HMSegmentedControl) -> Void {
        
        self.pipelineTblView.reloadData()
    }
    //MARK: - Private Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        currentLocation = manager.location!
        self.locationManager.stopUpdatingLocation()
        let geofireRef = ref.child("locations")//.childByAutoId()//.child((Auth.auth().currentUser?.uid)!)
        let geoFire = GeoFire(firebaseRef: geofireRef)
        geoFire?.setLocation(currentLocation, forKey: (Auth.auth().currentUser?.uid)!)
        //geoFire?.setLocation(currentLocation, forKey: "FHVajYei3cQ5SbcTbHxYDSmnIOT2")
        circleQuery?.center = currentLocation
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
        else
        {
            //self.displayAlertMessage(messageToDisplay:  "Please Turn on location services for this app from settings to see malls in your city")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
        //self.displayAlertMessage(messageToDisplay:  "Please Turn on location services for this app from settings to see malls in your city")
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
    @IBAction func AddEventPressed(sender: UIButton)
    {
        self.startAnimating()
        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("Requests").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Success
            print(snapshot)
            if let value = snapshot.value as? NSDictionary
            {
                print(value)
                self.pipelinesDict.setDictionary(value as! [AnyHashable : Any])
                print(self.pipelinesDict);
                self.profilesDict.removeAllObjects()
                if (self.pipelinesDict.allKeys.count > 0)
                {
                    for key in self.pipelinesDict.allKeys
                    {
                        if let val = self.pipelinesDict.object(forKey: key)
                        {
                            if (val as! String != "Friend")
                            {
                                self.pipelinesDict.removeObject(forKey: key)
                                if (self.pipelinesDict.allKeys.count == self.profilesDict.allKeys.count)
                                {
                                    DispatchQueue.main.async {
                                        self.stopAnimating()
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let rootViewController = storyboard.instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
                                        rootViewController.keysArray = self.profilesDict.allKeys as! [String]
                                        rootViewController.profilesDict = self.profilesDict
                                        self.navigationController?.pushViewController(rootViewController, animated: true)
                                    }
                                }
                            }
                            else
                            {
                                if self.profilesDict.object(forKey: key) != nil
                                {
                                    if (self.pipelinesDict.allKeys.count == self.profilesDict.allKeys.count)
                                    {
                                        DispatchQueue.main.async {
                                            self.stopAnimating()
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let rootViewController = storyboard.instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
                                            rootViewController.keysArray = self.profilesDict.allKeys as! [String]
                                            rootViewController.profilesDict = self.profilesDict
                                            self.navigationController?.pushViewController(rootViewController, animated: true)
                                        }
                                    }
                                }
                                else
                                {
                                    self.ref.child("users").child(key as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                                        // Get user value
                                        if let value = snapshot.value as? NSDictionary
                                        {
                                            self.profilesDict.setObject(value, forKey: key as! NSCopying)
                                            if (self.pipelinesDict.allKeys.count == self.profilesDict.allKeys.count)
                                            {
                                                DispatchQueue.main.async {
                                                    self.stopAnimating()
                                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
                                                    rootViewController.keysArray = self.profilesDict.allKeys as! [String]
                                                    rootViewController.profilesDict = self.profilesDict
                                                    self.navigationController?.pushViewController(rootViewController, animated: true)
                                                }
                                            }
                                        }
                                        // ...
                                    }) { (error) in
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        }
                        
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        self.stopAnimating()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let rootViewController = storyboard.instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
                        rootViewController.keysArray = self.profilesDict.allKeys as! [String]
                        rootViewController.profilesDict = self.profilesDict
                        self.navigationController?.pushViewController(rootViewController, animated: true)
                    }
                }
                
            }
            else
            {
                DispatchQueue.main.async {
                    self.stopAnimating()
                    DispatchQueue.main.async {
                        self.stopAnimating()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let rootViewController = storyboard.instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
                        rootViewController.keysArray = self.profilesDict.allKeys as! [String]
                        rootViewController.profilesDict = self.profilesDict
                        self.navigationController?.pushViewController(rootViewController, animated: true)
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    @IBAction func selectionButtonClicked(sender: UIButton) {
        let location = self.pipelineTblView.convert(sender.bounds.origin, from:sender)
        let indexPath = self.pipelineTblView.indexPathForRow(at: location)
        /*if let cell = self.pipelineTblView.cellForRow(at: indexPath!) as? PipelineTableViewCell
         {
         
         }*/
        
    }
    //MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (segmentedControlClass.selectedSegmentIndex==0)
        {
            if (keysArrayUpcoming.count) > 0
            {
                return  keysArrayUpcoming.count
            }
            self.pipelineTblView.separatorStyle = UITableViewCellSeparatorStyle.none
            return 0
        }
        else if (segmentedControlClass.selectedSegmentIndex==1)
        {
            if (keysArrayExplore.count) > 0
            {
                return  keysArrayExplore.count
            }
            self.pipelineTblView.separatorStyle = UITableViewCellSeparatorStyle.none
            return 0
        }
        else
        {
            if (keysArrayMy.count) > 0
            {
                return  keysArrayMy.count
            }
            self.pipelineTblView.separatorStyle = UITableViewCellSeparatorStyle.none
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0;//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.pipelineTblView.separatorStyle = UITableViewCellSeparatorStyle.none
        // create a new cell if needed or reuse an old one
        if (segmentedControlClass.selectedSegmentIndex==0)
        {
            let cell:EventsCell = self.pipelineTblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)  as! EventsCell
            let key = keysArrayUpcoming[indexPath.row]
            cell.eventLbl?.text = ""
            cell.placeLbl?.text = ""
            if let userData = self.eventDetailsDict.object(forKey: key)
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
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        else if (segmentedControlClass.selectedSegmentIndex==1)
        {
            let cell:EventsCell = self.pipelineTblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)  as! EventsCell
            let key = keysArrayExplore[indexPath.row]
            cell.eventLbl?.text = ""
            cell.placeLbl?.text = ""
            if let userData = self.eventDetailsDict.object(forKey: key)
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
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        else
        {
            let cell:EventsCell = self.pipelineTblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)  as! EventsCell
            let key = keysArrayMy[indexPath.row]
            cell.eventLbl?.text = ""
            cell.placeLbl?.text = ""
            if let userData = self.eventDetailsDict.object(forKey: key)
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
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        if (segmentedControlClass.selectedSegmentIndex==0)
        {
            let cell:EventsCell = self.pipelineTblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)  as! EventsCell
            let key = keysArrayUpcoming[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
            rootViewController.eventId = key
            self.navigationController?.pushViewController(rootViewController, animated: true)
        }
        else if (segmentedControlClass.selectedSegmentIndex==1)
        {
            let cell:EventsCell = self.pipelineTblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)  as! EventsCell
            let key = keysArrayExplore[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
            rootViewController.eventId = key
            self.navigationController?.pushViewController(rootViewController, animated: true)
        }
        else
        {
            let cell:EventsCell = self.pipelineTblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)  as! EventsCell
            let key = keysArrayMy[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
            rootViewController.eventId = key
            self.navigationController?.pushViewController(rootViewController, animated: true)
        }
    }
}
