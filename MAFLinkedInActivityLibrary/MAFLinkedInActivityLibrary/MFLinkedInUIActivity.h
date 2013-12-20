//
//  LinkedInUIActivity.h
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 12/19/13.
//  Copyright (c) 2013 Miguel Fermin. All rights reserved.
//
//  Description: xx...
//
//  Purpose: xx...
//
//  How to use: xx...


#import <UIKit/UIKit.h>

@interface MFLinkedInUIActivity : UIActivity


@property (nonatomic,strong) UINavigationController *authenticationNavigationViewController;
@property (nonatomic,strong) UIViewController *authenticationViewController;
@property (nonatomic,strong) UIWebView *authenticationWebView;


/*! This method dismisses the sharing interface, whether it is the LinkedIn authentication interface or the Composing interface.
 This method calls activityDidFinish: method and sends NO to it's complete parameter to indicate that the service wasn't completed successfully.
 */
-(void)cancelActivity;

@end
