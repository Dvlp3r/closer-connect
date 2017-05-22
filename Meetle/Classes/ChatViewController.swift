//
//  ChatViewController.swift
//  Meetle
//
//  Created by AppsFoundation on 8/6/15.
//  Copyright (c) 2015 AppsFoundation. All rights reserved.
//

import UIKit

class ChatViewController: BaseViewController, UINavigationControllerDelegate {
    
    fileprivate var messages: NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var inputText: UITextField?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var chatInputView: UIView?
    @IBOutlet weak var inputViewBottomConstrains: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMessageIcon()
        addTopBorderToInput()
        initDefaultMessages()
        addKeyboardNotificationsAndGestureRecognizers()
        showUserName()
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
        messages.add("Hi Veronika! That's crazy that we have so many friends in common but I have never heard of you.")
        messages.add("Hi John! Yeah, I know. Nice to meet you. So how do you know Jessica ?")
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
        
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: OpponentCellIdentifier) as? MessageCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: MyCellIdentifier) as? MessageCell
        }
        
        cell!.messageLabel!.text = messages.object(at: indexPath.row) as? String
        return cell!
    }
}

// MARK: - UITableViewDelegate

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell") as! MessageCell
        cell.messageLabel!.text = messages.object(at: indexPath.row) as? String
        return cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
    }
    
}
