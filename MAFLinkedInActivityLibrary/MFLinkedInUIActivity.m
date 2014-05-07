//
//  LinkedInUIActivity.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 12/19/13.
//  Copyright (c) 2013 Miguel Fermin. All rights reserved.

#import "MFLinkedInUIActivity.h"
#import "MAFLinkedInActivity.h"

NSString * const MAFUIActivityTypePostToLinkedIn = @"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn";

@interface MFLinkedInUIActivity ()

@property(nonatomic, strong) MFTransitioningDelegate *transitionDelegate;

@end

@implementation MFLinkedInUIActivity

/* 
 * NOTE: To comply with the security specifications of OAuth 2, as of April 11, 2014, LinkedIn is requiring developers to register their applications redirect URLs.
 *       LinkedIn has to confirm that the \b redirect_uri in your OAuth 2 authorization request matches a URL you've registered with them.
 *       If the redirect URL you registered with LinkedIn doesn't match the redirect_uri you use here, requests to authorize new members or refresh tokens will fail
 *       For more details, go to https://developer.linkedin.com/blog/register-your-oauth-2-redirect-urls
 */
- (id)initWithAPIKey:(NSString *)APIKey secretKey:(NSString *)secretKey redirectURL:(NSURL *)redirectURL
{
    self = [super init];
    
    if (self) {
        
        // Initialize linkedInAccount instance variable and set its LinkedIn sharing parameters.
        
        _linkedInAccount = [[MFLinkedInAccount alloc]initWithAPIKey:APIKey secretKey:secretKey redirectURL:redirectURL];
    }
    return self;
}


#pragma mark - Methods to Override to provide LinkedIn service information.

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryShare;
}

- (NSString *)activityType
{
    return MAFUIActivityTypePostToLinkedIn;
}

- (NSString *)activityTitle
{
    return NSLocalizedString(@"LinkedIn", @"LinkedIn");
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"MAFLinkedInActivityResources.bundle/linkedIn-positive.png"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    __block BOOL hasURL = NO;
    
    [activityItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        // If obj is MFLinkedInActivityItem, it's guarantee there's a URL, since that a requirement of that class
        
        if ([obj isKindOfClass:[MFLinkedInActivityItem class]] == YES) {
            
            MFLog(@"activity is MFLinkedInActivityItem class");
            
            hasURL = YES;
            
            *stop  = YES;
            
            return;
        }
        
          
        // If a URL was passed
        
        if ([obj isKindOfClass:[NSURL class]] == YES) {
            
            MFLog(@"activity is NSURL class");
            
            hasURL = YES;
            
            *stop  = YES;
            
            return;
        }
        
        
        /*
        // If a String formatted as URL was passed
        if ([obj isKindOfClass:[NSString class]] == YES && [NSURL URLWithString:obj] != nil) {
            
            hasURL = YES;
            
            *stop  = YES;
            
            return;
        }*/
    }];
    
    return hasURL;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    // Store a reference to the data items in the activityItems parameter so it can be retrieved later.
    
    _linkedInActivityItems = activityItems;
}

- (UIViewController *)activityViewController
{
    // Setup activityViewController
    
    MFLinkedInComposePresentationViewController *composePresentationViewController = [self composePresentationViewController];
    
    [composePresentationViewController setLinkedInUIActivity:self];
    
    
    // If there's no MFLinkedInActivityItem in _linkedInActivityItems, an URL was passed. If this is the case, create a MFLinkedInActivityItem using that URL.
    
    NSURL * url = nil;
    MFLinkedInActivityItem * activityItem = nil;
    
    MFLog(@"_linkedInActivityItems: %@",_linkedInActivityItems);
    
    for (id item in _linkedInActivityItems) {
        
        if ([item isKindOfClass:[MFLinkedInActivityItem class]]) {
            activityItem = item;
            break;
        }
        if ([item isKindOfClass:[NSURL class]]) {
            url = item;
        }
    }
    
    if (activityItem) {
        // use activityItem
        [composePresentationViewController setLinkedInActivityItem:activityItem];
    }
    else {
        // use url
        activityItem = [[MFLinkedInActivityItem alloc]initWithURL:url];
        
        [activityItem setContentTitle:@""];
        
        [activityItem setContentDescription:@""];
        
        [composePresentationViewController setLinkedInActivityItem:activityItem];
    }
    
    
    // Setup Custom Transition and Animation Delegate
    
    _transitionDelegate = [[MFTransitioningDelegate alloc]init];
    
    [composePresentationViewController setTransitioningDelegate:_transitionDelegate];
    
    
    /* Since UIActivityViewController is the one presenting the activityViewController, the custom iPad presentation
       is not set correctly, thus, don't assign the UIModalPresentationCustom and the full modal presentation works fine. */
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        [composePresentationViewController setModalPresentationStyle:UIModalPresentationCustom];
    }
    
    return composePresentationViewController;
}


#pragma mark - Helper Methods

- (MFLinkedInComposePresentationViewController *)composePresentationViewController
{
    // Get the resource bundle
    
    NSString *resourceBundlePath = [[NSBundle mainBundle] pathForResource:@"MAFLinkedInActivityResources" ofType:@"bundle"];
    
    NSBundle *resourceBundle = [NSBundle bundleWithPath:resourceBundlePath];
    
    // Load view controller from storyboard and return for proper device
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MFCompose_iPhone" bundle:resourceBundle];
        
        return (MFLinkedInComposePresentationViewController*) [storyboard instantiateViewControllerWithIdentifier:@"MFLinkedInComposePresentationViewController"];
    }
    else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MFCompose_iPad" bundle:resourceBundle];
        
        return (MFLinkedInComposePresentationViewController*) [storyboard instantiateViewControllerWithIdentifier:@"MFLinkedInComposePresentationViewController"];
    }
}

@end