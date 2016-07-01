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
        modalPresentationStyle = .OverFullScreen
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = UIColor.whiteColor()
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if let toView = transitionContext.viewForKey(UITransitionContextToViewKey),
           let containerView = transitionContext.containerView() {
            //// set initially transparent
            toView.alpha = 0
            toView.transform = CGAffineTransformMakeScale(2.5, 2.5)
            //// add the toView on top of the FromView
            containerView.addSubview(toView)
            //// animate fade in
            let duration = transitionDuration(transitionContext)
            UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
                toView.alpha = 1
                toView.transform = CGAffineTransformIdentity
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        } else if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) {
            let duration = transitionDuration(transitionContext)
            UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
                fromView.alpha = 0
                fromView.transform = CGAffineTransformMakeScale(2.5, 2.5)
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }
    
    }
}
