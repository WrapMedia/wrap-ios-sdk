//
//  WrapUI.swift
//  Pods
//
//  Created by Francis Li on 6/30/16.
//
//

import UIKit

public class WrapUI: NSObject {
    /**
     Convenience function for presenting a WrapViewController that loads a Wrap
     with the specified UUID.
     */
    public class func presentWrapWithUUID(uuid: String, parentViewController: UIViewController) {
        
        let podBundle = NSBundle(forClass: self)
        let bundleURL = podBundle.URLForResource("WrapSDK", withExtension: "bundle")
        
        let storyboard = UIStoryboard.init(name: "WrapViewer", bundle: NSBundle(URL: bundleURL!)!)
        let vc = storyboard.instantiateInitialViewController() as! UINavigationController
        let wrapVC = vc.topViewController as! WrapViewController
        wrapVC.wrapID = uuid
        parentViewController.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    /**
     Convenience function for presenting a WrapProfileViewController that loads a Wrap Profile
     with the specified UUID.
     */
    public class func presentWrapProfileWithUUID(uuid: String, parentViewController: UIViewController) {
        let podBundle = NSBundle(forClass: self)
        let bundleURL = podBundle.URLForResource("WrapSDK", withExtension: "bundle")
        
        let storyboard = UIStoryboard.init(name: "WrapProfile", bundle: NSBundle(URL: bundleURL!)!)
        let vc = storyboard.instantiateInitialViewController() as! UINavigationController
        let profileVC = vc.topViewController as! WrapProfileViewController
        profileVC.profileUUID = uuid
        parentViewController.presentViewController(vc, animated: true, completion: nil)
    }
}
