//
//  MFLinkedInComposeViewController.h
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/14/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFLinkedInUIActivity.h"
#import "MFStoryCell.h"
#import "MFStoryImageCell.h"
#import "MFStoryLinkCell.h"
#import "MFTargetAudienceCell.h"
#import "MFLinkedInActivityItem.h"

@class MFLinkedInUIActivity;

@interface MFLinkedInComposeViewController : UITableViewController

/// Weak reference to MFLinkedInUIActivity in order to call the activityDidFinish: to dismiss the linkedInActivityViewController.
@property (nonatomic,weak) MFLinkedInUIActivity *linkedInUIActivity;

@property(nonatomic,strong) MFLinkedInActivityItem *linkedInActivityItem;

@end
