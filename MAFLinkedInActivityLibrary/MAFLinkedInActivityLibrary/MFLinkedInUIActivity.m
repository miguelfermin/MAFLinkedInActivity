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
    return UIActivityCategoryShare;
}

-(NSString *)activityType {
    return @"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn";
}

-(NSString *)activityTitle {
    return NSLocalizedString(@"LinkedIn", @"LinkedIn");
}

-(UIImage *)activityImage {
    
    return [UIImage imageNamed:@"linkedIn-positive"];
}

-(BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    
    __block BOOL hasURL = NO;
    
    [activityItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        // If obj is MFLinkedInActivityItem, it's guarantee there's a URL, since that a requirement of that class
        
        if ([obj isKindOfClass:[MFLinkedInActivityItem class]] == YES) {
            
            hasURL = YES;
            
            *stop  = YES;
            
            return;
        }
        
#warning The two cases (commented) below are for when there's no content to share, only a link. Still experimantal
         /*
        // If a URL was passed
        if ([obj isKindOfClass:[NSURL class]] == YES) {
            
            hasURL = YES;
            
            *stop  = YES;
            
            return;
        }
        
        // If a String formatted as URL was passed
        if ([obj isKindOfClass:[NSString class]] == YES && [NSURL URLWithString:obj] != nil) {
            
            hasURL = YES;
            
            *stop  = YES;
            
            return;
        }*/
    }];
    
    return hasURL;
}

-(void)prepareWithActivityItems:(NSArray *)activityItems {
    
    // Store a reference to the data items in the activityItems parameter so it can be retrieve by other methods
    
    _linkedInActivityItems = activityItems;
    
    if ([_linkedInAccount accessToken]) {
        //NSLog(@"GOOD TOKEN: %@, Composing View Should Be Presented\n ",[_linkedInAccount accessToken]);
        
        /*
         * NOTES: 
         *          - Access token exists, but the expiration date needs to be checked. If access token is expired, ask _linkedInAccount to refresh it.
         *
         *          - At the moment the _linkedInActivityViewController is presented with _authenticationViewController for iPad, this needs fix, MF, 2014.01.13
         */
        
        if ([_linkedInAccount tokenNeedsToBeRefreshed]) { // Case when access_token needs to be refreshed
            
            //NSLog(@"ACCESS TOKEN NEEDS TO BE REFRESHED");
#warning Code to handle cases when the access_token has expired is pending
        }
        else {
            //NSLog(@"PRESENT COMPOSE_VIEW");
            
            // Case when access_token is valid and the compose view needs to be prepared
            
            [self prepareLinkedInActivityViewControllerToCompose];
        }
    }
    else {
        //NSLog(@"NULL TOKEN: %@, Authentication View Should Be Presented",[_linkedInAccount accessToken]);
        
        // Access token doesn't exist, so the user needs to be authenticated.
        
        [self prepareLinkedInActivityViewControllerToAuthenticate];
    }
}



#pragma mark - Custom Activity View Controller

// This method returns the authorization dialog view for now. Will be updated.
-(UIViewController *)activityViewController {
    return _linkedInActivityViewController;
}



#pragma mark - activityViewController Setup

-(void)prepareLinkedInActivityViewControllerToAuthenticate {
    
    // Setup  _authenticationViewController and assign it to the _linkedInActivityViewController.
    
    _authenticationViewController = [[MFLinkedInAuthenticationViewController alloc]init];
    
    [_authenticationViewController setLinkedInUIActivity:self];
    
    _linkedInActivityViewController = _authenticationViewController;
}

-(void)prepareLinkedInActivityViewControllerToCompose {
    
    // Setup  _composeViewController and assign it to the _linkedInActivityViewController.
    
    _composeViewController = [[MFLinkedInComposeViewController alloc]initWithStyle:UITableViewStyleGrouped];
    
    [_composeViewController setLinkedInUIActivity:self];
    
    if ([[_linkedInActivityItems objectAtIndex:0] isKindOfClass:[MFLinkedInActivityItem class]]) {
        
        [_composeViewController setLinkedInActivityItem:[_linkedInActivityItems objectAtIndex:0]];
    }
    else {
#warning Code to box _linkedInActivityItems items into a single MFLinkedInActivityItem might be needed here... MF, 2014-01-23
    }
    
    
    // Add _composeViewController to navigationVC
    UINavigationController *navigationController = [[UINavigationController alloc]init];
    
    [navigationController setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [navigationController addChildViewController:_composeViewController];
    
    _linkedInActivityViewController = navigationController;
    
    
    
    /* In case a storyboard is needed to present the overlay compose controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MFCompose_iPhone" bundle:nil];
    NSLog(@"storyboard: %@",storyboard);
    UIViewController *coolVC = [storyboard instantiateViewControllerWithIdentifier:@"awesomeVC"];
    _linkedInActivityViewController = coolVC;*/
}

@end
