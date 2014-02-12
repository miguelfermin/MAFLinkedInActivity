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
        
         /*
          The two cases (commented) below are for when there's no content to share, only a link. Still experimantal
          
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
    
    // Store a reference to the data items in the activityItems parameter so it can be retrieved later.
    
    _linkedInActivityItems = activityItems;
}

-(UIViewController *)activityViewController {
    
    // Setup  _composePresentationViewController and assign it to the _linkedInActivityViewController.
    
    UIViewController *mfViewController;
    
    
    // Load storyboard
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MFCompose_iPhone" bundle:nil];
        
        mfViewController = [storyboard instantiateViewControllerWithIdentifier:@"MFLinkedInComposePresentationViewController"];
    }
    else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MFCompose_iPad" bundle:nil];
        
        mfViewController = [storyboard instantiateViewControllerWithIdentifier:@"MFLinkedInComposePresentationViewController"];
    }
    
    
    // Setup activityViewController
    
    MFLinkedInComposePresentationViewController *composePresentationViewController = (MFLinkedInComposePresentationViewController*)mfViewController;
    
    [composePresentationViewController setLinkedInUIActivity:self];
    
    
    // Safety check to ensure a MFLinkedInActivityItem object was passed. This should never be the case, but for future updates it might be needed.
    if ([[_linkedInActivityItems objectAtIndex:0] isKindOfClass:[MFLinkedInActivityItem class]]) {
        
        [composePresentationViewController setLinkedInActivityItem:[_linkedInActivityItems objectAtIndex:0]];
    }/*else {
        // Code to box _linkedInActivityItems items into a single MFLinkedInActivityItem might be needed here... MF, 2014-01-23
    }*/
    
    
    // Setup Custom Transition and Animation Delegate
    
    MFTransitioningDelegate *transitionDelegate = [[MFTransitioningDelegate alloc]init];
    
    [composePresentationViewController setTransitioningDelegate:transitionDelegate];
    
    
    /* Since UIActivityViewController is the one presenting the activityViewController, the custom iPad presentation
       is not set correctly, thus, don't assign the UIModalPresentationCustom and the full modal presentation works fine. */
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        [composePresentationViewController setModalPresentationStyle:UIModalPresentationCustom];
    }
    
    return composePresentationViewController;
}

@end