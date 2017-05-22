//
//  SettingsViewController.swift
//  Meetle
//
//  Created by AppsFoundation on 8/6/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
	
	@IBOutlet weak var userSex: UISegmentedControl?
	@IBOutlet weak var userSearch: UISegmentedControl?
	@IBOutlet weak var distance: UISegmentedControl?
	@IBOutlet weak var sliderView: UIView?
	@IBOutlet weak var rangeLabel: UILabel?
	@IBOutlet weak var distanceLabel: UILabel?
	
	fileprivate var slider: RangeSlider?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		userSex!.layer.borderColor = ThemeManager.settingsLightGreenColor().cgColor
		userSex!.layer.borderWidth = UISegmentedControlBorderWidth
		userSearch!.layer.borderColor = ThemeManager.settingsLightGreyColor().cgColor
		userSearch!.layer.borderWidth = UISegmentedControlBorderWidth
		distance!.layer.borderColor = ThemeManager.settingsLightGreenColor().cgColor
		distance!.layer.borderWidth = UISegmentedControlBorderWidth
		
		initRangeSlider()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		slidingPanelController.delegate = self
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
