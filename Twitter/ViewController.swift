//
//  ViewController.swift
//  Twitter
//
//  Created by WUSTL STS on 2/15/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func onLogin(sender: AnyObject) {
        
        TwitterClient.sharedInstance.login()
        

    }

}

