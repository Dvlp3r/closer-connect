//
//  SettingsViewController.swift
//  Meetle
//
//  Created by AppsFoundation on 8/6/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import NVActivityIndicatorView

class SettingsViewController: BaseViewController, NVActivityIndicatorViewable {
	
	@IBOutlet weak var userSex: UISegmentedControl!
	@IBOutlet weak var userSearch: UISegmentedControl!
	@IBOutlet weak var distance: UISegmentedControl!
    @IBOutlet weak var distanceSlider: UISlider!
	@IBOutlet weak var sliderView: UIView!
	@IBOutlet weak var rangeLabel: UILabel!
	@IBOutlet weak var distanceLabel: UILabel!
	
    
    var ref: DatabaseReference!
	fileprivate var slider: RangeSlider!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		userSex!.layer.borderColor = ThemeManager.settingsLightGreenColor().cgColor
		userSex!.layer.borderWidth = UISegmentedControlBorderWidth
		userSearch!.layer.borderColor = ThemeManager.settingsLightGreyColor().cgColor
		userSearch!.layer.borderWidth = UISegmentedControlBorderWidth
		distance!.layer.borderColor = ThemeManager.settingsLightGreenColor().cgColor
		distance!.layer.borderWidth = UISegmentedControlBorderWidth
		
		initRangeSlider()
        
        ref = Database.database().reference()
        
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		slidingPanelController.delegate = self
        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Success
            if let value = snapshot.value as? NSDictionary
            {
                print("You have successfully logged in")
                if let settings = value.object(forKey: "Settings" as NSString)
                {
                    if let gender = value.object(forKey: "Gender" as NSString)
                    {
                        self.userSex.selectedSegmentIndex = gender as! Int
                    }
                    if let Intrests = (settings as AnyObject).object(forKey: "Intrests" as NSString)
                    {
                        self.userSearch.selectedSegmentIndex = Intrests as! Int
                    }
                    else
                    {
                        if let gender = value.object(forKey: "Gender" as NSString)
                        {
                            self.userSex.selectedSegmentIndex = gender as! Int
                            if (self.userSex.selectedSegmentIndex==1)
                            {
                                self.userSearch.selectedSegmentIndex = 0
                            }
                            else
                            {
                                self.userSearch.selectedSegmentIndex = 1
                            }
                            
                        }
                        
                    }
                    if let Distance = (settings as AnyObject).object(forKey: "Distance" as NSString)
                    {
                        self.distanceSlider.value = Distance as! Float
                        let report = NSString(format: "%.0f miles", self.distanceSlider.value)
                        self.distanceLabel!.text = report as String
                    }
                    else
                    {
                        
                    }
                    if let DistanceUnit = (settings as AnyObject).object(forKey: "DistanceUnit" as NSString)
                    {
                        self.distance.selectedSegmentIndex = DistanceUnit as! Int
                    }
                    else
                    {
                        
                    }
                    if let FromAge = (settings as AnyObject).object(forKey: "FromAge" as NSString)
                    {
                        self.slider.min = FromAge as! CGFloat
                        let report = NSString(format: "%.0f - %.0f", self.slider.min * 100.0, self.slider.max * 100.0)
                        self.rangeLabel!.text = report as String
                    }
                    else
                    {
                        
                    }
                    if let ToAge = (settings as AnyObject).object(forKey: "ToAge" as NSString)
                    {
                        self.slider.max = ToAge as! CGFloat
                        let report = NSString(format: "%.0f - %.0f", self.slider.min * 100.0, self.slider.max * 100.0)
                        self.rangeLabel!.text = report as String
                    }
                    else
                    {
                        
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		slidingPanelController.delegate = nil
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
	}
	
	//MARK: - User Actions
	
	func initRangeSlider() {
		slider = RangeSlider(frame: CGRect(x: 0, y: 0, width: sliderView!.bounds.size.width, height: sliderView!.bounds.size.height))
        slider!.setDefaults()
		slider!.addTarget(self, action: #selector(SettingsViewController.report(_:)), for: UIControlEvents.valueChanged)
		sliderView?.addSubview(slider!)
	}
	
	@IBAction func distanceChanged(_ sender: UISlider) {
		let report = NSString(format: "%.0f miles", sender.value)
		distanceLabel!.text = report as String
	}
	
	@IBAction func report(_ sender: RangeSlider) {
		let report = NSString(format: "%.0f - %.0f", sender.min * 100.0, sender.max * 100.0)
		rangeLabel!.text = report as String
    }
    @IBAction func SavePressed(_ sender: UISlider) {
        self.startAnimating()
        
        DispatchQueue.global(qos: .background).async {
            if let user = Auth.auth().currentUser
            {
                self.ref.child("users").child(user.uid).child("Settings").setValue(["Intrests": self.userSearch.selectedSegmentIndex,  "Distance": self.distanceSlider.value,  "DistanceUnit": self.distance.selectedSegmentIndex,  "FromAge": self.slider.min,  "ToAge": self.slider.max])
                DispatchQueue.main.async {
                    self.stopAnimating()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let rootViewController: AnyObject! = storyboard.instantiateViewController(withIdentifier: "rootViewController")
                    if let window = UIApplication.shared.keyWindow{
                        window.rootViewController = rootViewController! as? UIViewController
                    }
                }
            }
        }
    }
}

// MARK: - MSSlidingPanelControllerDelegate

extension SettingsViewController: MSSlidingPanelControllerDelegate {
    
    func slidingPanelController(_ panelController: MSSlidingPanelController!, hasOpenedSide side: MSSPSideDisplayed) {
        slidingPanelController.leftPanelOpenGestureMode = .all
    }
    
    func slidingPanelController(_ panelController: MSSlidingPanelController!, hasClosedSide side: MSSPSideDisplayed) {
        slidingPanelController.leftPanelOpenGestureMode = MSSPOpenGestureMode()
    }
}
