//
//  MFTransitioningDelegate.h
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/27/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MFTransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>


@property (nonatomic) BOOL reverse;


@end
