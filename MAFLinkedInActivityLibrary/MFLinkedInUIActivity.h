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

///  Initializes a MFLinkedInUIActivity and uses the passed LinkedIn parameters to initialize it's MFLinkedInAccount property.
///  @param APIKey    LinkedIn API Key
///  @param secretKey LinkedIn Secret Key
///  @param redirectURL LinkedIn redirect_uri
///  @note  To comply with the security specifications of OAuth 2, as of April 11, 2014, LinkedIn is requiring developers to register their applications redirect URLs.
///         LinkedIn has to confirm that the \b redirect_uri in your OAuth 2 authorization request matches a URL you've registered with them.
///         If the redirect URL you registered with LinkedIn doesn't match the redirect_uri you use here, requests to authorize new members or refresh tokens will fail
///  @return Initialized MFLinkedInUIActivity
///  @see https://developer.linkedin.com/blog/register-your-oauth-2-redirect-urls
- (id)initWithAPIKey:(NSString *)APIKey secretKey:(NSString *)secretKey redirectURL:(NSURL *)redirectURL;

///  This is an identifier for the type of service being provided, in this case LinkedIn.
///  @abstract This is a NSString constant containing the following:
///  @code
///  NSString * const MAFUIActivityTypePostToLinkedIn = @"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn";
///  @endcode
OBJC_EXPORT NSString * const MAFUIActivityTypePostToLinkedIn;

@end