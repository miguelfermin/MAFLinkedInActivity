//
//  MFMasterViewController.h
//  MAFLinkedInActivity
//
//  Created by Miguel Fermin on 12/11/13.
//  Copyright (c) 2013 Miguel Fermin. All rights reserved.
//
//  Description: This class provides a list of static content (stories) to be used to test 'MFLinkedInSharingLibrary' static library.
//               The static content on this class is for the iPad only, since the the static content for the iPhone is in the storyboard.

#import <UIKit/UIKit.h>

@class MFStoryViewController;

@interface MFStoriesViewController : UITableViewController

@property (strong, nonatomic) MFStoryViewController *storyViewController;

@end
