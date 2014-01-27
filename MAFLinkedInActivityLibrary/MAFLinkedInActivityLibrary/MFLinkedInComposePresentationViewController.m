//
//  ComposeOverLayViewController.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/24/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFLinkedInComposePresentationViewController.h"

@interface MFLinkedInComposePresentationViewController ()

@end

@implementation MFLinkedInComposePresentationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    
    // Set overlay transparent color
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
}




#pragma mark - Embed Segue Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier]isEqualToString:@"MFLinkedInComposeViewController Segue"]) {
        
        // Make view corners rounded and change the bar color of the navigation controller
        
        UINavigationController *nc = [segue destinationViewController];
        nc.view.layer.cornerRadius = 10;
        nc.view.layer.masksToBounds = YES;
        [nc.navigationBar setBarTintColor:[UIColor colorWithRed:239.0f/255.0 green:239.0f/255.0  blue:244.0f/255.0  alpha:1.0]];
        
        
        // Setup Compose View Controller
        
        _composeViewController = (MFLinkedInComposeViewController*)[[segue destinationViewController]topViewController];
        
        [_composeViewController setComposePresentationViewController:self];
        
        [_composeViewController setLinkedInActivityItem:_linkedInActivityItem];
    }
}



#pragma mark - Helper Methods

-(void)cancelActivity; {
    
    //NSLog(@"cancelActivity\n ");
    
    [_linkedInUIActivity activityDidFinish:NO];
}

-(void)donePosting {
    
    //NSLog(@"donePosting\n ");
    
    // Dismiss Compose View
    
    [_linkedInUIActivity activityDidFinish:YES];
    
    
    // Present Success message
#warning Present Success message operation pending
    
}

@end
