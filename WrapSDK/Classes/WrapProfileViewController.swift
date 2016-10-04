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
    
    fileprivate var profileData: [String: AnyObject]?
    
    fileprivate var wraps: [AnyObject]?
    fileprivate var page: Int = 0
    fileprivate var hasNext: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProfile()
    }
    
    func fetchProfile() {
        if profileData == nil {
            WrapAPI.sharedInstance.fetchProfileWithUUID(profileUUID) { [weak self] data, response, error in
                if let data = data , error == nil {
                    self?.profileData = data
                    OperationQueue.main.addOperation { [weak self] in
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
            if let data = data , error == nil {
                if self?.wraps == nil {
                    self?.wraps = data
                    OperationQueue.main.addOperation { [weak self] in
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
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "coverView", for: indexPath) as! WrapProfileCoverView
        if let profileData = profileData {
            headerView.imageURL = profileData["coverImage"] as? String
            headerView.text = profileData["name"] as? String
        }
        return headerView
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wraps?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnailCell", for: indexPath) as! WrapProfileThumbnailCell
        
        if let wrap = wraps?[(indexPath as NSIndexPath).row] as? [String: AnyObject],
           let cards = wrap["cards"] as? [AnyObject],
           let card = cards[0] as? [String: AnyObject],
           let preview = card["preview"] as? [String: AnyObject] {
            cell.imageURL = preview["medium"] as? String
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.size.width
        let height = floor(width * 28.0 / 75.0)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let sectionInset = flowLayout.sectionInset
        let width = floor((collectionView.frame.size.width - flowLayout.minimumInteritemSpacing - sectionInset.left - sectionInset.right) / 2)
        let height = floor(width * 91.0 / 64.0)
        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let wrap = wraps?[(indexPath as NSIndexPath).row] as? [String: AnyObject],
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
