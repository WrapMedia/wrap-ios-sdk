//
//  WrapProfileViewController.swift
//  Pods
//
//  Created by Francis Li on 6/30/16.
//
//

import UIKit

class WrapProfileViewController: UICollectionViewController {
    
    var profileUUID: String!
    
    private var profileData: [String: AnyObject]?
    
    private var wraps: [AnyObject]?
    private var page: Int = 0
    private var hasNext: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchProfile()
    }
    
    func fetchProfile() {
        if profileData == nil {
            WrapAPI.sharedInstance.fetchProfileWithUUID(profileUUID) { [weak self] data, response, error in
                if let data = data where error == nil {
                    self?.profileData = data
                    NSOperationQueue.mainQueue().addOperationWithBlock { [weak self] in
                        self?.collectionView?.reloadData()
                    }
                    self?.fetchWraps()
                } else {
                    //// TODO show some sort of error state
                }
            }
        }
    }

    func fetchWraps() {
        WrapAPI.sharedInstance.fetchWrapsForProfileWithUUID(profileUUID, page: page) { [weak self] data, response, error in
            if let data = data where error == nil {
                if self?.wraps == nil {
                    self?.wraps = data
                    NSOperationQueue.mainQueue().addOperationWithBlock { [weak self] in
                        self?.collectionView?.reloadData()
                    }
                }
            } else {
                //// TODO show some sort of error state
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func donePressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "coverView", forIndexPath: indexPath) as! WrapProfileCoverView
        if let profileData = profileData {
            headerView.imageURL = profileData["coverImage"] as? String
            headerView.text = profileData["name"] as? String
        }
        return headerView
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wraps?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("thumbnailCell", forIndexPath: indexPath) as! WrapProfileThumbnailCell
        
        if let wrap = wraps?[indexPath.row] as? [String: AnyObject],
           let cards = wrap["cards"] as? [AnyObject],
           let card = cards[0] as? [String: AnyObject],
           let preview = card["preview"] as? [String: AnyObject] {
            cell.imageURL = preview["medium"] as? String
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.size.width
        let height = floor(width * 28.0 / 75.0)
        return CGSizeMake(width, height)
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let sectionInset = flowLayout.sectionInset
        let width = floor((collectionView.frame.size.width - flowLayout.minimumInteritemSpacing - sectionInset.left - sectionInset.right) / 2)
        let height = floor(width * 91.0 / 64.0)
        return CGSizeMake(width, height)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let wrap = wraps?[indexPath.row] as? [String: AnyObject],
           let id = wrap["id"] as? String {
            WrapUI.presentWrapWithUUID(id, parentViewController: self)
        }
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
