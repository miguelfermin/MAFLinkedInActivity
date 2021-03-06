//
//  MFMasterViewController.m
//  MAFLinkedInActivity
//
//  Created by Miguel Fermin on 12/11/13.
//  Copyright (c) 2013 Miguel Fermin. All rights reserved.
//
//  Description: This class provides a list of static content (stories) to be used to test 'MAFLinkedInSharingLibrary' static library.
//               The static content on this class is for the iPad only, since the the static content for the iPhone is in the storyboard.

#import "MFStoriesViewController.h"
#import "MFStoryViewController.h"


@interface MFStoriesViewController ()

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
    
    // initialize MFStoryViewController
    self.storyViewController = (MFStoryViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Handle user interaction, only if iPad. iPhone gets all interaction from it's storyboard segues

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        switch (indexPath.row) {
                
            case 0: // User taps first story
                
                _storyViewController.storyTitleLabel.text = @"Tech Companies Press";
                
                _storyViewController.storyTextView.text = _storyViewController.storyOneDescription;
                
                _storyViewController.storyImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tech Companies Press" ofType:@"png"]];
                
                _storyViewController.story = @"STORY ONE";
                
                break;
                
            case 1: // User taps second story
                
                _storyViewController.storyTitleLabel.text = @"AGI Sells Aircraft";
                
                _storyViewController.storyTextView.text = _storyViewController.storyTwoDescription;
                
                _storyViewController.storyImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AGI Sells Aircraft" ofType:@"png"]];
                
                _storyViewController.story = @"STORY TWO";
                
                break;
                
            default:
                break;
        }
    }
}

@end
