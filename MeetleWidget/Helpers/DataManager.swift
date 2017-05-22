//
//  DataManager.swift
//  Meetle
//
//  Created by AppsFoundation on 22/09/15.
//  Copyright © 2015 AppsFoundation. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    fileprivate var photos = NSArray(objects: UIImage(named: "jessy")!, UIImage(named: "man")!, UIImage(named: "Veronika")!)
    fileprivate var currentPhotoIndex = 0
    
    func getNextPhoto() -> UIImage {
        return photos.object(at: currentPhotoIndex+1 % photos.count) as! UIImage
    }
    
}
