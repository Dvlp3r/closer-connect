//
//  TodayViewController.swift
//  MeetleWidget
//
//  Created by AppsFoundation on 22/09/15.
//  Copyright © 2015 AppsFoundation. All rights reserved.
//

import UIKit
import NotificationCenter

let TopMargin: CGFloat = 5.0;
let AnimationDuration = 0.5;

class TodayViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView?
    
    fileprivate let dataManager = DataManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView?.image = dataManager.getNextPhoto()
    }
    
    //MARK: - UserActions
    
    @IBAction func likeButtonPressed(_ sender: AnyObject) {
        updatePhoto()
    }
    
    @IBAction func nextButtonPressed(_ sender: AnyObject) {
        updatePhoto()
    }
    
    //MARK: - Private Methods
    
    func updatePhoto() {
        UIView.transition(with: imageView!,
            duration: AnimationDuration,
            options: UIViewAnimationOptions.transitionCrossDissolve,
            animations: {
                self.imageView!.image = self.dataManager.getNextPhoto()
            },
            completion: nil)
    }

}

//MARK: - NCWidgetProviding

extension TodayViewController: NCWidgetProviding {
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        var defaultMarginInsets = defaultMarginInsets
        defaultMarginInsets.top = TopMargin
        defaultMarginInsets.right = defaultMarginInsets.left
        imageView?.needsUpdateConstraints()
        view.needsUpdateConstraints()
        return defaultMarginInsets
    }

}
