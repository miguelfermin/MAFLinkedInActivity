//
//  MFLinkedInAuthenticationViewController.h
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/6/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFLinkedInUIActivity.h"

@class MFLinkedInUIActivity;

///  Manage the LinkedIn authentication process.
@interface MFLinkedInAuthenticationViewController : UINavigationController

/// Weak reference to MFLinkedInUIActivity in order to call the activityDidFinish: when the cancel button is tapped.
@property (nonatomic,weak) MFLinkedInUIActivity *linkedInUIActivity;

///  Initialize UIWebView to present LinkedIn's authentication dialog.
-(void)prepareAuthenticationView;

@end