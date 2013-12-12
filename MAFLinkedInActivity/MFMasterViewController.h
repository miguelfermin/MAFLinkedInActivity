//
//  MFMasterViewController.h
//  MAFLinkedInActivity
//
//  Created by Miguel Fermin on 12/11/13.
//  Copyright (c) 2013 Miguel Fermin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MFTextViewController;

@interface MFMasterViewController : UITableViewController

@property (strong, nonatomic) MFTextViewController *detailViewController;

@end
