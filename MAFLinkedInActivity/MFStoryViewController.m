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

// This property is used to set Sharing options on UISegmentedControl - iPad only
@property(weak, nonatomic) IBOutlet UISegmentedControl *sharingOptionsSegmentedControl;

// Share UIBarButtonItem event handler: iPad
-(IBAction)shareStoryBarButtonItem:(id)sender;

// Share UIBarButtonItem event handlers: iPhone
-(IBAction)shareTextBarButtonItem:(id)sender;
-(IBAction)shareImageBarButtonItem:(id)sender;
-(IBAction)shareLinkBarButtonItem:(id)sender;

@end


@implementation MFStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Share UIBarButtonItem event handler: iPad

-(IBAction)shareStoryBarButtonItem:(id)sender {
    
    // Present appropriate UIActivityView depending on the "sharingOptionsSegmentedControl" options
    
    // NOTE: implementation pending, UIActivityView must be presented on a popover
    
    switch ([_sharingOptionsSegmentedControl selectedSegmentIndex]) {
        case 0:
            NSLog(@"Text Sharing Option");
            break;
        case 1:
            NSLog(@"Image Sharing Option");
            break;
        case 2:
            NSLog(@"Link Sharing Option");
            break;
            
        default:
            break;
    }
}



#pragma mark - Share UIBarButtonItem event handlers: iPhone

-(IBAction)shareTextBarButtonItem:(id)sender {
    
    // Initialize a UIActivityViewController with a comment. Set the Activity types we don't want to present
    UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:@[@"Comments go here"] applicationActivities:@[]];
    
    [avc setExcludedActivityTypes:@[UIActivityTypePostToTwitter,
                                    UIActivityTypeMail,
                                    UIActivityTypeMessage,
                                    UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAirDrop,
                                    UIActivityTypePrint,
                                    UIActivityTypeAssignToContact,
                                    UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList]];
    
    // Present activityViewController modally
    [self presentViewController:avc animated:YES completion:nil];
}


-(IBAction)shareImageBarButtonItem:(id)sender {
    
    // Image to share
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tech Companies Press" ofType:@"png"]];
    
    // Initialize a UIActivityViewController with an image. Set the Activity types we don't want to present
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:@[img] applicationActivities:@[]];
    
    [activityViewController setExcludedActivityTypes:@[UIActivityTypePostToTwitter,
                                    UIActivityTypeMail,
                                    UIActivityTypeMessage,
                                    UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAirDrop,
                                    UIActivityTypePrint,
                                    UIActivityTypeAssignToContact,
                                    UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList]];
    
    // Present activityViewController modally
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(IBAction)shareLinkBarButtonItem:(id)sender {
    
    // Link to share
    NSURL *url = [NSURL URLWithString:@"http://google.com"];
    
    // Initialize a UIActivityViewController with an URL. Set the Activity types we don't want to present
    UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:@[url] applicationActivities:@[]];
    
    [avc setExcludedActivityTypes:@[UIActivityTypePostToTwitter,
                                    UIActivityTypeMail,
                                    UIActivityTypeMessage,
                                    UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAirDrop,
                                    UIActivityTypePrint,
                                    UIActivityTypeAssignToContact,
                                    UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList]];
    
    [self presentViewController:avc animated:YES completion:nil];
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
