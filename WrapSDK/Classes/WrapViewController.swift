//
//  WrapViewController.swift
//  Pods
//
//  Created by Jay Hall on 6/30/16.
//
//

import UIKit
import WebKit

private let baseURL : URL = URL(string: "https://wrap.co/wraps")!

class WrapViewController: UIViewController {
    
    open var wrapID: String?
    
    @IBOutlet weak var wrapperView: UIView!
    
    var webView : WKWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.frame = wrapperView.bounds
        webView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        webView.scrollView.backgroundColor = UIColor.clear
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        wrapperView.addSubview(webView)
//        configureAutolayoutConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //// append Wrap UUID to path
        //// TODO: validate UUID format
        guard let uuid = wrapID else { return }
        let url = baseURL.appendingPathComponent(uuid)
        
        //// appent nocontrols query param to hide menu and library controls
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        components.query = "nocontrols"
        
        //// construct and load
        guard let finalURL = components.url else { return }
        let request = URLRequest(url: finalURL)
        webView.load(request)
    }
    
    @IBAction func tappedDone(_ sender: AnyObject?) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func configureAutolayoutConstraints()
    {
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 9.0, *) {
            webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            webView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        } else {
            // Fallback on earlier versions
        }
        
        
        view.layoutIfNeeded()
    }

}

