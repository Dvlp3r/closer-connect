//
//  LoginViewController.swift
//  Meetle
//
//  Created by AppsFoundation on 8/6/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

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
        //spaceViewConstraint!.constant = (UIScreen.main.bounds.size.height - LoginContentWidth) / 2;
        //view.updateConstraints()
    }
    
	func hideKeyboard(_ recognizer: UITapGestureRecognizer) {
		view.endEditing(true)
        isKeyboardShown = false
	}
	
	//MARK: - User actions
	
	@IBAction func signInPressed(_ sender: AnyObject) {
//		let storyboard = UIStoryboard(name: "Main", bundle: nil)
//		let rootViewController: AnyObject! = storyboard.instantiateViewController(withIdentifier: "rootViewController")
//		
//		if let window = UIApplication.shared.keyWindow{
//			window.rootViewController = rootViewController! as? UIViewController
//		}
        
        if self.emailTextField?.text == "" || self.passwordTextField?.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: (self.emailTextField?.text!)!, password: (self.passwordTextField?.text!)!) { (user, error) in
                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let rootViewController: AnyObject! = storyboard.instantiateViewController(withIdentifier: "rootViewController")
                    self.navigationController?.pushViewController(rootViewController as! UIViewController, animated: true)
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
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
        //mainScrollViewBottomConstraint!.constant = isKeyboardShown ? (keyboardBounds?.size.height)! - spaceViewConstraint!.constant : 0
        //view.updateConstraints()
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


