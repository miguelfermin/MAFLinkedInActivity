//
//  LinkedInUIActivity.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 12/19/13.
//  Copyright (c) 2013 Miguel Fermin. All rights reserved.


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
        
        // Access token exists, but the expiration date needs to be checked. If access token is expired, ask _linkedInAccount to refresh it.
        
        switch ([_linkedInAccount tokenStatus]) {
                
            case MFAccessTokenStatusGood:
                
                NSLog(@"MFAccessTokenStatusGood\n ");
                
                [self prepareLinkedInActivityViewControllerToCompose];
                
                break;
                
            case MFAccessTokenStatusAboutToExpire:
                
                //NSLog(@"MFAccessTokenStatusAboutToExpire\n ");
                
                [self refreshAccessToken];
                
                break;
                
            case MFAccessTokenStatusExpired:
                
                //NSLog(@"MFAccessTokenStatusExpired\n ");
                
                [self prepareLinkedInActivityViewControllerToAuthenticate];
                
                break;
                
            default:
                break;
        }
    }
    else {
        //NSLog(@"NULL TOKEN: %@, Authentication View Should Be Presented",[_linkedInAccount accessToken]);
        
        // Access token doesn't exist, so the user needs to be authenticated.
        
        [self prepareLinkedInActivityViewControllerToAuthenticate];
    }
}

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
    
    // Setup  _composePresentationViewController and assign it to the _linkedInActivityViewController.
    
    UIViewController *mfViewController;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MFCompose_iPhone" bundle:nil];
        //NSLog(@"iPhone storyboard: %@",storyboard);
        
        mfViewController = [storyboard instantiateViewControllerWithIdentifier:@"MFLinkedInComposePresentationViewController"];
    }
    else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MFCompose_iPad" bundle:nil];
        //NSLog(@"iPad storyboard: %@",storyboard);
        
        mfViewController = [storyboard instantiateViewControllerWithIdentifier:@"MFLinkedInComposePresentationViewController"];
    }
    
    _composePresentationViewController = (MFLinkedInComposePresentationViewController*)mfViewController;
    
   [_composePresentationViewController setLinkedInUIActivity:self];
    
    
    if ([[_linkedInActivityItems objectAtIndex:0] isKindOfClass:[MFLinkedInActivityItem class]]) {
        
        [_composePresentationViewController setLinkedInActivityItem:[_linkedInActivityItems objectAtIndex:0]];
    }
    else {
#warning Code to box _linkedInActivityItems items into a single MFLinkedInActivityItem might be needed here... MF, 2014-01-23
    }
    
    
    // Setup Custom Transition and Animation Delegate
    
    MFTransitioningDelegate *transitionDelegate = [[MFTransitioningDelegate alloc]init];
    
    [_composePresentationViewController setTransitioningDelegate:transitionDelegate];
    
#warning There's an issue with iPad custom presentation
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        [_composePresentationViewController setModalPresentationStyle:UIModalPresentationCustom];
    }
    
    // Assign custom compose controller
    
    _linkedInActivityViewController = _composePresentationViewController;
}



#pragma mark - Handle Expired Access tokens

-(void)refreshAccessToken {
    
    // Delegate refresh operation to MFLinkedInAccount
    
    [_linkedInAccount refreshToken];
    
    
    
    //NSLog(@"After refreshAccessToken...\n ");
    
    // Call prepareLinkedInActivityViewControllerToCompose to start the post
    
    //[self prepareLinkedInActivityViewControllerToCompose];
    
}





@end