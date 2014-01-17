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

- (id)initWithStyle:(UITableViewStyle)style
{
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
    
    
    
    
    // Prepare Transition Delegate. Pending...
    /*id<UIViewControllerTransitioningDelegate>transitionDelegate;
     _composeViewController.modalPresentationStyle = UIModalPresentationCustom;
     [_composeViewController setTransitioningDelegate:transitionDelegate];*/
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
            if ([[_linkedInUIActivity.linkedInActivityItems objectAtIndex:0] isKindOfClass:[NSString class]]) {
                
                //NSLog(@"NSString class: %@",[NSString class]);
                
                NSString *storyString = [_linkedInUIActivity.linkedInActivityItems objectAtIndex:0];
                
                cell = [[MFStoryCell alloc]initWithStoryText:storyString];
            }
            
            if ([[_linkedInUIActivity.linkedInActivityItems objectAtIndex:0] isKindOfClass:[UIImage class]]) {
                
                //NSLog(@"UIImage class: %@",[UIImage class]); // MFStoryImageCell
                
                UIImage *storyImage = [_linkedInUIActivity.linkedInActivityItems objectAtIndex:0];
                
                cell = [[MFStoryImageCell alloc]initWithImage:storyImage];
            }
            
            if ([[_linkedInUIActivity.linkedInActivityItems objectAtIndex:0] isKindOfClass:[NSURL class]]) {
                
                NSURL *storyURL = [_linkedInUIActivity.linkedInActivityItems objectAtIndex:0];
                
                cell = [[MFStoryLinkCell alloc]initWithURL:storyURL];
                        
                //NSLog(@"NSURL class: %@",[NSURL class]);
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

-(void)postStory {
    
    NSLog(@"postStory");
    [_linkedInUIActivity activityDidFinish:YES];
}






/* Pending for now. Once I get the modal view working, I'll get back to try to present it like a formsheet on iPhone...
 #pragma mark - UIViewControllerTransitioningDelegate
 
 - (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
 
 NSLog(@"animationControllerForPresentedController:presentingController:sourceController:");
 return nil;
 }
 
 
 - (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
 
 NSLog(@"animationControllerForDismissedController:");
 
 return nil;
 }
 */



@end
