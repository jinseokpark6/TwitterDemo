//
//  TweetComposeViewController.swift
//  Twitter
//
//  Created by WUSTL STS on 2/29/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

class TweetComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    var charCount: Int = 150
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        if let user = user {
            let imageURL = user.profileURL
            if let imageURL = imageURL {
                userImageView.setImageWithURL(imageURL)
            }
            userNameLabel.text = user.name
            userIdLabel.text = "@\(user.screenName!)"

        } else {
            let imageURL = User.currentUser?.profileURL
            if let imageURL = imageURL {
                userImageView.setImageWithURL(imageURL)
            }
            userNameLabel.text = User.currentUser?.name
            userIdLabel.text = "@\(User.currentUser!.screenName!)"
        }
        
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
        
        textView.becomeFirstResponder()
        
        charCountLabel.text = "\(charCount)"

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        textView.setContentOffset(CGPointZero, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {
        
        let count = textView.text.characters.count
        charCountLabel.text = "\(charCount - count)"
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        return textView.text.characters.count + (text.characters.count - range.length) <= 150
    }

    @IBAction func onTweet(sender: AnyObject) {
        if let user = user {
            let params = ["text": textView.text!, "screen_name": userIdLabel.text!] as NSDictionary
            TwitterClient.sharedInstance.reply(params)
        }
        else{
            let params = ["status": textView.text!] as NSDictionary
            TwitterClient.sharedInstance.statusUpdate(params)
        }

        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
