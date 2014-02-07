//
//  MFLinkedInAuthenticationViewController.h
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/6/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFLinkedInUIActivity.h"
#import "MFLinkedInComposeViewController.h"

@class MFLinkedInUIActivity,MFLinkedInComposeViewController;

///  Manage the LinkedIn authentication process.
@interface MFLinkedInAuthenticationViewController : UINavigationController <UIWebViewDelegate>

/// Weak reference to MFLinkedInUIActivity in order to call the activityDidFinish: to dismiss the linkedInActivityViewController.
@property (nonatomic,weak) MFLinkedInUIActivity *linkedInUIActivity;

// For now this property is used to show the keyboard on compose view after dismissal
@property (nonatomic,weak) MFLinkedInComposeViewController *composeViewController;

@property (nonatomic,strong) MFLinkedInAccount *linkedInAccount;

///  Initialize UIWebView to present LinkedIn's authentication dialog.
-(void)prepareAuthenticationView;

@end