//
//  MyResumeViewController.swift
//  closer-connect
//
//  Created by Mahendra Singh on 5/25/17.
//  Copyright © 2017 AppsFoundation. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import NVActivityIndicatorView

enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

class MyResumeViewController: BaseViewController, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var photoCollectionView: UICollectionView?
    @IBOutlet weak var pageControl: UIPageControl?
    @IBOutlet weak var aboutTxtField: UITextView?
    @IBOutlet weak var NameLbl: UILabel?
    @IBOutlet weak var LocationLbl: UILabel?
    
    let cellReuseIdentifier = "MyPhotoCell"
    var ref: DatabaseReference!
    var storage: Storage!
    var imageArr: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storage = Storage.storage()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        if DeviceType.IS_IPHONE_6P_7P {
            print("IS_IPHONE_6P_7P")
            
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom:0 , right: 0)
            layout.itemSize = CGSize(width: 414, height:414)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            photoCollectionView!.collectionViewLayout = layout
        }
        else if DeviceType.IS_IPHONE_6_7 {
            print("IS_IPHONE_6_7")
            
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom:0 , right: 0)
            layout.itemSize = CGSize(width: 375, height:375)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            photoCollectionView!.collectionViewLayout = layout
        }
        else if DeviceType.IS_IPHONE_5 {
            print("IS_IPHONE_5")
            
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom:0 , right: 0)
            layout.itemSize = CGSize(width: 320, height:320)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            //photoCollectionView!.collectionViewLayout = layout
        }
        else{
            print("IS_IPHONE_4")
        }
        
        self.photoCollectionView?.delegate = self
        self.photoCollectionView?.dataSource = self
        
        
        ref = Database.database().reference()
        
        
        let userID = Auth.auth().currentUser?.uid
        self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            //let username = value?["username"] as? String ?? ""
            //let user = User.init(username: username)
            //print(value!)
            if (value != nil)
            {
                self.NameLbl?.text = value?.object(forKey: "Name") as! String?
                print("You have successfully logged in")
                if let arr = value?.object(forKey: "Photos")
                {
                self.imageArr = (value?.object(forKey: "Photos")as? NSArray)!
                print(self.imageArr!)
                self.photoCollectionView?.reloadData()
                }
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - User Actions
    @IBAction func addPhotoPressed(sender: UIButton)
    {
        let alert = UIAlertController(title: "", message: "Choose", preferredStyle: .alert) // 1
        let firstAction = UIAlertAction(title: "From Gallery", style: .default) { (alert: UIAlertAction!) -> Void in
            NSLog("You pressed button one")
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = true
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        alert.addAction(firstAction)
        
        let secondAction = UIAlertAction(title: "Camera", style: .default) { (alert: UIAlertAction!) -> Void in
            NSLog("You pressed button two")
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                //self.displayAlertMessage(messageToDisplay: "No camera Available")
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                    imagePicker.allowsEditing = true
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            
        }
        alert.addAction(secondAction)
        let defaultAction = UIAlertAction(title: "OK", style: .default) { (alert: UIAlertAction!) -> Void in
            NSLog("You pressed button OK")
        }
        alert.addAction(defaultAction)
        present(alert, animated: true, completion:nil)
    }
    @IBAction func sharedFriendClicked(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        var viewControllers = NSMutableArray(array: navigationController!.viewControllers) as AnyObject as! [UIViewController]
        
        viewControllers.removeLast()
        viewControllers.append(controller)
        
        navigationController!.setViewControllers(viewControllers, animated: true)
    }
    //MARK: - ImagePickerView Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let choosedImg = (info[UIImagePickerControllerEditedImage] as? UIImage)!
        dismiss(animated: true, completion: nil)
        let data : Data = UIImageJPEGRepresentation(choosedImg, 0.60)!
        let storageRef = storage.reference()
        // set upload path
        let interval = Date().timeIntervalSince1970
        let timeStr = String(format:"%f.jpg", interval)
        let filePath = "\(Auth.auth().currentUser?.uid)/\(timeStr)"
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child(filePath)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        
        
        self.startAnimating()
        
        DispatchQueue.global(qos: .background).async {
            // Upload the file to the path "images/rivers.jpg"
            riversRef.putData(data, metadata: metadata) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata.downloadURL()?.absoluteString
                //print(error!)
                print(downloadURL!)
                if (error != nil)
                {
                    DispatchQueue.main.async {
                        self.stopAnimating()
                    }
                    
                }
                else
                {
                    if let user = Auth.auth().currentUser
                    {
                        var yourArray = [String]()
                        yourArray.append(downloadURL!)
                        for item in self.imageArr!
                        {
                            yourArray.append(item as! String)
                        }
                        let dbLocation = "users/\(user.uid)/\("Photos")"
                        self.ref.child(dbLocation).setValue(yourArray)
                        DispatchQueue.main.async {
                            self.stopAnimating()
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            self.stopAnimating()
                        }
                    }
                }
                
            }
            
        }
    }
    //MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:MyPhotoCell = self.photoCollectionView!.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! MyPhotoCell
        let photo  = self.imageArr?[indexPath.row]
        LazyImage.show(imageView:cell.myPic, url:photo as! String?)
        return cell
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell \(indexPath.item)!")
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if (imageArr != nil)
        {
        if (imageArr?.count)! > 0
        {
            return 1
        }
        }
        return 0
    }
}


