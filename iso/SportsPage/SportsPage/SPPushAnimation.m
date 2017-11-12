//
//  SPPushAnimation.m
//  LoginMode
//
//  Created by Qin on 2016/10/22.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPushAnimation.h"

@implementation SPPushAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.7;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    //获取起点controller
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //获取终点controller
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //获取转场容器视图
    UIView *containerView = [transitionContext containerView];
    //设置终点视图的frame
    CGRect frame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect offScreenFrame = frame;
    //先将其设置到屏幕外,通过动画进入
    offScreenFrame.origin.x = offScreenFrame.size.width;
    toViewController.view.frame = offScreenFrame;
    
    //添加试图
    [containerView addSubview:toViewController.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //设置缩放和透明度
        fromViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
        fromViewController.view.alpha = 0.5;
        //设置位置
        toViewController.view.frame = frame;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

@end
