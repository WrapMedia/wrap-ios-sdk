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
    
    @IBOutlet weak var webView : UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}

