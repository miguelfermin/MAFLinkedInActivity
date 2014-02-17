//
//  ComposeOverLayViewController.h
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/24/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFLinkedInActivityItem.h"
#import "MFLinkedInUIActivity.h"
#import "MFLinkedInComposeViewController.h"

@class MFLinkedInUIActivity,MFLinkedInActivityItem,MFLinkedInComposeViewController;

@interface MFLinkedInComposePresentationViewController : UIViewController

///  Reference to child VC.
@property (nonatomic,strong) MFLinkedInComposeViewController *composeViewController;

/// Weak reference to MFLinkedInUIActivity in order to call the activityDidFinish: to dismiss the linkedInActivityViewController.
@property (nonatomic,weak) MFLinkedInUIActivity *linkedInUIActivity;

///  MFLinkedInActivityItem has the share content encapsulated.
@property(nonatomic,strong) MFLinkedInActivityItem *linkedInActivityItem;


///  This method calls activityDidFinish: method and sends NO to it's complete parameter to indicate that the service wasn't completed successfully.
-(void)cancelActivity;

///  Dismiss compose view by calling activityDidFinish: passing YES to it's complete parameter to indicate that the service was completed successfully. Also present the user with a successfully message.
-(void)donePosting;

@end
