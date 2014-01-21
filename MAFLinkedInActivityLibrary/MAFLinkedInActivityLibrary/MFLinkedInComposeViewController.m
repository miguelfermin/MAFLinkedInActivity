//
//  MFLinkedInComposeViewController.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/14/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFLinkedInComposeViewController.h"

#define VISIBILITY_ANYONE           @"anyone"
#define VISIBILITY_CONNECTIONS_ONLY @"connections-only"


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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
        {
            if ([[_linkedInUIActivity.linkedInActivityItems objectAtIndex:0] isKindOfClass:[NSString class]]) { // Sharing Story (comment) and URL
                
                NSString *storyString = [_linkedInUIActivity.linkedInActivityItems objectAtIndex:0];
                
                cell = [[MFStoryCell alloc]initWithStoryText:storyString];
            }
            
            if ([[_linkedInUIActivity.linkedInActivityItems objectAtIndex:0] isKindOfClass:[UIImage class]]) { // Sharing Story's Image-URL, URL, and Comment
                
                UIImage *storyImage = [_linkedInUIActivity.linkedInActivityItems objectAtIndex:0];
                
                cell = [[MFStoryImageCell alloc]initWithImage:storyImage];
                
            }
            
            if ([[_linkedInUIActivity.linkedInActivityItems objectAtIndex:0] isKindOfClass:[NSURL class]]) { // Sharing Story's URL, and Comment
                
                NSURL *storyURL = [_linkedInUIActivity.linkedInActivityItems objectAtIndex:0];
                
                cell = [[MFStoryLinkCell alloc]initWithURL:storyURL];
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
    
    
    // NOTE: Most of the implementation of this method is pending. After learning about the required LinkedIn Share API requirements, the Demo app
    //       needs to be updated to pass the required items to the custom UIActivity. Also the table view cell datasource method needs to be updated.
    //       below are some dummy values to demostrate that the post functionality works. MF, 2014-01-21.
    
    UITableViewCell *composeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //UITableViewCell *targetCell  = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]; // Pending; implement after MFShareVisibilityViewController is created. MF, 2014-01-21
    
    NSData *data = nil;
    
    NSString *code = @"connections-only"; //  anyone  or  connections-only
    
    // Post Story REST
    
    if ([composeCell isKindOfClass:[MFStoryCell class]]) {
        
        NSString *comment = [[(MFStoryCell*)composeCell storyTextView]text];
        
        NSString *url = @"http://www.nytimes.com/2013/12/16/technology/tech-companies-press-for-a-better-retail-experience.html?ref=technology";
        
        NSString *json = [NSString stringWithFormat:@"{\"comment\":\"%@\",\"content\":{\"submitted-url\":\"%@\"},\"visibility\":{\"code\":\"%@\"} }",comment,url,code];
        
        data = [json dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    // Post Image REST
    
    if ([composeCell isKindOfClass:[MFStoryImageCell class]]) {
        
        NSString *comment = [[(MFStoryImageCell*)composeCell commentTextView]text];
        
        NSString *url = @"http://www.nytimes.com/2013/12/16/technology/tech-companies-press-for-a-better-retail-experience.html?ref=technology";
        
        NSString *imageURL = @"https://raw.github.com/miguelfermin/MAFLinkedInActivity/share_story/MAFLinkedInActivityLibrary/MAFLinkedInActivityLibraryResources/AGI%20Sells%20Aircraft.png";
        
        NSString *json = [NSString stringWithFormat:@"{\"comment\":\"%@\",\"content\":{\"submitted-image-url\":\"%@\", \"submitted-url\":\"%@\"},\"visibility\":{\"code\":\"%@\"} }",comment,imageURL,url,code];
        
        data = [json dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    // Post Link REST
    
    if ([composeCell isKindOfClass:[MFStoryLinkCell class]]) {
        
        NSString *comment = [[(MFStoryLinkCell*)composeCell commentTextView]text];
        
        NSString *url = @"http://www.nytimes.com/2013/12/16/technology/tech-companies-press-for-a-better-retail-experience.html?ref=technology";
        
        NSString *json = [NSString stringWithFormat:@"{\"comment\":\"%@\",\"content\":{\"submitted-url\":\"%@\"},\"visibility\":{\"code\":\"%@\"} }",comment,url,code];
        
        data = [json dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    return data;
}


@end
