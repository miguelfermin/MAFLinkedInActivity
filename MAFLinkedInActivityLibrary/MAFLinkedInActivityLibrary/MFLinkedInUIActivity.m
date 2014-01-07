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


#pragma mark - 
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
    //NSLog(@"activityImage");
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"activity" ofType:@"png"]];// This image is a placeholder for now.
}

-(BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    //NSLog(@"canPerformWithActivityItems:");
    return YES;
}

-(void)prepareWithActivityItems:(NSArray *)activityItems {
    //NSLog(@"prepareWithActivityItems:");
    
    if ([_linkedInAccount accessToken]) {
        //NSLog(@"GOOD TOKEN");
        
        // Access token exists, but the expiration date needs to checked. If access token is expired, ask _linkedInAccount to refresh it.
    }
    else {
        //NSLog(@"NULL TOKEN");
        
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
