//
//  MFLinkedInComposeViewController.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/14/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFLinkedInComposeViewController.h"

// MACRO constants per Library Specifications
#define TITLE_INDEX               0
#define DESCRIPTION_INDEX         1
#define SUBMITTED_URL_INDEX       2
#define SUBMITTED_IMAGE_URL_INDEX 3


@interface MFLinkedInComposeViewController ()

// Private properties
@property (nonatomic,strong) UIViewController *composeViewController;
@property (nonatomic,strong) UITableViewController *composeTableViewController;

// Map LinkedIn Share API fields
@property (nonatomic,strong) NSString *storyTitle;          // Title of shared document
@property (nonatomic,strong) NSString *storyDescription;    // Description of shared content
@property (nonatomic,strong) NSURL *submittedURL;      // URL for shared content
@property (nonatomic,strong) NSURL *submittedImageURL; // URL for image of shared content

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
    
    /* 
    // Testing NSArray //
    NSString *title = @"TITLE";
    NSString *description = @"DESCRIPTION";
    NSString *URL = @"URL";
    NSString *imageURL = @"IMAGE-URL";
    // Array order must be: 0-title, 1-description, 2-URL, 3-imageURL
    NSNull *null = [NSNull null];
    NSArray *array = @[title, description, URL, imageURL];
    NSLog(@"[array objectAtIndex:0]: %@",[array objectAtIndex:0]);
    NSLog(@"[array objectAtIndex:1]: %@",[array objectAtIndex:1]);
    NSLog(@"[array objectAtIndex:2]: %@",[array objectAtIndex:2]);
    NSLog(@"[array objectAtIndex:3]: %@\n\n ",[array objectAtIndex:3]);
    if ([[array objectAtIndex:IMAGE_INDEX] class] != [null class]) { // image-URL is ok!
        NSLog(@"image-URL is ok!. Present MFStoryImageCell");
        if ([[array objectAtIndex:URL_INDEX] class] == [null class]) {
            NSLog(@"image-URL is ok!. But URL is bad!. If this is the case, just use the image-URL in place of the URL");
        }
    }
    else if ([[array objectAtIndex:URL_INDEX] class] != [null class]) { // URL is ok!
        NSLog(@"image-URL is bad! and URL is ok!. Present MFStoryLinkCell");
    }
    else { // URL and image-URL are bad!
        NSLog(@"URL and image-URL are bad!. Present MFStoryCell run-1");
    }
    // Testing NSArray*/
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
            
        case 0:
        {
            NSArray *activityItems = _linkedInUIActivity.linkedInActivityItems;
            NSNull  *nullItem = [NSNull null];
            
            if ([[activityItems objectAtIndex:SUBMITTED_IMAGE_URL_INDEX] class] != [nullItem class]) { // image-URL is ok!
                NSLog(@"image-URL is ok!. Present MFStoryImageCell");
                
                // initialize appropriate cell
                
                cell = [[MFStoryImageCell alloc]initWithImageURL:[activityItems objectAtIndex:SUBMITTED_IMAGE_URL_INDEX]];
                
                // Get share API values from activityItems
                
                _storyTitle =        [activityItems objectAtIndex:TITLE_INDEX];
                _storyDescription =  [activityItems objectAtIndex:DESCRIPTION_INDEX];
                _submittedURL =      [activityItems objectAtIndex:SUBMITTED_URL_INDEX];
                _submittedImageURL = [activityItems objectAtIndex:SUBMITTED_IMAGE_URL_INDEX];
                
                
                // if the required "_submittedURL" is not provided, _submittedImageURLwill be used.
                
                if ([[activityItems objectAtIndex:SUBMITTED_URL_INDEX] class] == [nullItem class]) {
                    NSLog(@"image-URL is ok!. But URL is bad!. If this is the case, just use the image-URL in place of the URL");
                    
                    _submittedURL = [activityItems objectAtIndex:SUBMITTED_IMAGE_URL_INDEX];
                }
            }
            
            else if ([[activityItems objectAtIndex:SUBMITTED_URL_INDEX] class] != [nullItem class]) { // URL is ok!
                NSLog(@"image-URL is bad! and URL is ok!. Present MFStoryLinkCell");
                
                // initialize appropriate cell
                
                cell = [[MFStoryLinkCell alloc]initWithURL:[activityItems objectAtIndex:SUBMITTED_URL_INDEX]];
                
                // Get share API values from activityItems
                
                _storyTitle =             [activityItems objectAtIndex:TITLE_INDEX];
                _storyDescription =       [activityItems objectAtIndex:DESCRIPTION_INDEX];
                _submittedURL =      [activityItems objectAtIndex:SUBMITTED_URL_INDEX];
            }
            
            else { // URL and image-URL are bad!
                NSLog(@"URL and image-URL are bad!. Present MFStoryCell run-1");
                
                // initialize appropriate cell
                
                cell = [[MFStoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                // Get share API values from activityItems
                
                _storyTitle =             [activityItems objectAtIndex:TITLE_INDEX];
                _storyDescription =       [activityItems objectAtIndex:DESCRIPTION_INDEX];
                
                // if the required "_submittedURL" is not provided, http://www.linkedin.com will be used.
                
                _submittedURL = [NSURL URLWithString:@"http://www.linkedin.com"];
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



///  This method dismisses the sharing interface, whether it is the LinkedIn authentication interface or the Composing interface.
///  This method calls activityDidFinish: method and sends NO to it's complete parameter to indicate that the service wasn't completed successfully.
-(void)cancelActivity; {
    
    //NSLog(@"cancelActivity");
    [_linkedInUIActivity activityDidFinish:NO];
}



#pragma mark - LinkedIn POST

-(void)postStory {
    NSLog(@"postStory\n\n ");
    
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
                                  
                                  NSLog(@"data: %@\n ",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                              }
      ]resume];
    
    // Dismiss MFLinkedInComposeViewController
    [_linkedInUIActivity activityDidFinish:YES];
}


///  Determine the activity item type, prepare a JSON object for corresponding item, convert to NSData object, and return it.
///
///  @return NSData object with the correct JSON object for the activity item.
-(NSData*)postData {
    
    // NOTE: Still need to handle cases when objects are nil, MF, 2014-01-22
    
    UITableViewCell *composeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSData *data = nil;
    
    // This still needs implementation, MF, 2014-01-22
    //UITableViewCell *targetCell  = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]; // Pending; implement after MFShareVisibilityViewController is created. MF, 2014-01-21
    NSString *code = @"connections-only"; //  anyone  or  connections-only
    
    
    
    // Post Story REST
    
    if ([composeCell isKindOfClass:[MFStoryCell class]]) {
        
        NSString *comment = [[(MFStoryCell*)composeCell commentTextView]text];
        
        NSString *url = @"http://www.linkedin.com"; // place holder URL
        
        NSString *json = [NSString stringWithFormat:@"{\"comment\":\"%@\",\"content\":{\"title\":\"%@\",\"description\":\"%@\", \"submitted-url\":\"%@\"},\"visibility\":{\"code\":\"%@\"} }",comment,_storyTitle, _storyDescription,url,code];
        
        data = [json dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    
    // Post Image REST
    
    if ([composeCell isKindOfClass:[MFStoryImageCell class]]) {
        
        // Get comment from textView
        NSString *comment = [[(MFStoryImageCell*)composeCell commentTextView]text];
        
        // Convert NSURL to NSString for json string
        NSString *submittedURL = [NSString stringWithFormat:@"%@",_submittedURL];
        
        NSString *submittedImageURL = [NSString stringWithFormat:@"%@",_submittedImageURL];
        
        // Compose API call
        NSString *json = [NSString stringWithFormat:@"{\"comment\":\"%@\",\"content\":{\"title\":\"%@\",\"description\":\"%@\", \"submitted-url\":\"%@\",\"submitted-image-url\":\"%@\"},\"visibility\":{\"code\":\"%@\"} }",comment,_storyTitle,_storyDescription,submittedURL,submittedImageURL,code];
        
        data = [json dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    
    // Post Link REST
    
    if ([composeCell isKindOfClass:[MFStoryLinkCell class]]) {
        
        NSString *comment = [[(MFStoryLinkCell*)composeCell commentTextView]text];
        
        // Convert NSURL to NSString for json string
        NSString *submittedURL = [NSString stringWithFormat:@"%@",_submittedURL];
        
        // Compose API call
        NSString *json = [NSString stringWithFormat:@"{\"comment\":\"%@\",\"content\":{\"title\":\"%@\",\"description\":\"%@\", \"submitted-url\":\"%@\"},\"visibility\":{\"code\":\"%@\"} }",comment,_storyTitle,_storyDescription,submittedURL,code];
        
        data = [json dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    return data;
}


@end
