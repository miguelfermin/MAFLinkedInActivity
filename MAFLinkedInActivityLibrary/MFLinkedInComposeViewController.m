//
//  MFLinkedInComposeViewController.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/14/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFLinkedInComposeViewController.h"
#import "MFLinkedInAuthenticationViewController.h"
#import "MAFLinkedInActivity.h"

#define IS_IPHONE_5 (([[ UIScreen mainScreen ] bounds ].size.height == 568) ? YES : NO)

/*
 * LinkedIn Common Errors: If there's an error with your API call, LinkedIn will return a HTTP status code along with a message detailing the error
 *
 * Code   Description                         Solution
 * ----   -----------                         ---------
 * 400    Bad Request                         The request was invalid, which is usually caused by a programming error. Ensure that the request is formatted correctly
 *
 * 401    This token has expired. Renew it    Your application needs to take the user through the authorization flow again since their access token has expired
 *
 * 401    Invalid access token                Ensure that a valid access token is being used in your API call
 *
 * 403    Throttle limit is reached.          You've reached the throttle limit for a particular resource.
 *
 * 404    Page not found                      The endpoint or resource your application is trying to reach doesn't exist
 *
 * 500    Internal Service Error              There was an application error on the LinkedIn server. Usually your request is valid but needs to be made at a later time
 *
 *
 * NOTE: This version of the library only handles the 401 error, by requesting a new access token.
 *       Other errors that make sense to be handle are 403 (Throttle limit) and 500 (Internal Service Error).
 */
#define INVALID_OR_EXPIRED_TOKEN_STATUS_CODE    401
#define RESPONSE_SUCCESS_STATUS_CODE            201 // For future implementation
#define THROTTLE_LIMIT_STATUS_CODE              403
#define INTERNAL_SERVICE_ERROR_STATUS_CODE      500

@interface MFLinkedInComposeViewController ()

// IB Connections
@property(nonatomic,weak) IBOutlet UIImageView *contentImageView;
@property(nonatomic,weak) IBOutlet UILabel *contentVisibilityLabel;
-(IBAction)post;
-(IBAction)cancel;

// Convenient reference to linkedIn acccount object
@property (nonatomic,strong) MFLinkedInAccount *linkedInAccount;

// To update constraints dynamically depending on iPhone screen size
@property (nonatomic) IBOutlet NSLayoutConstraint *imageTopVerticalSpaceConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *imageBottomVerticalSpaceConstraint;

@end

@implementation MFLinkedInComposeViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // init MFLinkedInAccount object to be used in multiple places
    
    _linkedInAccount = _composePresentationViewController.linkedInUIActivity.linkedInAccount;
    
    
    // Show compose view regardless of access token status, if we need to authenticate, the authentication view will be presented modally on top of the compose view
    
    [self setupComposeViewController];
    
    
    // Change text insets, check for device since image size on iPad is larger.
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        [_contentCommentTextView setTextContainerInset:UIEdgeInsetsMake(6.0, 0.0, 0.0, 86.0)];
    }
    else {
        [_contentCommentTextView setTextContainerInset:UIEdgeInsetsMake(6.0, 0.0, 0.0, 100.0)];
    }
    
    
    // Added transucent effect similar to the built-in service
    
    self.view.alpha = 0.96f;
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
    // Can't present a another view until the viewDidLoad method has finished executing, so the access_token check is performed here.
    // And the AuthenticationViewController presented if needed.
    
    // First check if access_token exist, and then it's expiration status
    
    if ([_linkedInAccount accessToken]) {
        
        switch ([_linkedInAccount tokenStatus]) {
                
            case MFAccessTokenStatusGood:
                
                if (![_contentCommentTextView isFirstResponder]) {
                    [_contentCommentTextView becomeFirstResponder];
                }
                break;
                
            case MFAccessTokenStatusAboutToExpire:
                
                MFLog(@"MFLinkedInComposeViewController-viewDidAppear:. MFAccessTokenStatusAboutToExpire\n ");
                
                // Note: until I figure out how to refresh the access_token, go through the authentication process
                
                //[self refreshAccessToken];
                
                [self setupAuthenticationViewController];
                
                break;
                
            case MFAccessTokenStatusExpired:
                
                MFLog(@"MFLinkedInComposeViewController-viewDidAppear:. MFAccessTokenStatusExpired\n ");
                
                [self setupAuthenticationViewController];
                
                break;
                
            default:
                break;
        }
    }
    else {
        // Access token doesn't exist, so the user needs to be authenticated.
        [self setupAuthenticationViewController];
    }
}


#pragma mark - Whenever the device orientation changes, update constraints constants to position view correctly

-(void)viewWillLayoutSubviews {
    
    // UIImage bottom vertical constraint need to be adjusted based  on iPhone screen size.
    
    // iPad UIImage doesn't need update, so the _imageVerticalSpaceConstraint IBOutlet doesn't exist for iPad.
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if (IS_IPHONE_5) {
            
            switch (self.interfaceOrientation) {
                    
                case UIInterfaceOrientationPortraitUpsideDown: // Vertical spacing is more when portrait
                case UIInterfaceOrientationPortrait:
                    
                    _imageTopVerticalSpaceConstraint.constant = 16.0;
                    _imageBottomVerticalSpaceConstraint.constant = 91.0;
                    break;
                    
                case UIInterfaceOrientationLandscapeRight:
                case UIInterfaceOrientationLandscapeLeft:
                    
                    _imageTopVerticalSpaceConstraint.constant = 5.0; // Vertical spacing is less when portrait
                    _imageBottomVerticalSpaceConstraint.constant = 4.0;
                    break;
                default:
                    break;
            }
        }
        else {
            switch (self.interfaceOrientation) {
                    
                case UIInterfaceOrientationPortraitUpsideDown:
                case UIInterfaceOrientationPortrait:
                    
                    _imageTopVerticalSpaceConstraint.constant = 16.0;
                    _imageBottomVerticalSpaceConstraint.constant = 42.0;
                    break;
                    
                case UIInterfaceOrientationLandscapeRight:
                case UIInterfaceOrientationLandscapeLeft:
                    
                    _imageTopVerticalSpaceConstraint.constant = 5.0;
                    _imageBottomVerticalSpaceConstraint.constant = 4.0;
                    break;
                default:
                    break;
            }
        }
    }
}


#pragma mark - Table View Delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Make sure the entire cell content view has the same color, when set in IB the disclosure indicator area stayed white on iPad.
    
    [cell setBackgroundColor:[UIColor colorWithRed:239.0f/255.0f green:239.0/255.0 blue:244.0/255.0 alpha:1]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Flash cell when selected for better visual
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Change table view cells height dynamically depending on device and screen size (in the case of iPhone)
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if (indexPath.section == 0) {
            
            if (IS_IPHONE_5) {
                
                switch (self.interfaceOrientation) {
                        
                    case UIInterfaceOrientationPortraitUpsideDown:
                    case UIInterfaceOrientationPortrait:
                        
                        return 178.0; // Cell height for 4.0 inch iPhone
                        break;
                    case UIInterfaceOrientationLandscapeRight:
                    case UIInterfaceOrientationLandscapeLeft:
                        
                        return 80.0;
                        break;
                    default:
                        break;
                }
            }
            else {
                switch (self.interfaceOrientation) {
                    case UIInterfaceOrientationPortraitUpsideDown:
                    case UIInterfaceOrientationPortrait:
                        
                        return 129.0; // Cell height for 3.5 inch iPhone
                        break;
                        
                    case UIInterfaceOrientationLandscapeRight:
                    case UIInterfaceOrientationLandscapeLeft:
                        return 80.0;
                        break;
                    default:
                        break;
                }
            }
        }
        else { // Audience cell height is the same for both screen sizes
            return 50.0f;
        }
    }
    else { // iPad. Nothing changes dynamically with iPad but since we're implementing this method we must provide values.
        if (indexPath.section == 0) {
            return 176.0;
        }
        else {
            return 50.0;
        }
    }
}


#pragma mark - Initial setup

///  Prepares the Compose view. Checks the _linkedInActivityItem ivar to determine if it should post an URL alone or an image with an URL.
///  If the post contains an image, it downloads the image in a background queue and updates the UI when done, in the mean time it sets a placeholder image.
-(void)setupComposeViewController {
    
    // If submittedImageURL property is nil, the client only provide a link to the story, based on this load UIImageView with correct content.
    
    if ([_linkedInActivityItem submittedImageURL] != nil) {
        
        // submittedImageURL is valid, post image
        
        // Placeholder image
        
        [_contentImageView setImage:[UIImage imageNamed:@"MAFLinkedInActivityResources.bundle/Post-placeholder.png"]];
        
        dispatch_queue_t imageDownloadQueue = dispatch_queue_create("imageDownloadQueue", DISPATCH_QUEUE_SERIAL);
        
        dispatch_async(imageDownloadQueue,^{
            
            // Download the image
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:_linkedInActivityItem.submittedImageURL]];
            
            
            // When done update UI on main
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_contentImageView setImage:image];
            });
        });
    }
    else {
        
        // submittedImageURL is NOT valid, post link
        
        [_contentImageView setImage:[UIImage imageNamed:@"MAFLinkedInActivityResources.bundle/Post-placeholder.png"]];
    }
    
    // Set anyone  as default visibility code when the compose view is presented.
    
    _visibilityCode = @"anyone";
    
    [_contentVisibilityLabel setText:@"Anyone"];
}

///  Prepare and present the MFLinkedInAuthenticationViewController. There are two cases when this method gets called,
///  1. if the access token was determined to be expired in the viewDidAppear: method, and
///  2. If during a POST the response header contains a status code 401. If the access token is determined to be invalid during a Post, it's less likely that it expired, since the viewDidAppear: would've caught it.
-(void)setupAuthenticationViewController {
    
    // To avoid keyboard scrolling on the Webview
    
    [_contentCommentTextView resignFirstResponder];
    
    
    // Setup and present Authentication ViewController
    
    MFLinkedInAuthenticationViewController *authenticationViewController = [[MFLinkedInAuthenticationViewController alloc]init];
    
    [authenticationViewController setLinkedInAccount:_linkedInAccount];
    
    [authenticationViewController setLinkedInUIActivity:_composePresentationViewController.linkedInUIActivity];
    
    [authenticationViewController prepareAuthenticationView];
    
    [authenticationViewController setComposeViewController:self];
    
    [self presentViewController:authenticationViewController animated:YES completion:nil];
}


#pragma mark - Handle Expired Access tokens

///  Delegates the task of refreshing the access token a MFLinkedInAccount object; to the _linkedInAccount property.
-(void)refreshAccessToken {
    
    [_linkedInAccount refreshToken];
}


#pragma mark - LinkedIn Share

///  Post story to LinkedIn.
-(void)postStory {
    
    // Initialize networking API
    NSURLSessionConfiguration *SessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *delegateFreeSession =  [NSURLSession sessionWithConfiguration:SessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    // Prepare LinkedIn Share API
    NSString *accessToken = [[_composePresentationViewController.linkedInUIActivity linkedInAccount]accessToken];
    
    NSString *requestBody = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/shares?oauth2_access_token=%@",accessToken];
    
    NSURL *url = [NSURL URLWithString:requestBody];
    
    NSData *data = [self postData];
    
    // Make the POST request
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc]init];
    
    [mutableRequest setURL:url];
    
    [mutableRequest setHTTPMethod:@"POST"];
    
    [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [[delegateFreeSession uploadTaskWithRequest:mutableRequest
                                       fromData:data
                              completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                  
                                  MFLog(@"MFLinkedInComposeViewController-postStory. Data: %@\n ",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                                  MFLog(@"MFLinkedInComposeViewController-postStory. Response statusCode: %li",(long)[(NSHTTPURLResponse*)response statusCode]);
                                  
                                  // Check response status code to handle invalid or expired token.
                                  
                                  if ([(NSHTTPURLResponse*)response statusCode] == INVALID_OR_EXPIRED_TOKEN_STATUS_CODE) {
                                      
                                      [self performOperationsAfterPostFailedWithInvalidOrExpiredTokenError];
                                  }
                                  else {
                                      
                                      [self performOperationsAfterPostSucceeded];
                                  }
                                  
                                  // Check response status code to handle invalid or expired token, throttle limit, and LinkedIn Internal Service Error. Note: This implementation is pending. MF, 2014.02.11
                                  /*
                                  switch ([(NSHTTPURLResponse*)response statusCode]) {
                                          
                                      case RESPONSE_SUCCESS_STATUS_CODE:

                                          [self performOperationsAfterPostSucceeded];
                                          
                                          break;
                                          
                                      case INVALID_OR_EXPIRED_TOKEN_STATUS_CODE:
                                          
                                          [self performOperationsAfterPostFailedWithInvalidOrExpiredTokenError];
                                          
                                          break;
                                          
                                      case THROTTLE_LIMIT_STATUS_CODE:
                                          
                                          //[self performOperationsAfterPostFailedWithUserReachedThrottleLimitError]; // to be implemented
                                          
                                          break;
                                          
                                      case INTERNAL_SERVICE_ERROR_STATUS_CODE:
                                          
                                          //[self performOperationsAfterPostFailedWithLinkedInInternalServiceError]; // to be implemented
                                          
                                          break;
                                          
                                      default:
                                          [self performOperationsAfterPostFailedWithInvalidOrExpiredTokenError]; // worst case scenario, to be implemented
                                          break;
                                  }*/
                              }
      ]resume];
}

///  Prepare the LinkedIn Share API Post data and returns it.
///
///  @return A NSData object with the LinkedIn Share JSON data.
-(NSData*)postData {
    
    NSData *data = nil;
    
    if ([_linkedInActivityItem submittedImageURL] != nil) {
        
        // Post Image REST
        
        // Gather API call fields
        
        NSString *comment = [_contentCommentTextView text];
        
        NSString *title = [_linkedInActivityItem contentTitle];
        
        NSString *description = [_linkedInActivityItem contentDescription];
        
        NSString *submittedURLString = [[_linkedInActivityItem submittedURL]absoluteString];
        
        NSString *submittedImageURLString = [[_linkedInActivityItem submittedImageURL]absoluteString];
        
        
        // Compose API call
        
        NSDictionary *jsonDict = @{@"comment":comment,
                                   
                                   @"content":@{@"title": title, @"description":description, @"submitted-url":submittedURLString, @"submitted-image-url":submittedImageURLString},
                                   
                                   @"visibility":@{@"code": _visibilityCode}};
        
        NSError *error = [[NSError alloc]init];
        
        data = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error];
    }
    else {
        // Post Link REST
        
        // Gather API call fields
        
        NSString *comment = [_contentCommentTextView text];
        
        NSString *title = [_linkedInActivityItem contentTitle];
        
        NSString *description = [_linkedInActivityItem contentDescription];
        
        NSString *submittedURLString = [[_linkedInActivityItem submittedURL]absoluteString];
        
        
        // Compose API call
        
        NSDictionary *jsonDict = @{@"comment":comment,
                                   @"content":@{@"title": title, @"description":description, @"submitted-url":submittedURLString},
                                   @"visibility":@{@"code": _visibilityCode}};
        
        NSError *error = [[NSError alloc]init];
        
        data = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error];
    }
    
    return data;
}


#pragma mark - Helper Methods
///  IB connection to trigger the post.
-(IBAction)post {
    
    [self postStory];
}

///  IB connection to cancel the post
-(IBAction)cancel {
    
    [_composePresentationViewController cancelActivity];
}

-(void)updateVisibilityCodeWithString:(NSString*)code {
    
    _visibilityCode = code;
    
    // Ensure UILabel is in upper case
    
    if ([code isEqualToString:@"anyone"]) {
        
        [_contentVisibilityLabel setText:@"Anyone"];
        
    }
    else {
        [_contentVisibilityLabel setText:@"Connections Only"];
    }
}


#pragma mark - After POST request Callbacks

///  Tells parent view controller that the Post succeded and the compose view needs to be dismissed.
-(void)performOperationsAfterPostSucceeded {
    
    // Delegate the dismiss after succeeded operation to parent view controller.
    
    [_composePresentationViewController donePosting];
}

///  Ask MFLinkedInAccount object (the _linkedInAccount property) to sign the user out of LinkedIn (by deleteing their info from the keychain)
///  and calls the setupAuthenticationViewController method to re-authenticate the user.
-(void)performOperationsAfterPostFailedWithInvalidOrExpiredTokenError {
    
    // Delete user info from keychain before getting new info
    
    [_linkedInAccount signOutUser];
    
    
    // Re-authenticate and get new access token
    
    [self setupAuthenticationViewController];
}


#pragma mark - Segue Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /* Present MFLinkedInVisibilityViewController to change the LinkedIn visibility/code parameter. */
    
    if ([[segue identifier]isEqualToString:@"Visibility View Controller Segue"]) {
        
        _visivilityViewController = [segue destinationViewController];
        
        [_visivilityViewController setComposeViewController:self];
        
        [_visivilityViewController updateInterface];
        
        
        // Dismiss keyboard when presenting Visibility view to match the built-in services
        
        [_contentCommentTextView resignFirstResponder];
    }
}

@end
