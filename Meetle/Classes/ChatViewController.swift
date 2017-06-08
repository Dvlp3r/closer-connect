//
//  ChatViewController.swift
//  Meetle
//
//  Created by AppsFoundation on 8/6/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class ChatViewController: BaseViewController, UINavigationControllerDelegate {
    
    fileprivate var messages: NSMutableArray = NSMutableArray()
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var inputText: UITextField?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var chatInputView: UIView?
    @IBOutlet weak var inputViewBottomConstrains: NSLayoutConstraint?
    
    var friendId: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendId = "o3vRbAXd83aIJZYb7jzOU0bK7wy1"
        ref = Database.database().reference()
        
        initMessageIcon()
        addTopBorderToInput()
        initDefaultMessages()
        addKeyboardNotificationsAndGestureRecognizers()
        showUserName()
    
        self.ref.child("messages").child(self.friendId!).queryLimited(toLast: 25).observe(.childAdded, with: { (snapshot) in
            
            // Success
            let value = snapshot.value as? NSDictionary
            //let username = value?["username"] as? String ?? ""
            //let user = User.init(username: username)
            print(value!)
            if (value != nil)
            {
                self.messages.add(value!)
                //tableView!.insertRows(at: [newIndexPath], with: UITableViewRowAnimation.bottom)
                self.tableView!.reloadData()
                self.tableView!.layoutIfNeeded()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView!.reloadData()
        scrollChatToTheBottom()
    }

    //MARK: - User Actions
	
    @IBAction override func menuIconClicked(_ sender: AnyObject) {
        super.menuIconClicked(sender)
        view.endEditing(true)
    }
    
    @IBAction func onMicro(_ sender: AnyObject) {
        print("OnMicro")
    }
    
    @IBAction func onCamera(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertView(title: "Camera Not Available", message: "Sorry, but camera not available", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    //MARK: - Keyboard notifications
	
    func keyboardWillShow(_ notification: Notification) {
        let info = notification.userInfo!
        let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let height = keyboardFrame.size.height
        inputViewBottomConstrains!.constant = height
        UIView.animate(withDuration: animationDuration!, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(_ notification: Notification) {
        let info = notification.userInfo!
        let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        inputViewBottomConstrains!.constant = 0
        UIView.animate(withDuration: animationDuration!, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: - Private methods
	
    func addKeyboardNotificationsAndGestureRecognizers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let singleFingerTap = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.hideKeyboard(_:)))
        view.addGestureRecognizer(singleFingerTap)
    }
    
    
    func scrollChatToTheBottom() {
        let newIndexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView?.scrollToRow(at: newIndexPath, at: UITableViewScrollPosition.top, animated: true)
    }
    
    func addTopBorderToInput() {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: chatInputView!.frame.size.width, height: 0.5)
        topBorder.backgroundColor = UIColor.gray.cgColor
        chatInputView!.layer.addSublayer(topBorder)
    }
    
    func initDefaultMessages() {
        messages = NSMutableArray()
        let obj = ["Message": "HI"]
        messages.add(obj)
        
    }
    
    func hideKeyboard(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func showUserName() {
        
        let userName =  UILabel(frame: CGRect(x: 30, y: 3, width: 95, height: 20))
        userName.textColor = UIColor.white
        userName.backgroundColor = UIColor.clear
        userName.font = UIFont(name: "Eurofurenceregular", size: 20.0)
        userName.text = "Veronika"
        
        let photo = UIImage(named: "message_profile_photo")
        let image = UIImageView(image: photo)
        
        let userNameView = UIView(frame: CGRect(x: 0, y: 0, width: 95, height: 25))
        userNameView.addSubview(userName)
        userNameView.addSubview(image)
        
        navigationItem.titleView = userNameView
    }
}

//MARK: - UIImagePickerControllerDelegate

extension ChatViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITextFieldDelegate

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty {
            return false
        }
        
        let newIndexPath = IndexPath(row: messages.count, section: 0)
        self.ref.child("messages").child(self.friendId!).childByAutoId().setValue(["Message": textField.text!,  "Sender": (Auth.auth().currentUser?.uid)!])
        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("messages").child(self.friendId!).child((Auth.auth().currentUser?.uid)!).childByAutoId().setValue(["Message": textField.text!,  "Sender": (Auth.auth().currentUser?.uid)!])
        messages.add(textField.text!)
        tableView!.insertRows(at: [newIndexPath], with: UITableViewRowAnimation.bottom)
        tableView!.reloadData()
        tableView!.layoutIfNeeded()
        
        scrollChatToTheBottom()
        textField.text = ""
        
        return true
    }
}

// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let MyCellIdentifier = "MyMessageCell"
        let OpponentCellIdentifier = "OpponentMessageCell"
        
        var cell: MessageCell?
        
        
        let dict = messages.object(at: indexPath.row) as? NSDictionary
        if (dict?.object(forKey: "Sender" as NSString) as! String? == Auth.auth().currentUser?.uid)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: MyCellIdentifier) as? MessageCell
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: OpponentCellIdentifier) as? MessageCell
        }
        
        cell!.messageLabel!.text = dict?.object(forKey: "Message" as NSString) as! String?
        return cell!
    }
}

// MARK: - UITableViewDelegate

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell") as! MessageCell
        let dict = messages.object(at: indexPath.row) as? NSDictionary
        cell.messageLabel!.text = dict?.object(forKey: "Message" as NSString) as! String?
        return cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
    }
    
}
