//
//  WrapViewController.swift
//  Pods
//
//  Created by Jay Hall on 6/30/16.
//
//

import UIKit
import WebKit

private let baseURL : NSURL = NSURL(string: "https://wrap.co/wraps")!

class WrapViewController: UIViewController {
    
    public var wrapID: String?
    
    var webView : WKWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        configureAutolayoutConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let uuid = wrapID else { return }
        
        
        let url = baseURL.URLByAppendingPathComponent(uuid)
        let request = NSURLRequest(URL: url)
        
        webView.loadRequest(request)
    }
    
    @IBAction func tappedDone(sender: AnyObject?) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func configureAutolayoutConstraints()
    {
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 9.0, *) {
            webView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
            webView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
            webView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        } else {
            // Fallback on earlier versions
        }
        
        
        view.layoutIfNeeded()
    }

}

