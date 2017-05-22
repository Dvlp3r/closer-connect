//
//  InterfaceController.swift
//  Meetle WatchKit 1 Extension
//
//  Created by AppsFoundation on 10/21/15.
//  Copyright © 2015 AppsFoundation. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    // MARK: - Properties
    
    @IBOutlet weak var backgroundGroup: WKInterfaceGroup!
    
    let dataManager = DataManager()
    
    // MARK: - Interface Life Cycle

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        backgroundGroup.setBackgroundImage(dataManager.getNextPhoto())
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    // MARK: - Actions
    
    @IBAction func onLikeButtonClicked() {
        backgroundGroup.setBackgroundImage(dataManager.getNextPhoto())
    }
    
    @IBAction func onNextButtonClicked() {
        backgroundGroup.setBackgroundImage(dataManager.getNextPhoto())
    }
}
