//
//  ProfileViewController.swift
//  Blue Dove
//
//  Created by Lobe Musonda on 8/1/18.
//  Copyright © 2018 Lobe Musonda. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tweetsContainer: UIView!
    @IBOutlet weak var mediaContainer: UIView!
    @IBOutlet weak var likesContainer: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var imageLoader: UIActivityIndicatorView!
    
    var loggedInUser: AnyObject!
    var databaseRef = Database.database().reference()
    var storageRef = Storage.storage().reference()
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loggedInUser = Auth.auth().currentUser
        
        databaseRef.child("user_profiles").child(self.loggedInUser.uid).observe(.value) { (snapshot) in
            let getData = snapshot.value as! [String:Any]
            self.name.text = getData["name"] as? String
            self.handle.text = "@" + (getData["handle"] as! String)
            
            //initially the user will not have bio data or profile pic
            if getData["bio"] != nil {
                self.bio.text = getData["bio"] as? String
            }
            if getData["profile_pic"] != nil {
                let databaseProfilePic = getData["profile_pic"] as? String
                let data = NSData(contentsOf: NSURL(string: databaseProfilePic!)! as URL)
                self.setProfilePicture(imageView: self.profilePicture, imageToSet: UIImage(data: data! as Data)!)
            }
            
        }
        
        self.tweetsContainer.alpha = 1
        self.mediaContainer.alpha = 0
        self.likesContainer.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didTapLogout(_ sender: UIButton) {
        try! Auth.auth().signOut()
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeViewController = mainStoryboard.instantiateViewController(withIdentifier: "welcomeViewController")
        self.present(welcomeViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func showComponents(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5) {
                self.tweetsContainer.alpha = 1
                self.mediaContainer.alpha = 0
                self.likesContainer.alpha = 0
            }
        } else if sender.selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 0.5) {
                self.tweetsContainer.alpha = 0
                self.mediaContainer.alpha = 1
                self.likesContainer.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.tweetsContainer.alpha = 0
                self.mediaContainer.alpha = 0
                self.likesContainer.alpha = 1
            }
        }
    }
    
    internal func setProfilePicture(imageView:UIImageView, imageToSet image: UIImage){
        imageView.image = image
    }
    
    @IBAction func didTapProfilePicture(_ sender: UITapGestureRecognizer) {
        //create action sheet
        let profileActionSheet = UIAlertController(title: "Profile Picture", message: "Select", preferredStyle: .actionSheet)
        let viewPicture = UIAlertAction(title: "View picture", style: .default) { (action) in
            let imageView = sender.view as! UIImageView
            let newImageView = UIImageView(image: imageView.image)
            
            newImageView.frame = self.view.frame
            newImageView.backgroundColor = UIColor.black
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullScreenImage))
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
        }
        let photoGallery = UIAlertAction(title: "Photos", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        profileActionSheet.addAction(viewPicture)
        profileActionSheet.addAction(photoGallery)
        profileActionSheet.addAction(camera)
        profileActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(profileActionSheet, animated: true, completion: nil)
    }
    
    @objc func dismissFullScreenImage(sender: UITapGestureRecognizer) {
        // remove the larger image from the view
        sender.view?.removeFromSuperview()
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.imageLoader.startAnimating()
        setProfilePicture(imageView: self.profilePicture, imageToSet: image)
        
        if let imageData = UIImagePNGRepresentation(self.profilePicture.image!) {
            let profilePicStorageRef = self.storageRef.child("user_profiles/\(self.loggedInUser.uid)/profile_pic")
            
            _ = profilePicStorageRef.putData(imageData, metadata: nil){metadata, error in
                guard metadata != nil else {
                    print(error!.localizedDescription)
                    return
                }
                profilePicStorageRef.downloadURL(completion: { (url, error) in
                    guard let downloadURL = url else {
                        print(error!.localizedDescription)
                        return
                    }
                    self.databaseRef.child("user_profiles").child(self.loggedInUser.uid).child("profile_pic").setValue(downloadURL.absoluteString)
                })
               self.imageLoader.stopAnimating()
            }
            
        }
        self.dismiss(animated: true, completion: nil)
    }
}
