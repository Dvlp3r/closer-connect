//
//  ProfileViewController.swift
//  Meetle
//
//  Created by AppsFoundation on 8/6/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var pageControl: UIPageControl?
    @IBOutlet weak var aboutLabel: UILabel?

    fileprivate let imageNames = ["jessy", "man", "Veronika"]
    fileprivate var pageImages: NSMutableArray = NSMutableArray()
    fileprivate var pageViews: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMessageIcon()
        aboutLabel!.preferredMaxLayoutWidth = aboutLabel!.bounds.size.width
        
        for i in 0 ..< ProfilePicturesCount {
            pageImages.add(UIImage(named: imageNames[i % 3])!)
        }
        
        for _ in 0 ..< ProfilePicturesCount {
            pageViews.add(NSNull())
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initScrollImageView()
        let pagesScrollViewSize = scrollView!.frame.size
        scrollView!.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count), height: pagesScrollViewSize.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Private methods
	
    func initScrollImageView() {
        let pagesScrollViewSize = scrollView!.frame.size
        scrollView!.contentSize = CGSize(width: pagesScrollViewSize.width * 2.0, height: pagesScrollViewSize.height)
        let size = scrollView!.bounds.size

        for i in 0 ..< pageImages.count {
            let imageView = UIImageView(image: pageImages.object(at: i) as? UIImage)
            imageView.contentMode = UIViewContentMode.scaleToFill
            imageView.frame = CGRect(x: size.width * CGFloat(i), y: 0.0, width: size.width, height: size.height)
            scrollView!.addSubview(imageView)
        }
    }
    
    //MARK: - User Actions
	
    @IBAction func sharedFriendClicked(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        var viewControllers = NSMutableArray(array: navigationController!.viewControllers) as AnyObject as! [UIViewController]
        
        viewControllers.removeLast()
        viewControllers.append(controller)
        
        navigationController!.setViewControllers(viewControllers, animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension ProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0))
        pageControl!.currentPage = Int(page)
    }
}
