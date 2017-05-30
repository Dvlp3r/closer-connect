//
//  SignUpViewController.swift
//  closer-connect
//
//  Created by Mahendra Singh on 5/25/17.
//  Copyright © 2017 AppsFoundation. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import NVActivityIndicatorView

class SignUpViewController: UIViewController, NVActivityIndicatorViewable {
    
    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //Sign Up Action for email
    @IBAction func createAccountAction(_ sender: AnyObject) {
        if emailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else
        {
            self.startAnimating()
            
            DispatchQueue.global(qos: .background).async {
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                    
                    DispatchQueue.main.async {
                        if error == nil {
                            print("You have successfully signed up")
                            //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let rootViewController = storyboard.instantiateViewController(withIdentifier: "MoreDetailsViewController") as! MoreDetailsViewController
                            self.navigationController?.pushViewController(rootViewController, animated: true)
                            
                        } else {
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
    @IBAction func backAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
