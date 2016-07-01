//
//  WrapProfileThumbnailCell.swift
//  Pods
//
//  Created by Francis Li on 6/30/16.
//
//

import UIKit

class WrapProfileThumbnailCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.layer.cornerRadius = 3.0
//        contentView.layer.borderWidth = 1.0
//        contentView.layer.borderColor = UIColor.redColor().CGColor// UIColor.clearColor().CGColor
//        contentView.layer.backgroundColor = UIColor.clearColor().CGColor
        contentView.layer.masksToBounds = true
    }
    
    var imageURL: String? {
        didSet {
            downloadImage()
        }
    }
    
    func downloadImage() {
        if var imageURL = imageURL {
            if !imageURL.hasPrefix("http") {
                if imageURL.hasPrefix("//") {
                    imageURL = imageURL.substringFromIndex(imageURL.startIndex.advancedBy(2))
                }
                if imageURL.hasPrefix("//") {
                    imageURL = imageURL.substringFromIndex(imageURL.startIndex.advancedBy(2))
                }
                imageURL = "https://\(imageURL)"
            }
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
