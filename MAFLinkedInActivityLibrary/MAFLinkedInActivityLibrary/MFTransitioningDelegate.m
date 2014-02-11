//
//  MFTransitioningDelegate.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/27/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFTransitioningDelegate.h"

@interface MFTransitioningDelegate ()
// Use to convert coordinate system, see rectForPresentedState: and rectForDismissedState: methods.
@property (nonatomic) CGFloat presentedViewHeightPortrait;
@property (nonatomic) CGFloat presentedViewHeightLandscape;
@end

@implementation MFTransitioningDelegate



#pragma mark - UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.presenting = YES;
    return self;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.presenting = NO;
    return self;
}



#pragma mark - UIViewControllerAnimatedTransitioning

-(void)animationEnded:(BOOL)transitionCompleted {
    // reset state
    self.presenting = NO;
}

-(NSTimeInterval)transitionDuration:(id)transitionContext {
    return 0.2f;
}

-(void)animateTransition:(id)transitionContext {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        // Adjust mask in case of rotation after presentation
        [toViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
        _presentedViewHeightPortrait = fromViewController.view.frame.size.height;
        _presentedViewHeightLandscape = fromViewController.view.frame.size.width;
    }
    else {
        _presentedViewHeightPortrait = toViewController.view.frame.size.height+20; // compensate for status bar on iPad; 20 pts
        _presentedViewHeightLandscape = toViewController.view.frame.size.width+20;
    }
    
    if (self.presenting) {
        // set starting rect for animation
        
        toViewController.view.frame = [self rectForPresentedState:transitionContext];
        
        
        //[containerView addSubview:toViewController.view];
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
         
                         animations:^{
                             
                             toViewController.view.frame = [self rectForPresentedState:transitionContext];
                             
                             // Create a fade effect when presenting the view  - EXPERIMENTAL CODE.. /*** Currently breaks transition when landscape ***/
                             //toViewController.view.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                             //toViewController.view.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             
                             [transitionContext completeTransition:YES];
                         }];
    }
    else {
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             
                             fromViewController.view.frame = [self rectForDismissedState:transitionContext];
                             
                             // Create a fade effect when presenting the view - EXPERIMENTAL CODE.. /*** Currently breaks transition when landscape ***/
                             //fromViewController.view.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                             //fromViewController.view.transform = CGAffineTransformIdentity;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [transitionContext completeTransition:YES];
                             
                             [fromViewController.view removeFromSuperview];
                         }];
    }
}



#pragma mark - Helpers methods to transform the coordinate system.

-(CGRect)rectForPresentedState:(id)transitionContext {
    
    UIViewController *fromViewController;
    
    if (self.presenting) {
        fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    else {
        fromViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    
    
    switch (fromViewController.interfaceOrientation) {
            
        case UIInterfaceOrientationLandscapeRight:
            return CGRectOffset([self rectForDismissedState:transitionContext], _presentedViewHeightLandscape, 0);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            return CGRectOffset([self rectForDismissedState:transitionContext], -_presentedViewHeightLandscape, 0);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGRectOffset([self rectForDismissedState:transitionContext], 0, _presentedViewHeightPortrait);
            break;
            
        case UIInterfaceOrientationPortrait:
            return CGRectOffset([self rectForDismissedState:transitionContext], 0, -_presentedViewHeightPortrait);
            break;
            
        default:
            return CGRectZero;
            break;
    }
}

-(CGRect)rectForDismissedState:(id)transitionContext {
    
    UIViewController *fromViewController;
    UIView *containerView = [transitionContext containerView];
    
    if (self.presenting) {
        fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    else {
        fromViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    
    switch (fromViewController.interfaceOrientation) {
            
        case UIInterfaceOrientationLandscapeRight:
            return CGRectMake(-_presentedViewHeightLandscape, 0, _presentedViewHeightLandscape, containerView.bounds.size.height);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            return CGRectMake(containerView.bounds.size.width, 0, _presentedViewHeightLandscape, containerView.bounds.size.height);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGRectMake(0, -_presentedViewHeightPortrait, containerView.bounds.size.width, _presentedViewHeightPortrait);
            break;
            
        case UIInterfaceOrientationPortrait:
            return CGRectMake(0, containerView.bounds.size.height, containerView.bounds.size.width, _presentedViewHeightPortrait);
            break;
            
        default:
            return CGRectZero;
            break;
    }
}


@end