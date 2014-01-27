//
//  MFTransitioningDelegate.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/27/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFTransitioningDelegate.h"

static NSTimeInterval const MFAnimatedTransitionDuration = 0.8f;
static NSTimeInterval const MFAnimatedTransitionMacroDuration = 0.15f;

@implementation MFTransitioningDelegate


#pragma mark - UIViewControllerTransitioningDelegate

// Called when a transition requires the animator object to use when presenting a view controller.
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    /*
     NSLog(@"animationControllerForPresentedController:  %@",presented);
     NSLog(@"presentingController:                       %@",presenting);
     NSLog(@"sourceController:                           %@",source);*/
    //presented.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    return self;
}

// Called when a transition requires the animator object to use when dismissing a view controller.
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    _reverse = YES;
    
    return self;
}

// Called when a transition requires the animator object that can manage an interactive transition when dismissing a view controller.
-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

// Called when a transition requires the animator object that can manage an interactive transition when presenting a view controller.
-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}



#pragma mark - UIViewControllerAnimatedTransitioning

// Performs a custom view controller transition animation. (required)
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    
    // Good when presentingVC is in portrait
    [toViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    // Debug orientation issue
    /*
    UIView *fromView = [fromViewController view];
    UIView *toView =   [toViewController view];
    NSLog(@"fromView.frame.origin.x:        %f",fromView.frame.origin.x);
    NSLog(@"fromView.frame.origin.y:        %f",fromView.frame.origin.y);
    NSLog(@"fromView.bounds.size.width:     %f",fromView.bounds.size.width);
    NSLog(@"fromView.bounds.size.height:    %f\n ",fromView.bounds.size.height);
    NSLog(@"container.frame.origin.x:       %f",container.frame.origin.x);
    NSLog(@"container.frame.origin.y:       %f",container.frame.origin.y);
    NSLog(@"container.bounds.size.width:    %f",container.bounds.size.width);
    NSLog(@"container.bounds.size.height:   %f\n ",container.bounds.size.height);
    NSLog(@"toView.frame.origin.x:          %f",toView.frame.origin.x);
    NSLog(@"toView.frame.origin.y:          %f",toView.frame.origin.y);
    NSLog(@"toView.bounds.size.width:       %f",toView.bounds.size.width);
    NSLog(@"toView.bounds.size.height:      %f\n ",toView.bounds.size.height);*/
    
    
#warning Temp animation, needs to be changed before release.
    if (self.reverse) {
        
        [container insertSubview:toViewController.view belowSubview:fromViewController.view];
    }
    else {
        
        toViewController.view.transform = CGAffineTransformMakeScale(0,0);
        
        [container addSubview:toViewController.view];
    }
    
    [UIView animateKeyframesWithDuration:MFAnimatedTransitionDuration
                                   delay:0
                                 options:0
                              animations:^{
                                  if (self.reverse) {
                                      fromViewController.view.transform = CGAffineTransformMakeScale(0,0);
                                  }
                                  else {
                                      toViewController.view.transform = CGAffineTransformIdentity;
                                  }
                              }
                              completion:^(BOOL finished) {
                                  
                                  [transitionContext completeTransition:finished];
                              }];
}

// Called when the system needs the duration, in seconds, of the transition animation. (required)
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return MFAnimatedTransitionDuration;
}

// Called when the animation has ended.
- (void)animationEnded:(BOOL)transitionCompleted {
    // Do nothing for now...
}


@end
