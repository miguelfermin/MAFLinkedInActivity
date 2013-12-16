//
//  MFMasterViewController.m
//  MAFLinkedInActivity
//
//  Created by Miguel Fermin on 12/11/13.
//  Copyright (c) 2013 Miguel Fermin. All rights reserved.
//
//  Description: xx...

#import "MFStoriesViewController.h"
#import "MFStoryViewController.h"

@interface MFStoriesViewController ()

// Static content
@property NSString *storyOneText;
@property NSString *storyTwoText;
@property UIImage *storyOneImage;
@property UIImage *storyTwoImage;

@end


@implementation MFStoriesViewController

- (void)awakeFromNib {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // initialize MFStoryViewController
    self.storyViewController = (MFStoryViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    
    // Initialize static resources only if iPad. iPhone gets all it's static data from it's storyboard.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        // Initialize stories text
        _storyOneText = @"The new vision of electronics retailing was on display last week at a spacious new Verizon Wireless store in a mall in Puyallup, Wash., outside Seattle. An employee used an app on a smartphone to pilot a toy drone. Music thumped from an array of wireless speakers. And another employee coached a couple perched on stools about using their smartphones. Brian Garduno, a customer reclining in a red leather chair, likened the old Verizon store in the same mall to “being in a train car.”";
        
        _storyTwoText = @"The business has long been regarded as one of the crown jewels in A.I.G.’s empire. But since its taxpayer-financed bailout in 2008, A.I.G. has sought to sell off nonessential operations to raise money. I.L.F.C., as the aircraft lessor is known, was long considered an attractive asset to sell, given both its size – it owned 913 planes as of Sept. 30 – and the capital requirements needed to support the business. ";
        
        
        // Initialize images
        _storyOneImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tech Companies Press" ofType:@"png"]];
        _storyTwoImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AGI Sells Aircraft" ofType:@"png"]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Handle user interaction, only if iPad. iPhone gets all interaction from it's storyboard
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        switch (indexPath.row) {
                
            case 0: // User taps first story
                
                _storyViewController.storyTitleLabel.text = @"Tech Companies Press";
                
                _storyViewController.storyTextView.text = _storyOneText;
                
                _storyViewController.storyImageView.image = _storyOneImage;
                
                break;
                
            case 1: // User taps first story
                
                _storyViewController.storyTitleLabel.text = @"AGI Sells Aircraft";
                
                _storyViewController.storyTextView.text = _storyTwoText;
                
                _storyViewController.storyImageView.image = _storyTwoImage;
                
                break;
                
            default:
                break;
        }
    }
}


@end
