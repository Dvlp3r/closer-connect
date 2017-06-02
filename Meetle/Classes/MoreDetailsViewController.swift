//
//  MoreDetailsViewController.swift
//  closer-connect
//
//  Created by Mahendra Singh on 5/30/17.
//  Copyright © 2017 AppsFoundation. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import CoreLocation
import NVActivityIndicatorView
import GeoFire

class MoreDetailsViewController: UIViewController, NVActivityIndicatorViewable, CLLocationManagerDelegate  {
    
    //Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var ref: DatabaseReference!
    var name = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.removeFromSuperview()
        
        if name != ""
        {
            nameTextField.text = name
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        dobTextField.text = formatter.string(from: datePicker.date)
        
        ref = Database.database().reference()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        dobTextField.inputAccessoryView = toolBar
        dobTextField.inputView = datePicker
        
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
    }
    //MARK: - Location Manager Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        currentLocation = manager.location!
        self.locationManager.stopUpdatingLocation()
        let geofireRef = ref.child("locations")//.childByAutoId()//.child((Auth.auth().currentUser?.uid)!)
        let geoFire = GeoFire(firebaseRef: geofireRef)
        geoFire?.setLocation(currentLocation, forKey: (Auth.auth().currentUser?.uid)!)
        
    }
    func donePicker () {
        
        self.view.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        dobTextField.text = formatter.string(from: datePicker.date)
    }
    func cancelPicker () {
        
        self.view.endEditing(true)
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
    //Sign Up Action for email
    @IBAction func createAccountAction(_ sender: AnyObject) {
        if nameTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your name", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        else if dobTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your date of birth", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        else
        {
            self.startAnimating()
            
            DispatchQueue.global(qos: .background).async {
                if let user = Auth.auth().currentUser
                {
                    var yourArray = [String]()
                    yourArray.append("https://organicthemes.com/demo/profile/files/2012/12/profile_img.png")
                    yourArray.append("http://www.qygjxz.com/data/out/190/6179593-profile-pics.jpg")
                    yourArray.append("http://wallpaper-gallery.net/images/profile-pics/profile-pics-18.jpg")
                    
                    
                    if (self.currentLocation != nil)
                    {
                        self.ref.child("users").child(user.uid).setValue(["Name": self.nameTextField.text!, "DOB": self.dobTextField.text!,  "Gender": self.genderSegment.selectedSegmentIndex,  "Latitude": self.currentLocation.coordinate.latitude,  "Longitude": self.currentLocation.coordinate.longitude,  "Photos": yourArray])
                        DispatchQueue.main.async {
                            self.stopAnimating()
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let rootViewController: AnyObject! = storyboard.instantiateViewController(withIdentifier: "rootViewController")
                            if let window = UIApplication.shared.keyWindow{
                                window.rootViewController = rootViewController! as? UIViewController
                            }
                        }
                    }
                    else
                    {
                        self.ref.child("users").child(user.uid).setValue(["Name": self.nameTextField.text!, "DOB": self.dobTextField.text!,  "Gender": self.genderSegment.selectedSegmentIndex, "Photos": yourArray])
                        DispatchQueue.main.async {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let rootViewController: AnyObject! = storyboard.instantiateViewController(withIdentifier: "rootViewController")
                            if let window = UIApplication.shared.keyWindow{
                                window.rootViewController = rootViewController! as? UIViewController
                            }
                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        
                    }
                }
            }
            
            
        }
    }
    @IBAction func backAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
