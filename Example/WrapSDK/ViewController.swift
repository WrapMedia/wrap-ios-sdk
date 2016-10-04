//
//  ViewController.swift
//  WrapSDK
//
//  Created by Jay Hall on 06/30/2016.
//  Copyright (c) 2016 Jay Hall. All rights reserved.
//

import UIKit
import WrapSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func presentProfilePressed(_ sender: UIButton) {
        WrapUI.presentWrapProfileWithUUID("fca9e3ab-629d-4740-b2f7-3135f3900b00", parentViewController: self)
    }
    
    @IBAction func presentWrapViewer(_ sender: AnyObject?) {
        WrapUI.presentWrapWithUUID("d5c76bee-7967-438c-92e2-ef3ff32e7e83", parentViewController: self)
//        WrapUI.presentWrapFromPushNotification([
//            "wrapID": "d5c76bee-7967-438c-92e2-ef3ff32e7e83",
//            "aps": [
//                "alert": "This is a test."
//            ]
//        ], launched: false)
    }
}

