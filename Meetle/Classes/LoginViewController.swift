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
import NVActivityIndicatorView
import FacebookLogin
import FacebookCore
import TwitterKit

class LoginViewController: UIViewController, NVActivityIndicatorViewable  {

    @IBOutlet weak var spaceViewConstraint: NSLayoutConstraint?
    @IBOutlet weak var mainScrollViewBottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var emailTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    
    var ref: DatabaseReference!
    var nameVal: String?
    private var databaseHandle: DatabaseHandle!
    var isKeyboardShown = false

	override func viewDidLoad() {
		super.viewDidLoad()
        
        
        
        ref = Database.database().reference()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboard(_:))))
        configureSpaces()
        
        if ((Auth.auth().currentUser) != nil)
        {
            //loginControllerNav
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController: AnyObject! = storyboard.instantiateViewController(withIdentifier: "rootViewController")
            
            if let window = UIApplication.shared.keyWindow{
                window.rootViewController = rootViewController! as? UIViewController
            }
            
        }
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
            self.startAnimating()
            
            DispatchQueue.global(qos: .background).async {
                print("This is run on the background queue")
                Auth.auth().signIn(withEmail: (self.emailTextField?.text!)!, password: (self.passwordTextField?.text!)!) { (user, error) in
                    
                    DispatchQueue.main.async {
                        print("This is run on the main queue, after the previous code in outer block")
                        self.stopAnimating()
                        if error == nil {
                            
                            //Print into the console if successfully logged in
                            print("You have successfully logged in")
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let rootViewController: AnyObject! = storyboard.instantiateViewController(withIdentifier: "rootViewController")
                            if let window = UIApplication.shared.keyWindow{
                                window.rootViewController = rootViewController! as? UIViewController
                            }
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
            
            
        }
        
    }
    //MARK: - Facebook Login Manager
    
    @IBAction func facebookSignInPressed(_ sender: AnyObject) {
        print("facebookSignInPressed")
        let loginManager = LoginManager()
        
        //loginManager.logIn([ .publicProfile, .email], viewController: self)
        loginManager.logIn([ .publicProfile, .email], viewController: self) { loginResult in
            //print("LOGIN RESULT! \(loginResult)")
            self.startAnimating()
            switch loginResult {
            case .failed(let error):
                print("FACEBOOK LOGIN FAILED: \(error)")
                self.stopAnimating()
            case .cancelled:
                print("User cancelled login.")
                self.stopAnimating()
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                print("GRANTED PERMISSIONS: \(grantedPermissions)")
                print("DECLINED PERMISSIONS: \(declinedPermissions)")
                print("ACCESS TOKEN \(accessToken)")
                
                let params = ["fields" : "email, name"]
                let graphRequest = GraphRequest(graphPath: "me", parameters: params)
                graphRequest.start {
                    (urlResponse, requestResult) in
                    
                    switch requestResult {
                    case .failed(let error):
                        print("error in graph request:", error)
                        self.stopAnimating()
                        break
                    case .success(let graphResponse):
                        if var responseDictionary = graphResponse.dictionaryValue {
                            print(responseDictionary)
                            
                            print(responseDictionary["name"] as! String)
                            print(responseDictionary["email"] as! String)
                            //UserDataParser().socialLogin(authId: responseDictionary["id"] as! String )
                            let facebookUserId = responseDictionary["id"] as! String
                            print(facebookUserId as Any)
                            if facebookUserId != ""
                            {
                                self.nameVal = responseDictionary["name"] as! String
                                //UserDataParser().socialLogin(authId: facebookUserId)
                                //loginManager.logOut()
                                let credential = FacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.authenticationToken)!)
                                // [END headless_facebook_auth]
                                self.firebaseLoginWithCredential(credential: credential);
                            }
                            else
                            {
                                self.stopAnimating()
                            }
                        }
                        else
                        {
                            self.stopAnimating()
                        }
                    }
                    
                }
                
            }
        }
        
    }
	
	@IBAction func twitterSignInPressed(_ sender: AnyObject) {
		print("twitterSignInPressed")
        Twitter.sharedInstance().logIn {
            (session, error) -> Void in
            if (session != nil) {
                self.startAnimating()
                let credential = TwitterAuthProvider.credential(withToken: (session?.authToken)!, secret: (session?.authTokenSecret)!)
                print(session!.userID)
                print(session!.userName)
                print(session!.authToken)
                print(session!.authTokenSecret)
                // [END headless_twitter_auth]
                //[self firebaseLoginWithCredential:credential];
                self.nameVal = session!.userName
                self.firebaseLoginWithCredential(credential: credential);

                
            }else {
                print("Not Login")
            }
        }
	}
	
	@IBAction func forgotPasswordPressed(_ sender: AnyObject) {
		print("forgotPasswordPressed")
	}
	
	@IBAction func signUpPressed(_ sender: AnyObject) {
		print("signUpPressed")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
	}
    
    func firebaseLoginWithCredential(credential: AuthCredential)
    {
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            if ((Auth.auth().currentUser) != nil)
            {
                Auth.auth().currentUser?.link(with: credential, completion: { (user, error) in
                    
                    DispatchQueue.main.async {
                        print("This is run on the main queue, after the previous code in outer block")
                        self.stopAnimating()
                        if error == nil {
                            
                            //Print into the console if successfully logged in
                            print("You have successfully logged in")
                            self.ref.child("users").child((user?.uid)!).setValue(["username": "Mahendra"])
                            //loginControllerNav
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let rootViewController: AnyObject! = storyboard.instantiateViewController(withIdentifier: "rootViewController")
                            
                            if let window = UIApplication.shared.keyWindow{
                                window.rootViewController = rootViewController! as? UIViewController
                            }
                        } else {
                            
                            //Tells the user that there is an error and then gets firebase to tell them the error
                            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                })
                
            }
            else
            {
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    
                    DispatchQueue.main.async {
                        print("This is run on the main queue, after the previous code in outer block")
                        self.stopAnimating()
                        if error == nil
                        {
                            let userID = user?.uid
                            self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                                // Get user value
                                let value = snapshot.value as? NSDictionary
                                //let username = value?["username"] as? String ?? ""
                                //let user = User.init(username: username)
                                //print(value!)
                                if (value != nil)
                                {
                                    print("You have successfully logged in")
                                    
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let rootViewController: AnyObject! = storyboard.instantiateViewController(withIdentifier: "rootViewController")
                                    if let window = UIApplication.shared.keyWindow{
                                        window.rootViewController = rootViewController! as? UIViewController
                                    }
                                }
                                else
                                {
                                    print("You have successfully logged in")
                                    
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "MoreDetailsViewController") as! MoreDetailsViewController
                                    rootViewController.name = self.nameVal!
                                    self.navigationController?.pushViewController(rootViewController, animated: true)
                                }
                                // ...
                            }) { (error) in
                                print(error.localizedDescription)
                            }
                            //self.ref.child("users").child((user?.uid)!).setValue(["username": "Mahendra", "Name": "Mahen"])
                            //Print into the console if successfully logged in
                            
                        } else {
                            
                            //Tells the user that there is an error and then gets firebase to tell them the error
                            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                })
            }
            
        }
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


