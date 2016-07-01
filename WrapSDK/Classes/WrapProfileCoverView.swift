//
//  WrapProfileCoverView.swift
//  Pods
//
//  Created by Francis Li on 6/30/16.
//
//

import UIKit

class WrapProfileCoverView: UICollectionReusableView {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var label: UILabel!

    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    var imageURL: String? {
        didSet {
            downloadImage()
        }
    }
    
    func downloadImage() {
        if let imageURL = imageURL {
            let url = NSURL(string: imageURL)!
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url) { data, response, error in
                if let data = data where error == nil {
                    NSOperationQueue.mainQueue().addOperationWithBlock { [weak self] in
                        self?.imageView.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        }
    }
}
