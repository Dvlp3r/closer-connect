//
//  BaseViewController.swift
//  Meetle
//
//  Created by AppsFoundation on 8/5/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit
import MessageUI

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
	
    @IBAction func menuIconClicked(_ sender: AnyObject) {
        if slidingPanelController.sideDisplayed == .left {
            slidingPanelController.closePanel()
        } else {
            slidingPanelController.openLeftPanel()
        }
    }
    
    @IBAction func messageIconClicked(_ sender: AnyObject) {
        sendMessageWithText("Hi, nice to meet you here!")
    }
    
    @IBAction func goToPreviousView(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK - Public Methods
	
    func initMessageIcon() {
        let navigationImage = UIImage(named: "message")!.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: navigationImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.messageIconClicked(_:)))
    }
    
    func initMenuIcon() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.menuIconClicked(_:)))
    }
    
    func inviteByMail() {
        if MFMailComposeViewController.canSendMail() {
            let manager = ConfigurationManager.sharedManager
            let mailComposer = MFMailComposeViewController()
            
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients([manager.contactMail])
            mailComposer.setSubject(manager.mailSubject!)
            present(mailComposer, animated: true, completion: nil)
        }
    }
    
    func sendMessageWithText(_ text: NSString) {
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            controller.body = text as String
            controller.messageComposeDelegate = self
            present(controller, animated: true, completion: nil)
        }
    }
}

//MARK: - MFMessageComposeViewControllerDelegate

extension BaseViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - MFMailComposeViewControllerDelegate

extension BaseViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
