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

- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
    }
    return self;
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    /* Called when a transition requires the animator object to use when presenting a view controller. */
    self.presenting = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    /* Called when a transition requires the animator object to use when dismissing a view controller. */
    self.presenting = NO;
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    /* Called when a transition requires the animator object that can manage an interactive transition when dismissing a view controller. */
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    /* Called when a transition requires the animator object that can manage an interactive transition when presenting a view controller. */
    return nil;
}


#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animationEnded:(BOOL)transitionCompleted
{
    /* Called when the animation has ended. */
    self.presenting = NO; // reset state
}

- (NSTimeInterval)transitionDuration:(id)transitionContext
{
    /* Called when the system needs the duration, in seconds, of the transition animation. (required) */
    NSTimeInterval duration = 0.3;
    return duration;
}

- (void)animateTransition:(id)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    
    /* Get the correct device frame  */
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        // Adjust mask in case of rotation after presentation. This is an issue on iPhone only
        
        [toViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
        _presentedViewHeightPortrait =  fromViewController.view.frame.size.height;
        
        _presentedViewHeightLandscape = fromViewController.view.frame.size.width;
    }
    else {
        // Compensate for status bar on iPad; 20 pts. The frame is not including the status bar.
        
        CGFloat iPadStatusBarHeight = 20.0;
        
        _presentedViewHeightPortrait =  toViewController.view.frame.size.height + iPadStatusBarHeight;
        
        _presentedViewHeightLandscape = toViewController.view.frame.size.width + iPadStatusBarHeight;
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
                             
                             CGFloat scale = 1.2;
                             [[[toViewController.childViewControllers firstObject]view]setTransform:CGAffineTransformMakeScale(scale, scale)];
                             
                             [[[toViewController.childViewControllers firstObject]view]setTransform:CGAffineTransformIdentity];
                         }
                         completion:^(BOOL finished) {
                             
                             [transitionContext completeTransition:YES];
                         }];
    }
    else {
        // Simulate fade effect when dismissing the from view
        
        CGFloat alpha = 1.0;
        fromViewController.view.alpha = alpha;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             
                             // Simulate fade effect
                             CGFloat alpha2 = 0.0;
                             fromViewController.view.alpha = alpha2;
                             
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
- (CGRect)rectForPresentedState:(id)transitionContext
{
    UIViewController *fromViewController;
    
    if (self.presenting) {
        fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    else {
        fromViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    
    // Get original frame which is obtained by rectForDismissedState: and returns a frame with an origin that is offset from that of the original frame.
    
    const CGFloat kzeroCoordinate = 0.0;
    
    switch (fromViewController.interfaceOrientation) {
            
        case UIInterfaceOrientationLandscapeRight:
            
            return CGRectOffset([self rectForDismissedState:transitionContext], _presentedViewHeightLandscape, kzeroCoordinate);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            
            return CGRectOffset([self rectForDismissedState:transitionContext], -_presentedViewHeightLandscape, kzeroCoordinate);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            
            return CGRectOffset([self rectForDismissedState:transitionContext], kzeroCoordinate, _presentedViewHeightPortrait);
            break;
            
        case UIInterfaceOrientationPortrait:
            
            return CGRectOffset([self rectForDismissedState:transitionContext], kzeroCoordinate, -_presentedViewHeightPortrait);
            break;
            
        default:
            return CGRectZero;
            break;
    }
}

- (CGRect)rectForDismissedState:(id)transitionContext
{
    UIViewController *fromViewController;
    
    UIView *containerView = [transitionContext containerView];
    
    if (self.presenting) {
        fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    else {
        fromViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    
    // Obtain the correct frame for device and orientation and return it
    
    const CGFloat kzeroSize = 0.0;
    
    switch (fromViewController.interfaceOrientation) {
            
        case UIInterfaceOrientationLandscapeRight:
            
            return CGRectMake(-_presentedViewHeightLandscape, kzeroSize, _presentedViewHeightLandscape, containerView.bounds.size.height);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            
            return CGRectMake(containerView.bounds.size.width, kzeroSize, _presentedViewHeightLandscape, containerView.bounds.size.height);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            
            return CGRectMake(kzeroSize, -_presentedViewHeightPortrait, containerView.bounds.size.width, _presentedViewHeightPortrait);
            break;
            
        case UIInterfaceOrientationPortrait:
            
            return CGRectMake(kzeroSize, containerView.bounds.size.height, containerView.bounds.size.width, _presentedViewHeightPortrait);
            break;
            
        default:
            return CGRectZero;
            break;
    }
}

@end