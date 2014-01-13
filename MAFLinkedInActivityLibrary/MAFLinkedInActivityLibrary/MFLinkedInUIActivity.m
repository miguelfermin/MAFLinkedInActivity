//
//  LinkedInUIActivity.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 12/19/13.
//  Copyright (c) 2013 Miguel Fermin. All rights reserved.
//
//  Description: xx...
//
//  How to use: xx...


#import "MFLinkedInUIActivity.h"

@implementation MFLinkedInUIActivity

-(id)init {
    self = [super init];
    if (self) {
        
        // Initialize linkedInAccount instance variable.
        _linkedInAccount = [[MFLinkedInAccount alloc]init];
    }
    return self;
}



#pragma mark - Methods to Override to provide LinkedIn service information.

+(UIActivityCategory)activityCategory {
    //NSLog(@"activityCategory");
    return UIActivityCategoryShare;
}

-(NSString *)activityType {
    //NSLog(@"activityType");
    return @"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn";
}

-(NSString *)activityTitle {
    //NSLog(@"activityTitle");
    return NSLocalizedString(@"LinkedIn", @"LinkedIn");
}

-(UIImage *)activityImage {
    
    //return [UIImage imageNamed:@"linkedIn-positive"];
    return [UIImage imageNamed:@"linkedIn-negative"];
}

-(BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    //NSLog(@"canPerformWithActivityItems:");
    return YES;
}

-(void)prepareWithActivityItems:(NSArray *)activityItems {
    //NSLog(@"prepareWithActivityItems:");
    
    if ([_linkedInAccount accessToken]) {
        NSLog(@"GOOD TOKEN: %@, Composing View Should Be Presented\n ",[_linkedInAccount accessToken]);
        
        /*
         * NOTES: 
         *          - Access token exists, but the expiration date needs to checked. If access token is expired, ask _linkedInAccount to refresh it.
         *
         *          - At the moment the _linkedInActivityViewController is presented with _authenticationViewController for iPad, this needs fix, MF, 2014.01.13
         */
        
        if ([_linkedInAccount tokenNeedsToBeRefreshed]) { // Case when access_token needs to be refreshed
            
            NSLog(@"ACCESS TOKEN NEEDS TO BE REFRESHED");
        }
        else { // Case when access_token is valid and the compose view needs to be prepared
            
            NSLog(@"PRESENT COMPOSE_VIEW");
        }
    }
    else {
        NSLog(@"NULL TOKEN: %@, Authentication View Should Be Presented",[_linkedInAccount accessToken]);
        
        // Access token doesn't exist, so the user needs to be authenticated.
        
        [self prepareLinkedInActivityViewControllerToAuthenticate];
    }
}


-(void)prepareLinkedInActivityViewControllerToAuthenticate {
    
    // Setup  _authenticationViewController and assign it to the _linkedInActivityViewController.
    
    _authenticationViewController = [[MFLinkedInAuthenticationViewController alloc]init];
    
    [_authenticationViewController setLinkedInUIActivity:self];
    
    _linkedInActivityViewController = _authenticationViewController;
}



#pragma mark - Custom Activity View Controller

// This method returns the authorization dialog view for now. Will be updated.
-(UIViewController *)activityViewController {
    return _linkedInActivityViewController;
}

@end
