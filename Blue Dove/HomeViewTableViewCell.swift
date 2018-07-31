//
//  HomeViewTableViewCell.swift
//  Blue Dove
//
//  Created by Lobe Musonda on 7/26/18.
//  Copyright © 2018 Lobe Musonda. All rights reserved.
//

import UIKit

public class HomeViewTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var tweet: UITextView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configure(profilePic: String?, name: String, handle: String, tweet: String) {
        self.tweet.text = tweet
        self.handle.text = "@"+handle
        self.name.text = name
        
        if profilePic != nil {
            let imageData = NSData(contentsOf: NSURL(string: profilePic!)! as URL)
            self.profilePic.image = UIImage(data: imageData! as Data)
        }
    }
}
