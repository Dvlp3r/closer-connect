//
//  HomeViewController.swift
//  Meetle
//
//  Created by AppsFoundation on 8/6/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit
import QuartzCore

class HomeViewController: BaseViewController {

	@IBOutlet weak var scrollView: UIScrollView?
	@IBOutlet weak var pageControl: UIPageControl?
	@IBOutlet weak var likeButton: UIButton?
	@IBOutlet weak var nextButton: UIButton?

	fileprivate let pageViews: NSMutableArray = NSMutableArray(objects: NSNull(), NSNull(), NSNull())
	fileprivate let imageNames = ["jessy", "man", "Veronika"]
	fileprivate let centerImageView: UIImageView = UIImageView(image: UIImage(named: "jessy"))
	fileprivate let leftImageView: UIImageView = UIImageView(image: UIImage(named: "like_text"))
	fileprivate let rightImageView: UIImageView = UIImageView(image: UIImage(named: "next_text"))

    override func viewDidLoad() {
        super.viewDidLoad()
		initMessageIcon()
		initImageView()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		initScrollImageView()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	func initImageView() {
		leftImageView.backgroundColor = ThemeManager.profileLikeBackgroundColor()
		rightImageView.backgroundColor = ThemeManager.profileNextBackgroundColor()
	}
		
	//MARK: - Private Methods
	
	func initScrollImageView() {
		let pagesScrollViewSize = scrollView!.frame.size
		scrollView!.contentSize = CGSize(width: pagesScrollViewSize.width * 2.0, height: pagesScrollViewSize.height)
		
        let size = scrollView!.bounds.size

        leftImageView.contentMode = UIViewContentMode.center
        leftImageView.frame = CGRect(x: 0.0, y: 0.0, width: size.width / 2.0, height: size.height)
        scrollView?.addSubview(leftImageView)
		
        centerImageView.contentMode = UIViewContentMode.scaleAspectFill
		centerImageView.frame = CGRect(x: size.width / 2.0, y: 0.0, width: size.width, height: size.height)
		scrollView?.addSubview(centerImageView)
		
        rightImageView.contentMode = UIViewContentMode.center
		rightImageView.frame = CGRect(x: size.width * 1.5, y: 0.0, width: size.width / 2.0, height: size.height)
		scrollView?.addSubview(rightImageView)
		
		scrollView!.setContentOffset(CGPoint(x: pagesScrollViewSize.width / 2.0, y: 0.0), animated: false)
	}
	
	//MARK: - User actions
	
	@IBAction func likeButtonPressed(_ sender: AnyObject) {
		print("likeButtonPressed")
	}
	
	@IBAction func nextButtonPressed(_ sender: AnyObject) {
		print("nextButtonPressed")
	}
}

// MARK: - UIScrollViewDelegate

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        likeButton?.isHidden = true
        nextButton?.isHidden = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let pagesScrollViewSize = scrollView.frame.size
            scrollView.setContentOffset(CGPoint(x: pagesScrollViewSize.width / 2.0, y: 0.0), animated: true)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let r = Int(arc4random() % 3)
        if scrollView.contentOffset.x < 0 {
            print("like")
            centerImageView.image = UIImage(named: imageNames[r])
        } else if scrollView.contentOffset.x > scrollView.frame.size.width {
            
            print("next")
            centerImageView.image = UIImage(named: imageNames[r])
        }
        
        if scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.frame.size.width {
            let transition = CATransition()
            transition.duration = 1.0
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            centerImageView.layer.add(transition, forKey: nil)
        }
        
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.setContentOffset(CGPoint(x: pagesScrollViewSize.width / 2.0, y: 0.0), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == scrollView.frame.size.width / 2.0 {
            likeButton?.isHidden = false
            nextButton?.isHidden = false
        } else if scrollView.contentOffset.x < 0.0 {
            scrollView.backgroundColor = ThemeManager.profileLikeBackgroundColor()
        } else if scrollView.contentOffset.x > scrollView.frame.size.width {
            scrollView.backgroundColor = ThemeManager.profileNextBackgroundColor()
        }
    }
}
