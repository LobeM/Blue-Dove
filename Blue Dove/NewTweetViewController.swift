//
//  NewTweetViewController.swift
//  Blue Dove
//
//  Created by Lobe Musonda on 7/27/18.
//  Copyright © 2018 Lobe Musonda. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class NewTweetViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var newTweetTextView: UITextView!
    var databaseRef = Database.database().reference()
    var loggedInUser: AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newTweetTextView.delegate = self
        loggedInUser = Auth.auth().currentUser
        newTweetTextView.textContainerInset = UIEdgeInsetsMake(30, 20, 20, 20)
        newTweetTextView.text = "Whats happening?"
        newTweetTextView.textColor = UIColor.lightGray
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if newTweetTextView.textColor == UIColor.lightGray {
            newTweetTextView.text = ""
            newTweetTextView.textColor = UIColor.black
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func didTapTweet(_ sender: UIBarButtonItem) {
        if newTweetTextView.text.count > 0 {
            let key = self.databaseRef.child("tweets").childByAutoId().key
            let childUpdate = ["/tweets/\(self.loggedInUser!.uid)/\(key)/text":newTweetTextView.text, "/tweets/\(self.loggedInUser!.uid)/\(key)/timestamp":"\(NSDate().timeIntervalSince1970)"] as [String : Any]
            self.databaseRef.updateChildValues(childUpdate)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapStop(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
