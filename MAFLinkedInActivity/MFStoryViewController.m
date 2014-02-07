//
//  MFDetailViewController.m
//  MAFLinkedInActivity
//
//  Created by Miguel Fermin on 12/11/13.
//  Copyright (c) 2013 Miguel Fermin. All rights reserved.
//
//  Description: This class presents the static content (stories) to be used to test 'MAFLinkedInSharingLibrary' static library.
//               This class is responsable to handle views transition; presents and dismiss the UIActivityView, etc.

#import "MFStoryViewController.h"

// Macros use to determine which story was selected; for iPad only
#define STORY_ONE @"STORY ONE"
#define STORY_TWO @"STORY TWO"

@interface MFStoryViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) UIPopoverController *sharingActivityViewPopoverController;
@property(weak, nonatomic) IBOutlet UISegmentedControl *sharingOptionsSegmentedControl; // This property is used to set Sharing options on UISegmentedControl - iPad only
@property(weak, nonatomic) IBOutlet UIBarButtonItem *shareBarButtonItem; // Share UIBarButtonItem (iPad), use for presenting the popover which contains the activity view.

-(IBAction)shareStoryBarButtonItem:(id)sender; // Share UIBarButtonItem event handler: iPad
-(IBAction)storyOneShareTextBarButtonItem:(id)sender; // Share UIBarButtonItem event handlers: iPhone.
-(IBAction)storyTwoShareTextBarButtonItem:(id)sender;
-(IBAction)storyOneShareImageBarButtonItem:(id)sender;
-(IBAction)storyTwoShareImageBarButtonItem:(id)sender;
-(IBAction)storyOneShareLinkBarButtonItem:(id)sender;
-(IBAction)storyTwoShareLinkBarButtonItem:(id)sender;
@end


@implementation MFStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
    
    // Load static content
    
    _storyOneTitle = @"Tech Companies Press";
    _storyTwoTitle = @"AGI Sells Aircraft";
    
    _storyOneDescription = @"The new vision of electronics retailing was on display last week at a spacious new Verizon Wireless store in a mall in Puyallup, Wash., outside Seattle. An employee used an app on a smartphone to pilot a toy drone. Music thumped from an array of wireless speakers. And another employee coached a couple perched on stools about using their smartphones. Brian Garduno, a customer reclining in a red leather chair, likened the old Verizon store in the same mall to “being in a train car.”";
    _storyTwoDescription = @"The business has long been regarded as one of the crown jewels in A.I.G.’s empire. But since its taxpayer-financed bailout in 2008, A.I.G. has sought to sell off nonessential operations to raise money. I.L.F.C., as the aircraft lessor is known, was long considered an attractive asset to sell, given both its size – it owned 913 planes as of Sept. 30 – and the capital requirements needed to support the business. ";
    
    _storyOneImageURL = [NSURL URLWithString:@"https://raw.github.com/miguelfermin/MAFLinkedInActivity/share_story/MAFLinkedInActivity/MAFLinkedInActivityResources/Tech%20Companies%20Press.png"];
    _storyTwoImageURL = [NSURL URLWithString:@"https://raw.github.com/miguelfermin/MAFLinkedInActivity/share_story/MAFLinkedInActivity/MAFLinkedInActivityResources/AGI%20Sells%20Aircraft.png"];
    
    _storyOneURL = [NSURL URLWithString:@"http://www.nytimes.com/2013/12/16/technology/tech-companies-press-for-a-better-retail-experience.html?ref=technology"];
    _storyTwoURL = [NSURL URLWithString:@"http://dealbook.nytimes.com/2013/12/15/a-i-g-said-near-deal-to-sell-aircraft-leasing-unit/?ref=business&_r=0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Share UIBarButtonItem event handler: iPad

-(IBAction)shareStoryBarButtonItem:(id)sender {
    
    // Present appropriate UIActivityView depending on the "sharingOptionsSegmentedControl" options and _story flag
    
    switch ([_sharingOptionsSegmentedControl selectedSegmentIndex]) {
        case 0:
            if ([_story isEqualToString:STORY_ONE]) {
                [self presentActivityViewToShareStoryWithTitle:_storyOneTitle description:_storyOneDescription];
            }
            else {
                [self presentActivityViewToShareStoryWithTitle:_storyTwoTitle description:_storyTwoDescription];
            }
            break;
        case 1:
            if ([_story isEqualToString:STORY_ONE]) {
                [self presentActivityViewToShareStoryWithTitle:_storyOneTitle description:_storyOneDescription URL:_storyOneURL imageURL:_storyOneImageURL];
            }
            else {
                [self presentActivityViewToShareStoryWithTitle:_storyTwoTitle description:_storyTwoDescription URL:_storyTwoURL imageURL:_storyTwoImageURL];
            }
            break;
        case 2:
            if ([_story isEqualToString:STORY_ONE]) {
                [self presentActivityViewToShareStoryWithTitle:_storyOneTitle description:_storyOneDescription URL:_storyOneURL];
            }
            else {
                [self presentActivityViewToShareStoryWithTitle:_storyTwoTitle description:_storyTwoDescription URL:_storyTwoURL];
            }
            break;
            
        default:
            break;
    }
}



#pragma mark - Share UIBarButtonItem event handlers: iPhone

-(IBAction)storyOneShareTextBarButtonItem:(id)sender {
    
    [self presentActivityViewToShareStoryWithTitle:_storyOneTitle description:_storyOneDescription];
}

-(IBAction)storyTwoShareTextBarButtonItem:(id)sender {
    
    [self presentActivityViewToShareStoryWithTitle:_storyTwoTitle description:_storyTwoDescription];
}

-(IBAction)storyOneShareImageBarButtonItem:(id)sender {
    
    [self presentActivityViewToShareStoryWithTitle:_storyOneTitle description:_storyOneDescription URL:_storyOneURL imageURL:_storyOneImageURL];
}

-(IBAction)storyTwoShareImageBarButtonItem:(id)sender {
    
    [self presentActivityViewToShareStoryWithTitle:_storyTwoTitle description:_storyTwoDescription URL:_storyTwoURL imageURL:_storyTwoImageURL];
}

-(IBAction)storyOneShareLinkBarButtonItem:(id)sender {
    
    [self presentActivityViewToShareStoryWithTitle:_storyOneTitle description:_storyOneDescription URL:_storyOneURL];
}

-(IBAction)storyTwoShareLinkBarButtonItem:(id)sender {
    
    [self presentActivityViewToShareStoryWithTitle:_storyTwoTitle description:_storyTwoDescription URL:_storyTwoURL];
}



#pragma mark - Helper methods to centralize static content sharing

-(void)presentActivityViewToShareStoryWithTitle:(NSString*)title description:(NSString*)description URL:(NSURL*)submittedURL imageURL:(NSURL*)submittedImageURL {
    
    // Properties used to pass to UIActivityViewController
    MFLinkedInUIActivity   *linkedInActivity = [[MFLinkedInUIActivity alloc]init];
    
    MFLinkedInActivityItem *linkedInActivityItem = [[MFLinkedInActivityItem alloc]initWithURL:submittedURL];
    [linkedInActivityItem setContentTitle:title];
    [linkedInActivityItem setContentDescription:description];
    [linkedInActivityItem setSubmittedImageURL:submittedImageURL];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:@[linkedInActivityItem] applicationActivities:@[linkedInActivity]];
    
    // Set the Activity types we don't want to present.
    [activityViewController setExcludedActivityTypes:@[UIActivityTypeMail,
                                                       UIActivityTypeMessage,
                                                       UIActivityTypeCopyToPasteboard,
                                                       UIActivityTypeAirDrop,
                                                       UIActivityTypePrint,
                                                       UIActivityTypeAssignToContact,
                                                       UIActivityTypeSaveToCameraRoll,
                                                       UIActivityTypeAddToReadingList,
                                                       UIActivityTypePostToTwitter,
                                                       UIActivityTypePostToFacebook]];
    
    // The completion handler to execute after the activity view controller is dismissed.
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
        NSLog(@"activityType: %@, completed: %d", activityType, completed);
    }];
    
    
    // Present for correct device
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        _sharingActivityViewPopoverController = [[UIPopoverController alloc]initWithContentViewController:activityViewController];
        
        _sharingActivityViewPopoverController.delegate = self;
        
        [_sharingActivityViewPopoverController presentPopoverFromBarButtonItem:_shareBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        
        // Disable to prevent multiple popovers
        [_shareBarButtonItem setEnabled:NO];
    }
    else {
        // Present activityViewController in a modal view
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
}

-(void)presentActivityViewToShareStoryWithTitle:(NSString*)title description:(NSString*)description URL:(NSURL*)submittedURL {
    
    // Properties used to pass to UIActivityViewController
    MFLinkedInUIActivity   *linkedInActivity = [[MFLinkedInUIActivity alloc]init];
    
    MFLinkedInActivityItem *linkedInActivityItem = [[MFLinkedInActivityItem alloc]initWithURL:submittedURL];
    [linkedInActivityItem setContentTitle:title];
    [linkedInActivityItem setContentDescription:description];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:@[linkedInActivityItem] applicationActivities:@[linkedInActivity]];
    
    // Set the Activity types we don't want to present.
    [activityViewController setExcludedActivityTypes:@[UIActivityTypeMail,
                                                       UIActivityTypeMessage,
                                                       UIActivityTypeCopyToPasteboard,
                                                       UIActivityTypeAirDrop,
                                                       UIActivityTypePrint,
                                                       UIActivityTypeAssignToContact,
                                                       UIActivityTypeSaveToCameraRoll,
                                                       UIActivityTypeAddToReadingList,
                                                       UIActivityTypePostToTwitter,
                                                       UIActivityTypePostToFacebook]];
    
    // The completion handler to execute after the activity view controller is dismissed.
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) { // Pending implementation, MF, 2013.12.18
        //NSLog(@"activityType: %@, completed: %d", activityType, completed);
    }];
    
    
    // Present for correct device
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        _sharingActivityViewPopoverController = [[UIPopoverController alloc]initWithContentViewController:activityViewController];
        
        _sharingActivityViewPopoverController.delegate = self;
        
        [_sharingActivityViewPopoverController presentPopoverFromBarButtonItem:_shareBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        
        // Disable to prevent multiple popovers
        [_shareBarButtonItem setEnabled:NO];
    }
    else {
        // Present activityViewController in a modal view
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
    
}

-(void)presentActivityViewToShareStoryWithTitle:(NSString*)title description:(NSString*)description {
    
    // Properties used to pass to UIActivityViewController
    MFLinkedInUIActivity   *linkedInActivity = [[MFLinkedInUIActivity alloc]init];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:@[title,description] applicationActivities:@[linkedInActivity]];
    
    // Set the Activity types we don't want to present.
    [activityViewController setExcludedActivityTypes:@[UIActivityTypeMail,
                                                       UIActivityTypeMessage,
                                                       UIActivityTypeCopyToPasteboard,
                                                       UIActivityTypeAirDrop,
                                                       UIActivityTypePrint,
                                                       UIActivityTypeAssignToContact,
                                                       UIActivityTypeSaveToCameraRoll,
                                                       UIActivityTypeAddToReadingList,
                                                       UIActivityTypePostToTwitter,
                                                       UIActivityTypePostToFacebook]];
    
    // The completion handler to execute after the activity view controller is dismissed.
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) { // Pending implementation, MF, 2013.12.18
        //NSLog(@"activityType: %@, completed: %d", activityType, completed);
    }];
    
    // Present for correct device
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        _sharingActivityViewPopoverController = [[UIPopoverController alloc]initWithContentViewController:activityViewController];
        _sharingActivityViewPopoverController.delegate = self;
        [_sharingActivityViewPopoverController presentPopoverFromBarButtonItem:_shareBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [_shareBarButtonItem setEnabled:NO];
    }
    else {
        // Present activityViewController in a modal view
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
}



#pragma mark - UIPopoverController Delegate Methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    
    // Re-enable _shareBarButtonItem after dismissing popover.
    [_shareBarButtonItem setEnabled:YES];
}



#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {
    
    barButtonItem.title = NSLocalizedString(@"Stories", @"Stories");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}
- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
