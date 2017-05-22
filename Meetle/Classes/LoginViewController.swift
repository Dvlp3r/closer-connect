//
//  LoginViewController.swift
//  Meetle
//
//  Created by AppsFoundation on 8/6/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var spaceViewConstraint: NSLayoutConstraint?
    @IBOutlet weak var mainScrollViewBottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var emailTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    
    var isKeyboardShown = false

	override func viewDidLoad() {
		super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboard(_:))))
        configureSpaces()
	}

	//MARK: - Private methods
	
    func configureSpaces() {
        spaceViewConstraint!.constant = (UIScreen.main.bounds.size.height - LoginContentWidth) / 2;
        view.updateConstraints()
    }
    
	func hideKeyboard(_ recognizer: UITapGestureRecognizer) {
		view.endEditing(true)
        isKeyboardShown = false
	}
	
	//MARK: - User actions
	
	@IBAction func signInPressed(_ sender: AnyObject) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let rootViewController: AnyObject! = storyboard.instantiateViewController(withIdentifier: "rootViewController")
		
		if let window = UIApplication.shared.keyWindow{
			window.rootViewController = rootViewController! as? UIViewController
		}
	}

	@IBAction func facebookSignInPressed(_ sender: AnyObject) {
		print("facebookSignInPressed")
	}
	
	@IBAction func twitterSignInPressed(_ sender: AnyObject) {
		print("twitterSignInPressed")
	}
	
	@IBAction func forgotPasswordPressed(_ sender: AnyObject) {
		print("forgotPasswordPressed")
	}
	
	@IBAction func signUpPressed(_ sender: AnyObject) {
		print("signUpPressed")
	}
    
    //MARK: - Observer methods
    
    func keyboardWillChangeFrame(_ notification: Notification) {
        let keyboardBounds = (notification.userInfo!["UIKeyboardBoundsUserInfoKey"]! as AnyObject).cgRectValue
        mainScrollViewBottomConstraint!.constant = isKeyboardShown ? (keyboardBounds?.size.height)! - spaceViewConstraint!.constant : 0
        view.updateConstraints()
    }
}

//MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isKeyboardShown = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField?.becomeFirstResponder()
        } else if textField == passwordTextField {
            isKeyboardShown = false
            textField.resignFirstResponder()
        }
        return true
    }
}


