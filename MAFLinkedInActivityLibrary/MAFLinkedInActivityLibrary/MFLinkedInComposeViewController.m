//
//  MFLinkedInComposeViewController.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/14/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFLinkedInComposeViewController.h"
#import "MFLinkedInAuthenticationViewController.h"

@interface MFLinkedInComposeViewController ()

// IB Connections
@property(nonatomic,weak) IBOutlet UIImageView *contentImageView;
@property(nonatomic,weak) IBOutlet UILabel *contentVisibilityLabel;
-(IBAction)postBarButtonItem;
-(IBAction)cancelBarButtonItem;

// Convenient reference to linkedIn acccount object
@property (nonatomic,strong) MFLinkedInAccount *linkedInAccount;

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
    
    _linkedInAccount = _composePresentationViewController.linkedInUIActivity.linkedInAccount;
    
    [self setupComposeViewController];
    
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
                
                NSLog(@"MFAccessTokenStatusAboutToExpire\n ");
                
                // Note: until I figure out how to refresh the access_token, go through the authentication process
                
                //[self refreshAccessToken];
                
                [self setupAuthenticationViewController];
                
                break;
                
            case MFAccessTokenStatusExpired:
                
                NSLog(@"MFAccessTokenStatusExpired\n ");
                
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



#pragma mark - Initial setup

-(void)setupComposeViewController {
    
    // If submittedImageURL property is nil, the client only provide a link to the story, based on this load UIImageView with correct content.
    
    if ([_linkedInActivityItem submittedImageURL] != nil) {
        
        //NSLog(@"submittedImageURL is valid, post image");
        
#warning Need to set a placeholder image on _contentImageView until the UIImage is downloaded in the background
        
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
        
        //NSLog(@"submittedImageURL is NOT valid, post link");
        
        [_contentImageView setImage:[UIImage imageNamed:@"linkedIn-negative"]]; // temp image for testing...
    }
    
    // Set anyone  as default visibility code when the compose view is presented.
    
    _visibilityCode = @"anyone";
    
    [_contentVisibilityLabel setText:@"Anyone"];
}

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

-(void)refreshAccessToken {
    
    // Delegate refresh operation to MFLinkedInAccount
    
    [_linkedInAccount refreshToken];
}



#pragma mark - LinkedIn Share

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
                                  
                                  NSLog(@"data: %@\n ",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                                  
#warning There are cases when the access_token becomes invalid, the data object should be checked and access_token renew if needed..
                                  // NOTE: This needs better checking code, perhaps checking the data HTML content, but for now use the error varible value
                                  
                                  if (!error) {
                                      
                                      // Assuming there's no error and the post was successful.
                                      
                                      [self performOperationsAfterPostSucceeded];
                                  }
                                  else {
                                      // Handle case when post fails
                                      
                                      [self performOperationsAfterPostFailed];
                                  }
                              }
      ]resume];
}

-(NSData*)postData {
    
    NSData *data = nil;
    
    if ([_linkedInActivityItem submittedImageURL] != nil) {
        
        // Post Image REST
        
        // Gather API call fields
        
        NSString *comment = [_contentCommentTextView text];
        
        NSString *title = [_linkedInActivityItem contentTitle];
        
        NSString *description = [_linkedInActivityItem contentDescription];
        
        
        // Convert NSURL to NSString for json string
        
        NSString *submittedURL = [NSString stringWithFormat:@"%@",[_linkedInActivityItem submittedURL]];
        
        NSString *submittedImageURL = [NSString stringWithFormat:@"%@",[_linkedInActivityItem submittedImageURL]];
        
        
        // Compose API call
        
        NSString *json = [NSString stringWithFormat:@"{\"comment\":\"%@\",\"content\":{\"title\":\"%@\",\"description\":\"%@\",\"submitted-url\":\"%@\",\"submitted-image-url\":\"%@\"},\"visibility\":{\"code\":\"%@\"} }",comment,title,description,submittedURL,submittedImageURL,_visibilityCode];
        
        data = [json dataUsingEncoding:NSUTF8StringEncoding];
    }
    else {
        // Post Link REST
        
        // Gather API call fields
        
        NSString *comment = [_contentCommentTextView text];
        
        NSString *title = [_linkedInActivityItem contentTitle];
        
        NSString *description = [_linkedInActivityItem contentDescription];
        
        
        // Convert NSURL to NSString for json string
        
        NSString *submittedURL = [NSString stringWithFormat:@"%@",[_linkedInActivityItem submittedURL]];
        
        
        // Compose API call
        
        NSString *json = [NSString stringWithFormat:@"{\"comment\":\"%@\",\"content\":{\"title\":\"%@\",\"description\":\"%@\",\"submitted-url\":\"%@\"},\"visibility\":{\"code\":\"%@\"} }",comment,title,description,submittedURL,_visibilityCode];
        
        data = [json dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    return data;
}



#pragma mark - Helper Methods

-(IBAction)postBarButtonItem {
    
    [self postStory];
}

-(IBAction)cancelBarButtonItem {
    
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // Scroll to top cell after rotation, in order to always show the text view.
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}



#pragma mark - After POST request Callbacks

-(void)performOperationsAfterPostSucceeded {
    
    // Delegate the dismiss after succeeded operation to parent view controller.
    
    [_composePresentationViewController donePosting];
}

-(void)performOperationsAfterPostFailed {
#warning Pending implementation; performOperationsAfterPostFailed
    // 1. Re-attempt to post
    
    // 2. If re-atttemp fails, present 'post fail, please try again' message.
}



#pragma mark - Segue Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier]isEqualToString:@"Visibility View Controller Segue"]) {
        
        _visivilityViewController = [segue destinationViewController];
        
        [_visivilityViewController setComposeViewController:self];
        
        [_visivilityViewController updateInterface];
    }
}


@end
