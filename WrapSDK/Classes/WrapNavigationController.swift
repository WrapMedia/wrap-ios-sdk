//
//  WrapNavigationController.swift
//  Pods
//
//  Created by Francis Li on 6/30/16.
//
//

import UIKit

class WrapNavigationController: UINavigationController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .overFullScreen
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = UIColor.white
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
            let containerView = transitionContext.containerView
            //// set initially transparent
            toView.alpha = 0
            toView.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            //// add the toView on top of the FromView
            containerView.addSubview(toView)
            //// animate fade in
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: {
                toView.alpha = 1
                toView.transform = CGAffineTransform.identity
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        } else if let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) {
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: {
                fromView.alpha = 0
                fromView.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    
    }
}
