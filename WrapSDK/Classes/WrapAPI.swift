//
//  WrapAPI.swift
//  Pods
//
//  Created by Francis Li on 6/30/16.
//
//

import UIKit

public class WrapAPI: NSObject {
    public static var sharedInstance = WrapAPI(baseURL: "https://api.wrap.co/")
    
    private var baseURL: NSURL

    public init(baseURL: String) {
        self.baseURL = NSURL(string: baseURL)!
        super.init()
    }
    
    public func fetchProfileWithUUID(uuid: String, completion: (data: [String: AnyObject]?, response: NSURLResponse?, error: NSError?) -> Void) {
        let url = NSURL(string: "/api/profiles/\(uuid)", relativeToURL: baseURL)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url) { data, response, error in
            if let data = data where error == nil {
                do {
                    let parsedData = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
                    completion(data: parsedData as! [String: AnyObject], response: response, error: error)
                } catch {
                    completion(data: nil, response: response, error: error as! NSError)
                }
            } else {
                completion(data: nil, response: response, error: error)
            }
        }
        task.resume()
    }
}
