//
//  MFLinkedInVisivilityViewController.h
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/24/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFLinkedInComposeViewController.h"

@class MFLinkedInComposeViewController;

@interface MFLinkedInVisivilityViewController : UITableViewController

///  Parent View Controller; used for setting the LinkedIn Visibility code, which can be "anyone" or "connections only"
@property (nonatomic,strong) MFLinkedInComposeViewController *composeViewController;

///  Update table view with checkmark accessory type depending on the composeViewController's visibilityCode property.
-(void)updateInterface;


@end