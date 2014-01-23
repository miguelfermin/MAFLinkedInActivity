//
//  MFLinkedInComposeViewController.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/14/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFLinkedInComposeViewController.h"

@interface MFLinkedInComposeViewController ()

// Private properties
@property (nonatomic,strong) UIViewController *composeViewController;
@property (nonatomic,strong) UITableViewController *composeTableViewController;

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
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelActivity)];
    UIBarButtonItem *postBarButtonItem =   [[UIBarButtonItem alloc]init];
    postBarButtonItem.title = @"Post";
    postBarButtonItem.target = self;
    postBarButtonItem.action = @selector(postStory);
    
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    self.navigationItem.rightBarButtonItem = postBarButtonItem;
    self.title = @"LinkedIn";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
        {
            if ([_linkedInActivityItem submittedImageURL] != nil) {
                
                NSLog(@"submittedImageURL is valid, post image");
                
                cell = [[MFStoryImageCell alloc]initWithImageURL:[_linkedInActivityItem submittedImageURL]];
            }
            else {
                
                NSLog(@"submittedImageURL is NOT valid, post link");
                
                cell = [[MFStoryLinkCell alloc]initWithURL:[_linkedInActivityItem submittedURL]];
            }
        }
            break;
        case 1:
        {
            cell = [[MFTargetAudienceCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        }
            break;
        default:
            break;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat result = 0.0;
    
    switch (indexPath.section) {
        case 0:
            result = 160.0; // Compose
            break;
        case 1:
            result = 44.0; // Target Audience
            break;
            
        default:
            break;
    }
    return result;
}



#pragma mark - LinkedIn Share

-(void)postStory {
    
    // Initialize networking API
    NSURLSessionConfiguration *SessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *delegateFreeSession =  [NSURLSession sessionWithConfiguration:SessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    // Prepare LinkedIn Share API
    NSString *accessToken = [[_linkedInUIActivity linkedInAccount]accessToken];
    
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
                                  
#warning There are cases when the access_token becomes invalid, the data object should be checked and access_token renew if needed..
                                  NSLog(@"data: %@\n ",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                              }
      ]resume];
    
    // Dismiss MFLinkedInComposeViewController
    [_linkedInUIActivity activityDidFinish:YES];
}

-(NSData*)postData {
    
    // NOTE: Still need to handle cases when objects are nil, MF, 2014-01-22
    
    UITableViewCell *composeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSData *data = nil;
    
#warning Setting the target audience needs implementation, MF, 2014-01-23
    //UITableViewCell *targetCell  = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]; // Pending; implement after MFShareVisibilityViewController is created. MF, 2014-01-21
    NSString *code = @"connections-only"; //  anyone  or  connections-only
    
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
    }
    
    return data;
}



#pragma mark - Helper Methods

///  This method dismisses the sharing interface, whether it is the LinkedIn authentication interface or the Composing interface.
///  This method calls activityDidFinish: method and sends NO to it's complete parameter to indicate that the service wasn't completed successfully.
-(void)cancelActivity; {
    
    //NSLog(@"cancelActivity");
    [_linkedInUIActivity activityDidFinish:NO];
}

@end
