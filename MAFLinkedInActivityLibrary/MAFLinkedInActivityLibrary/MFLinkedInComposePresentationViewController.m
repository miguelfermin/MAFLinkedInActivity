//
//  ComposeOverLayViewController.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/24/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFLinkedInComposePresentationViewController.h"

#define IS_IPHONE5 (([[ UIScreen mainScreen ] bounds ].size.height == 568) ? YES : NO)

@interface MFLinkedInComposePresentationViewController ()

@property (nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *trailingConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;
// iPhone only, use for setting 3.5 vs 4.0 screen size constraint
@property (nonatomic) IBOutlet NSLayoutConstraint *bottomConstraintTwo;

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
    /*NSLog(@"_topConstraint: %f",_topConstraint.constant);
     NSLog(@"_trailingConstraint: %f",_trailingConstraint.constant);
     NSLog(@"_bottomConstraint: %f",_bottomConstraint.constant);
     NSLog(@"_leadingConstraint: %f\n ",_leadingConstraint.constant);*/
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        switch (self.interfaceOrientation) {
                
            case UIInterfaceOrientationPortraitUpsideDown:
            case UIInterfaceOrientationPortrait:
                //NSLog(@"Orientation Portrait\n ");
                
                _topConstraint.constant = 15.0;
                
                _trailingConstraint.constant = 10.0;
                
                _bottomConstraint.constant = 263.0;
                
                _leadingConstraint.constant = 10.0;
                
                if (IS_IPHONE5) {
                    _bottomConstraintTwo.constant = 263.0; // Bottom constraint for 4.0 inch iPhone
                }
                else {
                    _bottomConstraintTwo.constant = 175.0; // Bottom constraint for 3.5 inch iPhone
                }
                break;
                
            case UIInterfaceOrientationLandscapeRight:
            case UIInterfaceOrientationLandscapeLeft:
                //NSLog(@"Orientation Landscape\n ");
                
                _topConstraint.constant = 10.0;
                
                _trailingConstraint.constant = 20.0;
                
                _bottomConstraint.constant = 30.0;
                
                _leadingConstraint.constant = 20.0;
                
                _bottomConstraintTwo.constant = 30.0;
                
                break;
                
            default:
                break;
        }
    }
    else { // Device iPad
        
        switch (self.interfaceOrientation) {
                
            case UIInterfaceOrientationPortraitUpsideDown:
            case UIInterfaceOrientationPortrait:
                //NSLog(@"Orientation Portrait\n ");
                
                _topConstraint.constant = 283.0;
                
                _trailingConstraint.constant = 190.0;
                
                _bottomConstraint.constant = 451.0;
                
                _leadingConstraint.constant = 190.0;
                break;
                
            case UIInterfaceOrientationLandscapeRight:
            case UIInterfaceOrientationLandscapeLeft:
                //NSLog(@"Orientation Landscape\n ");
                
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
    
    // Dismiss Compose View
    
    [_linkedInUIActivity activityDidFinish:YES];
}

@end
