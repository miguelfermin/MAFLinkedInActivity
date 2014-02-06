//
//  MFLinkedInComposeViewController.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/14/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFLinkedInComposeViewController.h"

@interface MFLinkedInComposeViewController ()

// IB Connections
@property(nonatomic,weak) IBOutlet UITextView *contentCommentTextView;

@property(nonatomic,weak) IBOutlet UIImageView *contentImageView;

@property(nonatomic,weak) IBOutlet UILabel *contentVisibilityLabel;

-(IBAction)postBarButtonItem;

-(IBAction)cancelBarButtonItem;

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
    
    // If submittedImageURL property is nil, the client only provide a link to the story, based on this load UIImageView with correct content.
    if ([_linkedInActivityItem submittedImageURL] != nil) {
        
        //NSLog(@"submittedImageURL is valid, post image");
        [_contentImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:_linkedInActivityItem.submittedImageURL]]]; // Need to use GCD for performance...
        
    }
    else {
        //NSLog(@"submittedImageURL is NOT valid, post link");
        [_contentImageView setImage:[UIImage imageNamed:@"linkedIn-negative"]]; // temp image for testing...
    }
    
    // Set anyone  as default visibility code when the compose view is presented.
    _visibilityCode = @"anyone";
    [_contentVisibilityLabel setText:@"Anyone"];
    
    // Present Keyboard as soon as the view is shown
    [_contentCommentTextView becomeFirstResponder];
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
    /*
    // Post Image REST
    if ([composeCell isKindOfClass:[MFStoryImageCell class]]) {
        // Gather API call fields
        NSString *comment = [[(MFStoryImageCell*)composeCell commentTextView]text];
        NSString *title = [_linkedInActivityItem contentTitle];
        NSString *description = [_linkedInActivityItem contentDescription];
        // Convert NSURL to NSString for json string
        NSString *submittedURL = [NSString stringWithFormat:@"%@",[_linkedInActivityItem submittedURL]];
        NSString *submittedImageURL = [NSString stringWithFormat:@"%@",[_linkedInActivityItem submittedImageURL]];
        // Compose API call
        NSString *json = [NSString stringWithFormat:@"{\"comment\":\"%@\",\"content\":{\"title\":\"%@\",\"description\":\"%@\",\"submitted-url\":\"%@\",\"submitted-image-url\":\"%@\"},\"visibility\":{\"code\":\"%@\"} }",comment,title,description,submittedURL,submittedImageURL,code];
        data = [json dataUsingEncoding:NSUTF8StringEncoding];
    }
    // Post Link REST
    if ([composeCell isKindOfClass:[MFStoryLinkCell class]]) {
        // Gather API call fields
        NSString *comment = [[(MFStoryImageCell*)composeCell commentTextView]text];
        NSString *title = [_linkedInActivityItem contentTitle];
        NSString *description = [_linkedInActivityItem contentDescription];
        // Convert NSURL to NSString for json string
        NSString *submittedURL = [NSString stringWithFormat:@"%@",[_linkedInActivityItem submittedURL]];
        // Compose API call
        NSString *json = [NSString stringWithFormat:@"{\"comment\":\"%@\",\"content\":{\"title\":\"%@\",\"description\":\"%@\",\"submitted-url\":\"%@\"},\"visibility\":{\"code\":\"%@\"} }",comment,title,description,submittedURL,code];
        data = [json dataUsingEncoding:NSUTF8StringEncoding];
    }*/
    
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
#warning Pending implementation.
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
