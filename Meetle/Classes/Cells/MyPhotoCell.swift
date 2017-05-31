//
//  MyPhotoCell.swift
//  closer-connect
//
//  Created by Mahendra Singh on 5/31/17.
//  Copyright © 2017 AppsFoundation. All rights reserved.
//

import Foundation

class MyPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var myPic: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.translatesAutoresizingMaskIntoConstraints = false
        //self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        //self.addSubview(self.imageView)
        
        //        self.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        //        self.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        //        self.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        //        self.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //self.makeItCircle()
    }
    
    func makeItCircle() {
//        self.imageView?.layer.masksToBounds = true
//        self.imageView?.layer.cornerRadius  = (self.imageView?.frame.size.width)!/2.0
//        self.imageView?.layer.borderWidth = 1.0;
//        self.imageView?.layer.borderColor =  UIColor.lightGray.cgColor
//        self.imageView?.layer.shadowColor = UIColor.darkGray.cgColor
//        self.imageView?.layer.shadowOpacity = 1
//        self.imageView?.layer.shadowOffset = CGSize.zero
//        self.imageView?.layer.shadowRadius = 10
        
    }
    
}
