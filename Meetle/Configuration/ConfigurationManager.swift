//
//  ConfigurationManager.swift
//  Meetle
//
//  Created by AppsFoundation on 7/28/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit

class ConfigurationManager : NSObject {

    fileprivate(set) var appId : String!
    fileprivate(set) var contactMail : String!
    fileprivate(set) var rateAppDelay : NSNumber!
    fileprivate(set) var flurrySessionId : String!
    fileprivate(set) var mailSubject : String?
    
    static let sharedManager = ConfigurationManager()
    
    fileprivate override init() {
        if let path = Bundle.main.path(forResource: "Configuration", ofType: "plist"), let configurations = NSDictionary(contentsOfFile:path) {
            appId = configurations["AppId"] as! String
            contactMail = configurations["ContactMail"] as! String
            rateAppDelay = configurations["RateAppDelayInMinutes"] as! NSNumber
            flurrySessionId = configurations["FlurrySessionID"] as! String
            mailSubject = configurations["MailSubject"] as? String
        }
    }
}
