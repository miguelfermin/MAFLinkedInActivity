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


@interface MFStoryViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) UIPopoverController *sharingActivityViewPopoverController;

// This property is used to set Sharing options on UISegmentedControl - iPad only
@property(weak, nonatomic) IBOutlet UISegmentedControl *sharingOptionsSegmentedControl;

// Share UIBarButtonItem (iPad), use for presenting the popover which contains the activity view.
@property(weak, nonatomic) IBOutlet UIBarButtonItem *shareBarButtonItem;


// Share UIBarButtonItem event handler: iPad
-(IBAction)shareStoryBarButtonItem:(id)sender;

// Share UIBarButtonItem event handlers: iPhone.
-(IBAction)storyOneShareTextBarButtonItem:(id)sender;
-(IBAction)storyTwoShareTextBarButtonItem:(id)sender;
-(IBAction)storyOneShareImageBarButtonItem:(id)sender;
-(IBAction)storyTwoShareImageBarButtonItem:(id)sender;
-(IBAction)storyOneShareLinkBarButtonItem:(id)sender;
-(IBAction)storyTwoShareLinkBarButtonItem:(id)sender;

// Helper methods to centralize static content sharing
-(void)presentActivityViewToShareStoryText:(NSString*)storyText;
-(void)presentActivityViewToShareStoryImage:(UIImage*)storyImage;
-(void)presentActivityViewToShareStoryURL:(NSURL*)storyURL;
-(void)presentPopoverWithActivityViewToShareStoryText;
-(void)presentPopoverWithActivityViewToShareStoryImage;
-(void)presentPopoverWithActivityViewToShareStoryURL;

@end


@implementation MFStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
    
    
    
#pragma mark Load static content
    _storyOneText = @"The new vision of electronics retailing was on display last week at a spacious new Verizon Wireless store in a mall in Puyallup, Wash., outside Seattle. An employee used an app on a smartphone to pilot a toy drone. Music thumped from an array of wireless speakers. And another employee coached a couple perched on stools about using their smartphones. Brian Garduno, a customer reclining in a red leather chair, likened the old Verizon store in the same mall to “being in a train car.”";
    _storyTwoText = @"The business has long been regarded as one of the crown jewels in A.I.G.’s empire. But since its taxpayer-financed bailout in 2008, A.I.G. has sought to sell off nonessential operations to raise money. I.L.F.C., as the aircraft lessor is known, was long considered an attractive asset to sell, given both its size – it owned 913 planes as of Sept. 30 – and the capital requirements needed to support the business. ";
    
    _storyOneImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tech Companies Press" ofType:@"png"]];
    _storyTwoImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AGI Sells Aircraft" ofType:@"png"]];
    
    _storyOneURL = [NSURL URLWithString:@"http://www.nytimes.com/2013/12/16/technology/tech-companies-press-for-a-better-retail-experience.html?ref=technology"];
    _storyTwoURL = [NSURL URLWithString:@"http://dealbook.nytimes.com/2013/12/15/a-i-g-said-near-deal-to-sell-aircraft-leasing-unit/?ref=business&_r=0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Share UIBarButtonItem event handler: iPad

-(IBAction)shareStoryBarButtonItem:(id)sender {
    
    // Present appropriate UIActivityView depending on the "sharingOptionsSegmentedControl" options
    
    switch ([_sharingOptionsSegmentedControl selectedSegmentIndex]) {
        
        case 0:
            [self presentPopoverWithActivityViewToShareStoryText];
            break;
        case 1:
            [self presentPopoverWithActivityViewToShareStoryImage];
            break;
        case 2:
            [self presentPopoverWithActivityViewToShareStoryURL];
            break;
            
        default:
            break;
    }
}



#pragma mark - Share UIBarButtonItem event handlers: iPhone

-(IBAction)storyOneShareTextBarButtonItem:(id)sender {
    
    [self presentActivityViewToShareStoryText:_storyOneText];
}

-(IBAction)storyTwoShareTextBarButtonItem:(id)sender {
    
    [self presentActivityViewToShareStoryText:_storyTwoText];
}

-(IBAction)storyOneShareImageBarButtonItem:(id)sender {
    
    [self presentActivityViewToShareStoryImage:_storyOneImage];
}

-(IBAction)storyTwoShareImageBarButtonItem:(id)sender {
    
    [self presentActivityViewToShareStoryImage:_storyTwoImage];
}

-(IBAction)storyOneShareLinkBarButtonItem:(id)sender {
    
    [self presentActivityViewToShareStoryURL:_storyOneURL];
}

-(IBAction)storyTwoShareLinkBarButtonItem:(id)sender {
    
    [self presentActivityViewToShareStoryURL:_storyTwoURL];
}



#pragma mark - Helper methods to centralize static content sharing

// iPhone
-(void)presentActivityViewToShareStoryText:(NSString*)storyText {
    
    // NOTE: UIActivityTypePostToFacebook and UIActivityTypePostToTwitter are being shown for presentation purposes only, once the custom UIActivityView is ready, these will be removed. MF, 2012.12.18
    
    // Initialize a UIActivityViewController with a comment.
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:@[storyText] applicationActivities:@[]];
    
    // Set the Activity types we don't want to present.
    [activityViewController setExcludedActivityTypes:@[UIActivityTypeMail,
                                                       UIActivityTypeMessage,
                                                       UIActivityTypeCopyToPasteboard,
                                                       UIActivityTypeAirDrop,
                                                       UIActivityTypePrint,
                                                       UIActivityTypeAssignToContact,
                                                       UIActivityTypeSaveToCameraRoll,
                                                       UIActivityTypeAddToReadingList]];
    
    // The completion handler to execute after the activity view controller is dismissed.
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) { // Pending implementation, MF, 2013.12.18
        NSLog(@"activityType: %@, completed: %d", activityType, completed);
    }];
    
    // Present activityViewController in a modal view
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)presentActivityViewToShareStoryImage:(UIImage*)storyImage {
    
    // Initialize a UIActivityViewController with an image.
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:@[storyImage] applicationActivities:@[]];
    
    // Set the Activity types we don't want to present.
    [activityViewController setExcludedActivityTypes:@[UIActivityTypeMail,
                                                       UIActivityTypeMessage,
                                                       UIActivityTypeCopyToPasteboard,
                                                       UIActivityTypeAirDrop,
                                                       UIActivityTypePrint,
                                                       UIActivityTypeAssignToContact,
                                                       UIActivityTypeSaveToCameraRoll,
                                                       UIActivityTypeAddToReadingList]];
    
    // The completion handler to execute after the activity view controller is dismissed.
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) { // Pending implementation, MF, 2013.12.18
        NSLog(@"activityType: %@, completed: %d", activityType, completed);
    }];
    
    // Present activityViewController in a modal view
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)presentActivityViewToShareStoryURL:(NSURL*)storyURL {
    
    // Initialize a UIActivityViewController with an URL.
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:@[storyURL] applicationActivities:@[]];
    
    // Set the Activity types we don't want to present.
    [activityViewController setExcludedActivityTypes:@[UIActivityTypeMail,
                                                       UIActivityTypeMessage,
                                                       UIActivityTypeCopyToPasteboard,
                                                       UIActivityTypeAirDrop,
                                                       UIActivityTypePrint,
                                                       UIActivityTypeAssignToContact,
                                                       UIActivityTypeSaveToCameraRoll,
                                                       UIActivityTypeAddToReadingList]];
    
    // The completion handler to execute after the activity view controller is dismissed.
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) { // Pending implementation, MF, 2013.12.18
        NSLog(@"activityType: %@, completed: %d", activityType, completed);
    }];
    
    // Present activityViewController in a modal view
    [self presentViewController:activityViewController animated:YES completion:nil];
}

// iPad
-(void)presentPopoverWithActivityViewToShareStoryText {
    
    // Initialize a UIActivityViewController with a comment.
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:@[_storyTextView.text] applicationActivities:@[]];
    
    // Set the Activity types we don't want to present.
    [activityViewController setExcludedActivityTypes:@[UIActivityTypeMail,
                                                       UIActivityTypeMessage,
                                                       UIActivityTypeCopyToPasteboard,
                                                       UIActivityTypeAirDrop,
                                                       UIActivityTypePrint,
                                                       UIActivityTypeAssignToContact,
                                                       UIActivityTypeSaveToCameraRoll,
                                                       UIActivityTypeAddToReadingList]];
    
    _sharingActivityViewPopoverController = [[UIPopoverController alloc]initWithContentViewController:activityViewController];
    
    _sharingActivityViewPopoverController.delegate = self;
    
    [_sharingActivityViewPopoverController presentPopoverFromBarButtonItem:_shareBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
    // The completion handler to execute after the activity view controller is dismissed.
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) { // Pending implementation, MF, 2013.12.18
        NSLog(@"activityType: %@, completed: %d", activityType, completed);
    }];
    
    
    // Disable to prevent multiple popovers
    [_shareBarButtonItem setEnabled:NO];
}

-(void)presentPopoverWithActivityViewToShareStoryImage {
    
    // Initialize a UIActivityViewController with a comment.
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:@[_storyImageView.image] applicationActivities:@[]];
    
    // Set the Activity types we don't want to present.
    [activityViewController setExcludedActivityTypes:@[UIActivityTypeMail,
                                                       UIActivityTypeMessage,
                                                       UIActivityTypeCopyToPasteboard,
                                                       UIActivityTypeAirDrop,
                                                       UIActivityTypePrint,
                                                       UIActivityTypeAssignToContact,
                                                       UIActivityTypeSaveToCameraRoll,
                                                       UIActivityTypeAddToReadingList]];
    
    _sharingActivityViewPopoverController = [[UIPopoverController alloc]initWithContentViewController:activityViewController];
    
    _sharingActivityViewPopoverController.delegate = self;
    
    [_sharingActivityViewPopoverController presentPopoverFromBarButtonItem:_shareBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
    // The completion handler to execute after the activity view controller is dismissed.
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) { // Pending implementation, MF, 2013.12.18
        NSLog(@"activityType: %@, completed: %d", activityType, completed);
    }];
    
    
    // Disable to prevent multiple popovers
    [_shareBarButtonItem setEnabled:NO];
}

-(void)presentPopoverWithActivityViewToShareStoryURL {
    
    if (!_storyURL) {
        _storyURL = [NSURL URLWithString:@"http://www.nytimes.com/2013/12/16/technology/tech-companies-press-for-a-better-retail-experience.html?ref=technology"];
    }
    
    // Initialize a UIActivityViewController with a comment.
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:@[_storyURL] applicationActivities:@[]];
    
    // Set the Activity types we don't want to present.
    [activityViewController setExcludedActivityTypes:@[UIActivityTypeMail,
                                                       UIActivityTypeMessage,
                                                       UIActivityTypeCopyToPasteboard,
                                                       UIActivityTypeAirDrop,
                                                       UIActivityTypePrint,
                                                       UIActivityTypeAssignToContact,
                                                       UIActivityTypeSaveToCameraRoll,
                                                       UIActivityTypeAddToReadingList]];
    
    _sharingActivityViewPopoverController = [[UIPopoverController alloc]initWithContentViewController:activityViewController];
    
    _sharingActivityViewPopoverController.delegate = self;
    
    [_sharingActivityViewPopoverController presentPopoverFromBarButtonItem:_shareBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
    // The completion handler to execute after the activity view controller is dismissed.
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) { // Pending implementation, MF, 2013.12.18
        NSLog(@"activityType: %@, completed: %d", activityType, completed);
    }];
    
    
    // Disable to prevent multiple popovers
    [_shareBarButtonItem setEnabled:NO];
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
