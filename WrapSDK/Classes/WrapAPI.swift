//
//  WrapAPI.swift
//  Pods
//
//  Created by Francis Li on 6/30/16.
//
//

import UIKit

open class WrapAPI: NSObject {
    open static var sharedInstance = WrapAPI(baseURL: "https://api.wrap.co/")
    
    fileprivate var baseURL: URL

    public init(baseURL: String) {
        self.baseURL = URL(string: baseURL)!
        super.init()
    }
    
    open func fetchProfileWithUUID(_ uuid: String, completion: @escaping (_ data: [String: AnyObject]?, _ response: URLResponse?, _ error: NSError?) -> Void) {
        let url = URL(string: "/api/profiles/\(uuid)", relativeTo: baseURL)!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if let data = data , error == nil {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
                    completion(parsedData as! [String: AnyObject], response, error as NSError?)
                } catch {
                    completion(nil, response, error as NSError)
                }
            } else {
                completion(nil, response, error as NSError?)
            }
        }) 
        task.resume()
    }
    
    open func fetchWrapsForProfileWithUUID(_ uuid: String, page: Int, completion: @escaping (_ data: [AnyObject]?, _ response: URLResponse?, _ error: NSError?) -> Void) {
        let url = URL(string: "/api/profiles/\(uuid)/wraps?page=\(page)", relativeTo: baseURL)!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if let data = data , error == nil {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
                    completion(parsedData as! [AnyObject], response, error as NSError?)
                } catch {
                    completion(nil, response, error as NSError)
                }
            } else {
                completion(nil, response, error as NSError?)
            }
        }) 
        task.resume()
    }
}
