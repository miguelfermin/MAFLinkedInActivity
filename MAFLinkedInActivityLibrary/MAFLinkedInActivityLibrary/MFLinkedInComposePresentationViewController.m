//
//  ComposeOverLayViewController.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/24/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFLinkedInComposePresentationViewController.h"

#define IS_IPHONE_5 (([[ UIScreen mainScreen ] bounds ].size.height == 568) ? YES : NO)

@interface MFLinkedInComposePresentationViewController ()

@property (nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *trailingConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;


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



#pragma mark - Whenever the device orientation changes, update constraints constants to position view correctly

-(void)viewWillLayoutSubviews {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        switch (self.interfaceOrientation) {
                
            case UIInterfaceOrientationPortraitUpsideDown:
            case UIInterfaceOrientationPortrait:
                
                _topConstraint.constant = 15.0;
                
                _trailingConstraint.constant = 10.0;
                
                _leadingConstraint.constant = 10.0;
                
                if (IS_IPHONE_5) {
                    _bottomConstraint.constant = 263.0; // Bottom constraint for 4.0 inch iPhone
                }
                else {
                    _bottomConstraint.constant = 222.0; // Bottom constraint for 3.5 inch iPhone
                }
                break;
                
                
            case UIInterfaceOrientationLandscapeRight:
            case UIInterfaceOrientationLandscapeLeft:
                
                _topConstraint.constant = 5.0;
                
                _trailingConstraint.constant = 20.0;
                
                _bottomConstraint.constant = 133.0;
                
                _leadingConstraint.constant = 20.0;
                
                break;
            default:
                break;
        }
    }
    else { // Device iPad
        
        switch (self.interfaceOrientation) {
                
            case UIInterfaceOrientationPortraitUpsideDown:
            case UIInterfaceOrientationPortrait:
                
                _topConstraint.constant = 283.0;
                
                _trailingConstraint.constant = 190.0;
                
                _bottomConstraint.constant = 451.0;
                
                _leadingConstraint.constant = 190.0;
                break;
                
            case UIInterfaceOrientationLandscapeRight:
            case UIInterfaceOrientationLandscapeLeft:
                
                _topConstraint.constant = 51.0;
                
                _trailingConstraint.constant = 318.0;
                
                _bottomConstraint.constant = 427.0;
                
                _leadingConstraint.constant = 318.0;
                break;
            default:
                break;
        }
    }
}



#pragma mark - Embed Segue Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier]isEqualToString:@"MFLinkedInComposeViewController Segue"]) {
        
        // Make view corners rounded and change the bar color of the navigation controller
        
        UINavigationController *nc = [segue destinationViewController];
        nc.view.layer.cornerRadius = 7;
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
    
    // Dismiss Compose View
    
    [_linkedInUIActivity activityDidFinish:YES];
}

@end
