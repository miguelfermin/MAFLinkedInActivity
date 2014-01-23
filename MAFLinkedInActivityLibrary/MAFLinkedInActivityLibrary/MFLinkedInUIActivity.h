//
//  LinkedInUIActivity.h
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 12/19/13.
//  Copyright (c) 2013 Miguel Fermin. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MFLinkedInAccount.h"
#import "MFLinkedInAuthenticationViewController.h"
#import "MFLinkedInComposeViewController.h"
#import "MFLinkedInActivityItem.h"

@class MFLinkedInAuthenticationViewController,MFLinkedInComposeViewController;

///  Provide LinkedIn sharing service to the user. Handle sign-in and authentication process.
@interface MFLinkedInUIActivity : UIActivity

///  An instance of MFLinkedInAccount is responsable for saving/storing the access token obtained from the MFLinkedInAuthenticationViewController (in the application keychain), retrieving the access token, and refresh it when it expires.
@property (nonatomic,strong) MFLinkedInAccount *linkedInAccount;

///  This is the view controller that will be returned by the activityViewController method. This propery will be instantiated to be either an instance of MFLinkedInAuthenticationViewController or MFLinkedInComposeViewController in the prepareWithActivityItems: method, depending on the access token availability. This ViewController is presented to the user when the LinkedIn service is selected.
@property (nonatomic,strong) UIViewController *linkedInActivityViewController;

///  Manage the LinkedIn authentication process.
@property (nonatomic,strong) MFLinkedInAuthenticationViewController *authenticationViewController;

///  Manage the LinkedIn compose process.
@property (nonatomic,strong) MFLinkedInComposeViewController *composeViewController;

///  Store a reference to the data items in the activityItems parameter of the prepareWithActivityItems: method.
@property (nonatomic,strong) NSArray *linkedInActivityItems;


///  Create an instance of MFLinkedInAuthenticationViewController and assign it to linkedInActivityViewController. The super class (UIActivity) activityViewController method will return this view controller.
-(void)prepareLinkedInActivityViewControllerToAuthenticate;

///  Create an instance of MFLinkedInComposeViewController and assign it to linkedInActivityViewController. The super class (UIActivity) activityViewController method will return this view controller.
-(void)prepareLinkedInActivityViewControllerToCompose;

@end
