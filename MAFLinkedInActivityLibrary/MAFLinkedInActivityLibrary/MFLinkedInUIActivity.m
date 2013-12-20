//
//  LinkedInUIActivity.m
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


#import "MFLinkedInUIActivity.h"

// Authentication data
#define API_KEY             @"77tp47xbo381qe"
#define SECRET_KEY          @"0000"
#define OAUTH_USER_TOKEN    @"0000"
#define OAUTH_USER_SECRET   @"0000"


@implementation MFLinkedInUIActivity


#pragma mark - Methods to Override to provide LinkedIn service information.

+(UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}

-(NSString *)activityType {
    return @"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn";
}

-(NSString *)activityTitle {
    return NSLocalizedString(@"LinkedIn", @"LinkedIn");
}

-(UIImage *)activityImage {
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"activity" ofType:@"png"]];// This image is a placeholder for now.
}

-(BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

-(void)prepareWithActivityItems:(NSArray *)activityItems {
    
    // ** This is assuming authentication is required. This code will run only when getting the access_token for the first time ** //
    
    
    // Initialize the webview presenting LinkedIn's authentication dialog.
    
    _authenticationWebView = [[UIWebView alloc]init];
    
    _authenticationViewController = [[UIViewController alloc]init];
    
    _authenticationViewController.view = _authenticationWebView;
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelActivity)];
    
    _authenticationViewController.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    
    // Prepare redirect to LinkedIn's authorization dialog
    NSString *scope = @"r_basicprofile";
    NSString *state = @"DCMMFWF10268sdffef102";
    NSString *redirectURI = @"https://www.google.com";// redirect to Google now, need to figure out the app URI.
    NSString *linkedInAuthorizationDialog = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=%@&scope=%@&state=%@&redirect_uri=%@", API_KEY, scope, state, redirectURI];
    [_authenticationWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:linkedInAuthorizationDialog]]];
    
    
    // Prepare UINavigationViewController
    _authenticationNavigationViewController = [[UINavigationController alloc]init];
    
    // iPhone and iPod modal view are always in full screen and will ignores this presentation style
    [_authenticationNavigationViewController setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [_authenticationNavigationViewController addChildViewController:_authenticationViewController];
}



#pragma mark - Custom Activity View Controller

// This method returns the authorization dialog view for now. Will be updated.
-(UIViewController *)activityViewController {
    return _authenticationNavigationViewController;
}



-(void)cancelActivity {
    [self activityDidFinish:NO];
}

@end
