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
    var eventsDict = NSMutableDictionary()
    var pipelinesDict = NSMutableDictionary()
    var profilesDict = NSMutableDictionary()
    var keysArray = [String]()

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
        self.segmentedControlClass.sectionTitles = ["Upcoming", "Explore"]
        self.segmentedControlClass.selectionIndicatorHeight = 4.0
        self.segmentedControlClass.selectionIndicatorColor = UIColor.red
        self.segmentedControlClass.segmentWidthStyle = HMSegmentedControlSegmentWidthStyle.fixed
        self.segmentedControlClass.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        self.segmentedControlClass.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        self.segmentedControlClass.isVerticalDividerEnabled = true
        self.segmentedControlClass.verticalDividerColor = UIColor.clear
        self.segmentedControlClass.verticalDividerWidth = 1.0
        self.segmentedControlClass.addTarget(self, action: #selector(getter: self.segmentedControlClass), for: .valueChanged)
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
        self.ref.child("events").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let value = snapshot.value as? NSDictionary
            {
                print(value)
                self.eventsDict.setDictionary(value as! [AnyHashable : Any])
                self.keysArray = self.eventsDict.allKeys as! [String]
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
            /*if (key != (Auth.auth().currentUser?.uid)!)
            {
                self.ref.child("eventsLocation").child(key!).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    if let value = snapshot.value as? NSDictionary
                    {
                        if (self.currentProfile == nil)
                        {
                            self.currentProfile = key
                            self.title = value.object(forKey: "Name") as! String?
                            self.getPlacemark(user: key!)
                            if let imageArr = value.object(forKey: "Photos" as NSString)
                            {
                                let imgArr = imageArr as! NSArray
                                LazyImage.show(imageView:self.centerImageView, url:imgArr[0] as? String)
                            }
                        }
                        self.profilesDict.setObject(value, forKey: key as! NSCopying)
                    }
                    // ...
                }) { (error) in
                    print(error.localizedDescription)
                }
            }*/
        })
        
        circleQuery?.observe(.keyMoved, with: { (key: String?, location: CLLocation?) in
            print("In KeyEntered block ")
            print("Key '\(key)' entered the search area and is at location '\(location)'")
            if (key != (Auth.auth().currentUser?.uid)!)
            {
                
            }
        })
        
        circleQuery?.observe(.keyExited, with: { (key: String?, location: CLLocation?) in
            print("In KeyEntered block ")
            print("Key '\(key)' entered the search area and is at location '\(location)'")
            //self.profilesDict.removeObject(forKey: key!)
        })
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
                for key in self.pipelinesDict.allKeys
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
            else
            {
                DispatchQueue.main.async {
                    self.stopAnimating()
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
        let cell:EventsCell = self.pipelineTblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)  as! EventsCell
        let key = keysArray[indexPath.row]
        cell.eventLbl?.text = ""
        cell.placeLbl?.text = ""
        if let userData = self.eventsDict.object(forKey: key)
        {
            cell.eventLbl?.text = ((userData as AnyObject).object(forKey: "Title") as! String?)!
            cell.placeLbl?.text = String(format: "Place: %@", ((userData as AnyObject).object(forKey: "Place") as! String?)!)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        
        
        
    }
}
