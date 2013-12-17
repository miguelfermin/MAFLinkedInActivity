//
//  MFDetailViewController.m
//  MAFLinkedInActivity
//
//  Created by Miguel Fermin on 12/11/13.
//  Copyright (c) 2013 Miguel Fermin. All rights reserved.
//
//  Description: This class presents the static content (stories) to be used to test 'MFLinkedInSharingLibrary' static library.
//               This class is responsable to handle views transition; presents and dismiss the UIActivityView, etc.

#import "MFStoryViewController.h"

@interface MFStoryViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

// Handle sharing options. iPad only
@property(weak, nonatomic) IBOutlet UISegmentedControl *sharingOptionsSegmentedControl;
-(IBAction)sharingOptions:(id)sender;

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



#pragma mark - Handle Sharing Options Segmented Control Events

-(IBAction)sharingOptions:(id)sender {
    
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
