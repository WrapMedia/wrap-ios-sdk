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
                    imageURL = imageURL.substring(from: imageURL.characters.index(imageURL.startIndex, offsetBy: 2))
                }
                if imageURL.hasPrefix("//") {
                    imageURL = imageURL.substring(from: imageURL.characters.index(imageURL.startIndex, offsetBy: 2))
                }
                imageURL = "https://\(imageURL)"
            }
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
