//
//  WrapUI.swift
//  Pods
//
//  Created by Francis Li on 6/30/16.
//
//

import UIKit

open class WrapUI: NSObject {
    /**
     Returns the top-most view controller in the app.
     */
    class func currentViewController(_ vc: UIViewController? = nil) -> UIViewController? {
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
        } else if let vc = UIApplication.shared.keyWindow?.rootViewController {
            return WrapUI.currentViewController(vc)
        }
        return nil
    }
    
    /**
     Convenience function for checking a push notification dictionary for a Wrap ID, then presenting
     it in a WrapViewController on top of the current view controller.
     */
    open class func presentWrapFromPushNotification(_ notification: NSDictionary, launched: Bool = true) -> Bool {
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
                        let alert = UIAlertController(title: nil, message: alert, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("View", comment: "Alert button accept title"),
                            style: .default,
                            handler: { action in
                                WrapUI.presentWrapWithUUID(wrapID, parentViewController: vc)
                            })
                        )
                        alert.addAction(UIAlertAction(title: NSLocalizedString("No thanks", comment: "Alert button decline title"),
                            style: .cancel,
                            handler: nil))
                        if #available(iOS 9.0, *) {
                            alert.preferredAction = alert.actions[0]
                        }
                        vc.present(alert, animated: true, completion: nil)
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
    open class func presentWrapWithUUID(_ uuid: String, parentViewController: UIViewController) {
        
        let podBundle = Bundle(for: self)
        let bundleURL = podBundle.url(forResource: "WrapSDK", withExtension: "bundle")
        
        let storyboard = UIStoryboard.init(name: "WrapViewer", bundle: Bundle(url: bundleURL!)!)
        let vc = storyboard.instantiateInitialViewController() as! UINavigationController
        let wrapVC = vc.topViewController as! WrapViewController
        wrapVC.wrapID = uuid
        parentViewController.present(vc, animated: true, completion: nil)
        
    }
    
    /**
     Convenience function for presenting a WrapProfileViewController that loads a Wrap Profile
     with the specified UUID.
     */
    open class func presentWrapProfileWithUUID(_ uuid: String, parentViewController: UIViewController) {
        let podBundle = Bundle(for: self)
        let bundleURL = podBundle.url(forResource: "WrapSDK", withExtension: "bundle")
        
        let storyboard = UIStoryboard.init(name: "WrapProfile", bundle: Bundle(url: bundleURL!)!)
        let vc = storyboard.instantiateInitialViewController() as! UINavigationController
        let profileVC = vc.topViewController as! WrapProfileViewController
        profileVC.profileUUID = uuid
        parentViewController.present(vc, animated: true, completion: nil)
    }
}
