//
//  PopAnimation.m
//  LoginMode
//
//  Created by Qin on 2016/10/22.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPopAnimation.h"

@implementation SPPopAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.7;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    toViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
    toViewController.view.alpha = 0.5;
    CGRect frame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect offScreenFrame = frame;
    offScreenFrame.origin.x = offScreenFrame.size.width;
    
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewController.view.transform = CGAffineTransformIdentity;
        toViewController.view.alpha = 1.0f;
        fromViewController.view.frame = offScreenFrame;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
