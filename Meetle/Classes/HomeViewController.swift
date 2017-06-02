//
//  HomeViewController.swift
//  Meetle
//
//  Created by AppsFoundation on 8/6/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit
import QuartzCore
import FirebaseDatabase
import GeoFire
import Firebase
import CoreLocation
import NVActivityIndicatorView

class HomeViewController: BaseViewController, NVActivityIndicatorViewable, CLLocationManagerDelegate {

	@IBOutlet weak var scrollView: UIScrollView?
	@IBOutlet weak var pageControl: UIPageControl?
	@IBOutlet weak var likeButton: UIButton?
	@IBOutlet weak var nextButton: UIButton?
    @IBOutlet weak var infoButton: UIButton?
    @IBOutlet weak var locationLbl: UILabel?
    @IBOutlet weak var locationTxtLbl: UILabel?
    @IBOutlet weak var locationIcon: UIImageView?

    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var profilesDict = NSMutableDictionary()
    var ref: DatabaseReference!
    var circleQuery: GFCircleQuery?
    var currentProfile: NSDictionary?
    
	fileprivate let pageViews: NSMutableArray = NSMutableArray(objects: NSNull(), NSNull(), NSNull())
	fileprivate let imageNames = ["jessy", "man", "Veronika"]
	fileprivate let centerImageView: UIImageView = UIImageView(image: UIImage(named: "jessy"))
	fileprivate let leftImageView: UIImageView = UIImageView(image: UIImage(named: "like_text"))
	fileprivate let rightImageView: UIImageView = UIImageView(image: UIImage(named: "next_text"))

    override func viewDidLoad() {
        super.viewDidLoad()
		initMessageIcon()
		initImageView()
        
        
        
        
        ref = Database.database().reference()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
            self.displayAlertMessage(messageToDisplay:  "Please Turn on location services for this app from settings to see malls in your city")
            
        }
        self.locationLbl?.isHidden=true
        self.locationTxtLbl?.isHidden=true
        self.locationIcon?.isHidden=true
        self.infoButton?.isHidden=true
        self.likeButton?.isHidden=true
        self.nextButton?.isHidden=true
        
        let center = CLLocation(latitude: 0.0, longitude: 0.0)
        let geofireRef = ref.child("locations")//.childByAutoId()//.child((Auth.auth().currentUser?.uid)!)
        let geoFire = GeoFire(firebaseRef: geofireRef)
        //geoFire?.setLocation(center, forKey: "FHVajYei3cQ5SbcTbHxYDSmnIOT2")
        print(geofireRef.url)
        //print(geoFire!)
        // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
        circleQuery = geoFire?.query(at: center, withRadius: 5.6)
        //self.startAnimating()
        circleQuery?.observe(.keyEntered, with: { (key: String?, location: CLLocation?) in
            print("In KeyEntered block ")
            print("Key '\(key)' entered the search area and is at location '\(location)'")
            if (key != (Auth.auth().currentUser?.uid)!)
            {
                self.ref.child("users").child(key!).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    if (value != nil)
                    {
                        self.locationLbl?.isHidden=false
                        self.locationTxtLbl?.isHidden=false
                        self.locationIcon?.isHidden=false
                        self.infoButton?.isHidden=false
                        self.likeButton?.isHidden=false
                        self.nextButton?.isHidden=false
                        self.profilesDict.setObject(value!, forKey: key as! NSCopying)
                        print(self.profilesDict)
                        if (self.profilesDict.allKeys.count==1)
                        {
                            self.initScrollImageView()
                        }
                    }
                    // ...
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        })
        
        circleQuery?.observe(.keyMoved, with: { (key: String?, location: CLLocation?) in
            print("In KeyEntered block ")
            print("Key '\(key)' entered the search area and is at location '\(location)'")
            if (key != (Auth.auth().currentUser?.uid)!)
            {
                self.ref.child("users").child(key!).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    if (value != nil)
                    {
                        self.profilesDict.setObject(value!, forKey: key as! NSCopying)
                    }
                    // ...
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        })
        
        circleQuery?.observe(.keyExited, with: { (key: String?, location: CLLocation?) in
            print("In KeyEntered block ")
            print("Key '\(key)' entered the search area and is at location '\(location)'")
            self.profilesDict.removeObject(forKey: key!)
        })
        
       /* circleQuery?.observeReady({
            print("All initial data has been loaded and events have been fired!")
        })*/
        
        
        
        
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
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		//initScrollImageView()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	func initImageView() {
		leftImageView.backgroundColor = ThemeManager.profileLikeBackgroundColor()
		rightImageView.backgroundColor = ThemeManager.profileNextBackgroundColor()
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
            self.displayAlertMessage(messageToDisplay:  "Please Turn on location services for this app from settings to see malls in your city")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
        self.displayAlertMessage(messageToDisplay:  "Please Turn on location services for this app from settings to see malls in your city")
    }
    func getPlacemark(user: String) {
        self.locationLbl?.isHidden=true
        self.locationTxtLbl?.isHidden=true
        self.locationIcon?.isHidden=true
        self.ref.child("locations").child(user).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if (value != nil)
            {
                let locationArr = value?.object(forKey: "l") as! NSArray
                
                let location = CLLocation(latitude: locationArr[0] as! CLLocationDegrees, longitude: locationArr[1] as! CLLocationDegrees)
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                    print(location)
                    
                    if error != nil {
                        self.locationLbl?.isHidden=true
                        self.locationTxtLbl?.isHidden=true
                        self.locationIcon?.isHidden=true
                        print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                        return
                        
                    }
                    
                    if (placemarks?.count)! > 0 {
                        let pm = placemarks?[0] as CLPlacemark!
                        print((pm?.locality!)! as String)
                        self.locationLbl?.text = (pm?.locality)!
                        //self.AlertMessage(messageToDisplay:  String(format: "Current Location: %@",(pm?.locality!)!))
                        self.locationLbl?.isHidden=false
                        self.locationTxtLbl?.isHidden=false
                        self.locationIcon?.isHidden=false
                    }
                    else {
                        self.locationLbl?.isHidden=true
                        self.locationTxtLbl?.isHidden=true
                        self.locationIcon?.isHidden=true
                        print("Problem with the data received from geocoder")
                    }
                })
                if (self.profilesDict.allKeys.count==1)
                {
                    self.initScrollImageView()
                }
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
	func initScrollImageView() {
		let pagesScrollViewSize = scrollView!.frame.size
		scrollView!.contentSize = CGSize(width: pagesScrollViewSize.width * 2.0, height: pagesScrollViewSize.height)
		
        let size = scrollView!.bounds.size

        leftImageView.contentMode = UIViewContentMode.center
        leftImageView.frame = CGRect(x: 0.0, y: 0.0, width: size.width / 2.0, height: size.height)
        scrollView?.addSubview(leftImageView)
		
        centerImageView.contentMode = UIViewContentMode.scaleAspectFill
		centerImageView.frame = CGRect(x: size.width / 2.0, y: 0.0, width: size.width, height: size.height)
		scrollView?.addSubview(centerImageView)
		
        rightImageView.contentMode = UIViewContentMode.center
		rightImageView.frame = CGRect(x: size.width * 1.5, y: 0.0, width: size.width / 2.0, height: size.height)
		scrollView?.addSubview(rightImageView)
		
		scrollView!.setContentOffset(CGPoint(x: pagesScrollViewSize.width / 2.0, y: 0.0), animated: false)
	}
	
	//MARK: - User actions
	
	@IBAction func likeButtonPressed(_ sender: AnyObject) {
		print("likeButtonPressed")
	}
	
	@IBAction func nextButtonPressed(_ sender: AnyObject) {
		print("nextButtonPressed")
	}
}

// MARK: - UIScrollViewDelegate

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        likeButton?.isHidden = true
        nextButton?.isHidden = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let pagesScrollViewSize = scrollView.frame.size
            scrollView.setContentOffset(CGPoint(x: pagesScrollViewSize.width / 2.0, y: 0.0), animated: true)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        //let r = Int(arc4random() % 3)
        if scrollView.contentOffset.x < 0 {
            print("like")
            for (key, myValue) in self.profilesDict
            {
                print(key)
                
                let pro = myValue as! NSDictionary
                self.title = pro.object(forKey: "Name") as! String?
                getPlacemark(user: key as! String)
                if let imageArr = pro.object(forKey: "Photos" as NSString)
                {
                    let imgArr = imageArr as! NSArray
                    LazyImage.show(imageView:centerImageView, url:imgArr[0] as? String)
                    break
                }
            }
            
        } else if scrollView.contentOffset.x > scrollView.frame.size.width {
            
            print("next")
            for (key, myValue) in self.profilesDict
            {
                print(key)
                let pro = myValue as! NSDictionary
                self.title = pro.object(forKey: "Name") as! String?
                getPlacemark(user: key as! String)
                if let imageArr = pro.object(forKey: "Photos" as NSString)
                {
                    let imgArr = imageArr as! NSArray
                    LazyImage.show(imageView:centerImageView, url:imgArr[0] as? String)
                    break
                }
            }
            //centerImageView.image = UIImage(named: imageNames[r])
        }
        
        if scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.frame.size.width {
            let transition = CATransition()
            transition.duration = 1.0
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            centerImageView.layer.add(transition, forKey: nil)
        }
        
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.setContentOffset(CGPoint(x: pagesScrollViewSize.width / 2.0, y: 0.0), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == scrollView.frame.size.width / 2.0 {
            likeButton?.isHidden = false
            nextButton?.isHidden = false
        } else if scrollView.contentOffset.x < 0.0 {
            scrollView.backgroundColor = ThemeManager.profileLikeBackgroundColor()
        } else if scrollView.contentOffset.x > scrollView.frame.size.width {
            scrollView.backgroundColor = ThemeManager.profileNextBackgroundColor()
        }
    }
}
