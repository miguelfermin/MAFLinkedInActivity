//
//  MFTransitioningDelegate.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/27/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFTransitioningDelegate.h"


@implementation MFTransitioningDelegate

{
    CGFloat _presentedViewHeightPortrait;
    CGFloat _presentedViewHeightLandscape;
}

-(id)init {
    self = [super init];
    if (self) {
        // Initialize self.
    }
    return self;
}

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
    return 0.4f;
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
    
    
    /* works on iPhone only...
     CGRect  fromRect = fromViewController.view.frame;
     CGPoint fromPoint = fromViewController.view.frame.origin;
     UIView *fromView = fromViewController.view;
     UIView *toView =   toViewController.view;
     NSLog(@"fromRect.size.width:  %f",fromRect.size.width);
     NSLog(@"fromRect.size.height: %f\n ",fromRect.size.height);
     CGRect  convertedRect0 =  [fromView convertRect:fromRect toView:toView];
     CGRect newFrame = CGRectMake(0.0, 0.0, convertedRect0.size.width/2, convertedRect0.size.height/2);*/
    /*CATransition *transition = [CATransition animation];
    transition.startProgress = 0;
    transition.endProgress = 1.0;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    transition.duration = 0.6;
     if reserve
     [container insertSubview:toViewController.view belowSubview:fromViewController.view];
     [fromViewController.view.layer addAnimation:transition forKey:@"transition"];
     otherwise
     [toViewController.view.layer addAnimation:transition forKey:@"transition"];
     [container addSubview:toViewController.view];
     [toViewController.view.layer addAnimation:transition forKey:@"transition"];
    NSLog(@"BEFORE, toViewController.view.frame = [self rectForPresentedState:transitionContext];");
    NSLog(@"toViewController.view.frame.origin.x:     %f",toViewController.view.frame.origin.x);
    NSLog(@"toViewController.view.frame.origin.y:     %f",toViewController.view.frame.origin.y);
    NSLog(@"toViewController.view.frame.size.width:   %f",toViewController.view.frame.size.width);
    NSLog(@"toViewController.view.frame.size.height:  %f\n ",toViewController.view.frame.size.height);
    NSLog(@"fromViewController.view.frame.origin.x:     %f",fromViewController.view.frame.origin.x);
    NSLog(@"fromViewController.view.frame.origin.y:     %f",fromViewController.view.frame.origin.y);
    NSLog(@"fromViewController.view.frame.size.width:   %f",fromViewController.view.frame.size.width);
    NSLog(@"fromViewController.view.frame.size.height:  %f\n ",fromViewController.view.frame.size.height);
    //toViewController.view.frame = [self rectForPresentedState:transitionContext];
    //toViewController.view.frame = CGRectMake(0.0, 0.0, 320.0, 568.0);
    NSLog(@"AFTER, toViewController.view.frame = [self rectForPresentedState:transitionContext];");
    NSLog(@"toViewController.view.frame.origin.x:     %f",toViewController.view.frame.origin.x);
    NSLog(@"toViewController.view.frame.origin.y:     %f",toViewController.view.frame.origin.y);
    NSLog(@"toViewController.view.frame.size.width:   %f",toViewController.view.frame.size.width);
    NSLog(@"toViewController.view.frame.size.height:  %f\n ",toViewController.view.frame.size.height);
    CGRect presentingRect;
    switch (fromViewController.interfaceOrientation) {
        case UIInterfaceOrientationLandscapeRight:
            presentingRect  = CGRectMake(0.0, 0.0, LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            presentingRect  = CGRectMake(0.0, 0.0, LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            presentingRect  = CGRectMake(0.0, 0.0, PORTRAIT_WIDTH, PORTRAIT_HEIGHT);
            break;
        case UIInterfaceOrientationPortrait:
            presentingRect  = CGRectMake(0.0, 0.0, PORTRAIT_WIDTH, PORTRAIT_HEIGHT);
            break;
        default:
            presentingRect = CGRectZero;
            break;
    }*/
    
    
    if (self.presenting) {
        // set starting rect for animation
        
        toViewController.view.frame = [self rectForPresentedState:transitionContext];
        
        
        //[containerView addSubview:toViewController.view];
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
         
                         animations:^{
                             toViewController.view.frame = [self rectForPresentedState:transitionContext];
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
    else {
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             
                             //fromViewController.view.frame = [self rectForDismissedState:transitionContext];
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
