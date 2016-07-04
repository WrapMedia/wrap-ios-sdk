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
     Returns the top-most view controller in the app.
     */
    class func currentViewController(vc: UIViewController? = nil) -> UIViewController? {
        if let vc = vc {
            if let modalVC = vc.presentedViewController {
                //// there's a modal on top of this vc, so recurse into it...
                return WrapUI.currentViewController(modalVC)
            } else if let navVC = vc as? UINavigationController {
                //// for nav controllers, recurse into top of stack
                if let topVC = navVC.topViewController {
                    return WrapUI.currentViewController(topVC)
                } else {
                    return navVC
                }
            } else if let tabVC = vc as? UITabBarController {
                //// for tab controllers, recurse into current selection
                if let selectedVC = tabVC.selectedViewController {
                    return WrapUI.currentViewController(selectedVC)
                } else {
                    return tabVC
                }
            } else if let splitVC = vc as? UISplitViewController {
                //// for split view controllers, recurse into the right side...
                if let rightVC = splitVC.viewControllers.last {
                    return WrapUI.currentViewController(rightVC)
                } else {
                    splitVC
                }
            } else {
                //// we're done here...!
                return vc
            }
        } else if let vc = UIApplication.sharedApplication().keyWindow?.rootViewController {
            return WrapUI.currentViewController(vc)
        }
        return nil
    }
    
    /**
     Convenience function for checking a push notification dictionary for a Wrap ID, then presenting
     it in a WrapViewController on top of the current view controller.
     */
    public class func presentWrapFromPushNotification(notification: NSDictionary, launched: Bool = true) -> Bool {
        if let wrapID = notification["wrapID"] as? String {
            //// find the current top-most view controller
            if let vc = WrapUI.currentViewController() {
                if launched {
                    //// launched from notification, so display immediately
                    WrapUI.presentWrapWithUUID(wrapID, parentViewController: vc)
                    return true
                } else {
                    //// app in foreground, first prompt the user
                    if let aps = notification["aps"] as? [String: AnyObject],
                       let alert = aps["alert"] as? String {
                        let alert = UIAlertController(title: nil, message: alert, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("View", comment: "Alert button accept title"),
                            style: .Default,
                            handler: { action in
                                WrapUI.presentWrapWithUUID(wrapID, parentViewController: vc)
                            })
                        )
                        alert.addAction(UIAlertAction(title: NSLocalizedString("No thanks", comment: "Alert button decline title"),
                            style: .Cancel,
                            handler: nil))
                        if #available(iOS 9.0, *) {
                            alert.preferredAction = alert.actions[0]
                        }
                        vc.presentViewController(alert, animated: true, completion: nil)
                        return true
                    }
                }
            }
        }
        return false
    }
    
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
