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
#import "MFLinkedInActivityItem.h"
#import "MFLinkedInComposePresentationViewController.h"
#import "MFTransitioningDelegate.h"

#import "MFLinkedInActivityDelegate.h"

@class MFLinkedInAuthenticationViewController,MFLinkedInComposePresentationViewController;

///  Provide LinkedIn sharing service to the user. Handle sign-in and authentication process.
@interface MFLinkedInUIActivity : UIActivity

///  Store a reference to the data items in the activityItems parameter of the prepareWithActivityItems: method.
@property (nonatomic,strong) NSArray *linkedInActivityItems;

///  An instance of MFLinkedInAccount is responsable for saving/storing the access token obtained from the MFLinkedInAuthenticationViewController (in the application keychain), retrieving the access token, and refresh it when it expires.
@property (nonatomic,strong) MFLinkedInAccount *linkedInAccount;

///  Delegate object use to send messages to client app from either MFLinkedInComposeViewController or MFLinkedInAuthenticationViewController.
@property (nonatomic, weak) id<MFLinkedInActivityDelegate> delegate;


///  Initializes itself and uses the LinkedIn parameters to initialize it's MFLinkedInAccount property.
///
///  @param APIKey    LinkedIn API Key
///  @param secretKey LinkedIn Secret Key
///
///  @return Initialized MFLinkedInUIActivity
-(id)initWithAPIKey:(NSString*)APIKey secretKey:(NSString*)secretKey;

@end