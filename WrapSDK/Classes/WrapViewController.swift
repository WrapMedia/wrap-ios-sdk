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
    
    @IBOutlet weak var wrapperView: UIView!
    
    var webView : WKWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.frame = wrapperView.bounds
        webView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        webView.scrollView.backgroundColor = UIColor.clearColor()
        webView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        wrapperView.addSubview(webView)
//        configureAutolayoutConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //// append Wrap UUID to path
        //// TODO: validate UUID format
        guard let uuid = wrapID else { return }
        let url = baseURL.URLByAppendingPathComponent(uuid)
        
        //// appent nocontrols query param to hide menu and library controls
        guard let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false) else { return }
        components.query = "nocontrols"
        
        //// construct and load
        guard let finalURL = components.URL else { return }
        let request = NSURLRequest(URL: finalURL)
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

