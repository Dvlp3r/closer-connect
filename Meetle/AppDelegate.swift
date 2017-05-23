//
//  AppDelegate.swift
//  Meetle
//
//  Created by AppsFoundation on 8/5/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit
import GoogleMobileAds

let rateDelay: NSInteger  = 60

enum RateApp: Int {
	case declined = 0
	case confirmed
}

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, GADInterstitialDelegate, AdColonyDelegate, RevMobAdsDelegate {

	var window: UIWindow?
	
	var interstitial: GADInterstitial?
	var request: GADRequest?
	var revMobFullscreen: RevMobFullscreen?
	
	var homeController: UIViewController?
	var chatController: UIViewController?
	var locationController: UIViewController?
	var settingsController: UIViewController?
	var inviteController: UIViewController?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		// Remove comments to add Flurry Analytics more information here - www.flurry.com
		//let flurrySessionID = ConfigurationManager.sharedManager.flurrySessionId
		//Flurry.startSession(flurrySessionID)
		
		UIApplication.shared.statusBarStyle = .lightContent
		UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : UIFont(name: "Eurofurenceregular", size: 20.0)!, NSForegroundColorAttributeName : UIColor.white]

		initAppiRater()
		initRateAppTimer()
		
		NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.changedController(_:)), name: NSNotification.Name(rawValue: "changeControllerNotification"), object: nil)
  
		// Uncomment appropriate line to show ads.
		
        //AdMob:
        //showInterstitialAd()
        
        //AdColony:
        //configureAdColony()
        //to show ads:AdColony.playVideoAdForZone("vz7166df2af5ed437088", withDelegate: nil)
        
        //RevMob:
        //showRevMob()
		
		return true
	}
	
	func changedController(_ notification: Notification) {
	
		let navigationController = window!.rootViewController as! MSSlidingPanelController
	
		if homeController == nil {
			homeController = navigationController.centerViewController
		}
		
		let mystoryboard = UIStoryboard(name: "Main", bundle: nil)
		let controller: UIViewController
		
		if (notification.object! as AnyObject).isEqual(to: "homeController") {
			if homeController == nil {
				homeController = mystoryboard.instantiateViewController(withIdentifier: notification.object as! String)
			}
			controller = homeController!
		} else if (notification.object! as AnyObject).isEqual(to: "chatController") {
			if chatController == nil {
				chatController = mystoryboard.instantiateViewController(withIdentifier: notification.object as! String)
			}
			controller = chatController!
		} else if (notification.object! as AnyObject).isEqual(to: "locationController") {
			if locationController == nil {
				locationController = mystoryboard.instantiateViewController(withIdentifier: notification.object as! String)
            }
			controller = locationController!
		} else if (notification.object! as AnyObject).isEqual(to: "settingsController") {
			if settingsController == nil {
				settingsController = mystoryboard.instantiateViewController(withIdentifier: notification.object as! String)
			}
			controller = settingsController!
		} else {
			if inviteController == nil {
				inviteController = mystoryboard.instantiateViewController(withIdentifier: notification.object as! String)
			}
			controller = inviteController!
		}
		
		navigationController.centerViewController = controller
		navigationController.closePanel()
	}

	// MARK: - Private Methods
	fileprivate func initAppiRater() {
		Appirater.appLaunched(true)
		Appirater.setAppId(ConfigurationManager.sharedManager.appId)
		Appirater.setOpenInAppStore(true)
	}
	
	fileprivate func initRateAppTimer() {
		let didShowAppRate = UserDefaults.standard.value(forKey: "showedAppRate") as? Bool
		if didShowAppRate != true {
			let showRateDelay = TimeInterval(ConfigurationManager.sharedManager.rateAppDelay.intValue * rateDelay)
			Timer.scheduledTimer(timeInterval: showRateDelay, target: self, selector: #selector(AppDelegate.showAppRate), userInfo: nil, repeats: false)
		}
	}
	
	func showAppRate() {
		let didShowAppRate = UserDefaults.standard.value(forKey: "showedAppRate") as? Bool
		if didShowAppRate != true {
			rateApp()
			UserDefaults.standard.set(true, forKey: "showedAppRate")
			UserDefaults.standard.synchronize()
		}
	}
	
	func rateApp() {
		let alertController = UIAlertController(title: "Rate the App", message: "Do you like this app?", preferredStyle: UIAlertControllerStyle.alert)
		let noAction: UIAlertAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { action -> Void in }
			alertController.addAction(noAction)
		let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
				Appirater.rateApp()
		}
		alertController.addAction(yesAction)
		window?.rootViewController!.present(alertController, animated: true, completion: nil)
	}

	//MARK: - UIAlertViewDelegate
	func alertView(_ alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
		if alertView.title == "Rate the App" {
			switch buttonIndex {
			case RateApp.declined.rawValue:
				break
			case RateApp.confirmed.rawValue:
				Appirater.rateApp()
				break
			default:
				break
			}
		}
	}
	
	//MARK: - AdMob
	func showInterstitialAd() {
		request = GADRequest()
		request!.testDevices = [kGADSimulatorID]
		interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/1033173712")
		interstitial!.delegate = self
		interstitial!.load(request)
	}
	
	func interstitialDidReceiveAd(_ ad: GADInterstitial) {
		ad.present(fromRootViewController: window?.rootViewController)
	}
	
	func interstitial(_ ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
		print("error: appdelegate #79", terminator: "")
	}
	
	//MARK: - AdColony
	//You can view full tutorial here
	//https://github.com/AdColony/AdColony-iOS-SDK/wiki
	
	func configureAdColony() {
        AdColony.configure(withAppID: "appdd3425524d234ba4bd", zoneIDs: ["vz7166df2af5ed437088"], delegate: nil, logging: true)
	}
    
	
	//MARK: - RevMob
	//You can view full tutorial here
	//http://sdk.revmobmobileadnetwork.com/ios.html
	
	func showRevMob() {
		RevMobAds.startSession(withAppID: "52eb8752a026a90b34000d7f", withSuccessHandler: { () -> Void in
				self.revMobFullscreen = RevMobAds.session().fullscreen()
				self.revMobFullscreen!.delegate = self
				self.revMobFullscreen!.showAd()
			}, andFailHandler: { error in
				print("failHandler", terminator: "")
		})
	}
	
}
