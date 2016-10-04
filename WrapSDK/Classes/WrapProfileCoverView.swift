//
//  WrapProfileCoverView.swift
//  Pods
//
//  Created by Francis Li on 6/30/16.
//
//

import UIKit

class WrapProfileCoverView: UICollectionReusableView {
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var label: UILabel!

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
            let url = URL(string: imageURL)!
            let session = URLSession.shared
            let task = session.dataTask(with: url, completionHandler: { data, response, error in
                if let data = data , error == nil {
                    OperationQueue.main.addOperation { [weak self] in
                        self?.imageView.image = UIImage(data: data)
                    }
                }
            }) 
            task.resume()
        }
    }
}
