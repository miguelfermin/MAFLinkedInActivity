//
//  MFTransitioningDelegate.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/27/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFTransitioningDelegate.h"
#import "MAFLinkedInActivity.h"

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
    return 0.3f;
}

-(void)animateTransition:(id)transitionContext {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    
    // Used for testing
    /*
    CATransition *transition = [CATransition animation];
    transition.startProgress = 0;
    transition.endProgress = 1.0;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    transition.duration = 0.3;
    UIView *fromView = [fromViewController view];
    UIView *toView =   [toViewController view];
    MFLog(@"BEFORE");
    MFLog(@"toView.frame.origin.x:        %f",toView.frame.origin.x);
    MFLog(@"toView.frame.origin.y:        %f",toView.frame.origin.y);
    MFLog(@"toView.frame.origin.width:    %f",toView.frame.size.width);
    MFLog(@"toView.frame.origin.height:   %f\n ",toView.frame.size.height);
    MFLog(@"toView.bounds.size.width:     %f",toView.bounds.size.width);
    MFLog(@"toView.bounds.size.height:    %f",toView.bounds.size.height);
    MFLog(@"toView.bounds.origin.x:       %f",toView.bounds.origin.x);
    MFLog(@"toView.bounds.origin.y:       %f\n ",toView.bounds.origin.y);
    MFLog(@"BEFORE");
    MFLog(@"containerView.frame.origin.x:        %f",containerView.frame.origin.x);
    MFLog(@"containerView.frame.origin.y:        %f",containerView.frame.origin.y);
    MFLog(@"containerView.frame.origin.width:    %f",containerView.frame.size.width);
    MFLog(@"containerView.frame.origin.height:   %f\n ",containerView.frame.size.height);
    MFLog(@"containerView.bounds.size.width:     %f",containerView.bounds.size.width);
    MFLog(@"containerView.bounds.size.height:    %f",containerView.bounds.size.height);
    MFLog(@"containerView.bounds.origin.x:       %f",containerView.bounds.origin.x);
    MFLog(@"containerView.bounds.origin.y:       %f\n ",containerView.bounds.origin.y);*/
    
    
    /* Get the correct device frame  */
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        // Adjust mask in case of rotation after presentation. This is an issue on iPhone only
        
        [toViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
        _presentedViewHeightPortrait =  fromViewController.view.frame.size.height;
        
        _presentedViewHeightLandscape = fromViewController.view.frame.size.width;
    }
    else {
        // Compensate for status bar on iPad; 20 pts. The frame is not including the status bar.
        
        _presentedViewHeightPortrait =  toViewController.view.frame.size.height+20;
        
        _presentedViewHeightLandscape = toViewController.view.frame.size.width+20;
    }
    
    /* Perform presinting animation */
    
    if (self.presenting) {
        
        // rectForPresentedState: calculates the correct frame based on device type and orientation
        
        toViewController.view.frame = [self rectForPresentedState:transitionContext];
        
        [containerView addSubview:toViewController.view];
        
        //toViewController.view.alpha = 0; // Alternative if transform don't work
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
         
                         animations:^{
                             
                             //toViewController.view.alpha = 1.0;
                             
                             // Set transform not on the "from view", but to it's child's view; the floating container that presents the post view.
                             
                             [[[toViewController.childViewControllers firstObject]view]setTransform:CGAffineTransformMakeScale(1.2f, 1.2f)];
                             
                             [[[toViewController.childViewControllers firstObject]view]setTransform:CGAffineTransformIdentity];
                         }
                         completion:^(BOOL finished) {
                             
                             [transitionContext completeTransition:YES];
                         }];
    }
    else {
        // Simulate fade effect when dismissing the from view
        
        fromViewController.view.alpha = 1.0;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             
                             // Simulate fade effect
                             
                             fromViewController.view.alpha = 0;
                             
                             // At the moment this code works, but I need to reverse the animation, chaning the view.alpha for now
                             //[[[fromViewController.childViewControllers firstObject]view]setTransform:CGAffineTransformMakeScale(1.2f, 1.2f)];
                             //[[[fromViewController.childViewControllers firstObject]view]setTransform:CGAffineTransformIdentity];
                         }
                         completion:^(BOOL finished) {
                             
                             [transitionContext completeTransition:YES];
                             
                             [fromViewController.view removeFromSuperview];
                         }];
    }
}


#pragma mark - Helpers methods to transform the coordinate system.
/*
 * The purpose of the two methods below are described here. Information was found during an online reseach.
 *
 * For custom presentation transitions Apple setup an intermediate view between the window and the windows rootViewController's view.
 *
 * This view is the containerView that we perform our animation within.
 *
 * Due to an implementation detail of auto-rotation on iOS, when the interface rotates Apple applies an affine transform to the windows rootViewController's view and modify its bounds accordingly.
 *
 * Because the containerView inherits its dimensions from the window instead of the root view controller's view, it is always in the portrait orientation.
 *
 * If the presentation animation depends upon the orientation of the presenting view controller, we will need to detect the presenting view controller's orientation and modify our animation appropriately.
 *
 * The system will apply the correct transform to the incoming view controller but your animator needs to configure the frame of the incoming view controller.
 *
 *
 * So, the methods below detect the presenting view controller's orientation, modify the view frame, and return it. Note, actual animation doesn't happen inside these methods.
 */
-(CGRect)rectForPresentedState:(id)transitionContext {
    
    UIViewController *fromViewController;
    
    if (self.presenting) {
        fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    else {
        fromViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    
    // Get original frame which is obtained by rectForDismissedState: and returns a frame with an origin that is offset from that of the original frame.
    
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
    
    // Obtain the correct frame for device and orientation and return it
    
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