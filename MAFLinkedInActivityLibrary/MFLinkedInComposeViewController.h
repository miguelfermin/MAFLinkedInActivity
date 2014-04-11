//
//  MFLinkedInComposeViewController.h
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/14/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MFLinkedInComposePresentationViewController.h"
#import "MFLinkedInVisivilityViewController.h"
#import "MFLinkedInActivityItem.h"

@class MFLinkedInComposePresentationViewController, MFLinkedInVisivilityViewController;

///  Design to present the compose overlay view which has a container view controller (MFLinkedInComposeViewController).
@interface MFLinkedInComposeViewController : UITableViewController

///  Parent ViewController; responsable for the overlay presentation
@property (nonatomic,weak) MFLinkedInComposePresentationViewController *composePresentationViewController;

///  Child View Controller; responsable for setting the LinkedIn Visibility code, which can be "anyone" or "connections only"
@property(nonatomic,strong) MFLinkedInVisivilityViewController *visivilityViewController;

///  MFLinkedInActivityItem has the share content encapsulated.
@property(nonatomic,strong) MFLinkedInActivityItem *linkedInActivityItem;

///  LinkedIn share API field value, could be one of anyone: all members or connections-only: connections only.
@property(nonatomic,strong) NSString *visibilityCode;

// IB public connection in order to show composer keyboard after authentication.
@property(nonatomic,weak) IBOutlet UITextView *contentCommentTextView;

///  Update visibilityCode property and contentVisibilityLabel.
///  @param code The LinkedIn visibility code string, can be anyone or connections-only.
-(void)updateVisibilityCodeWithLocalizedString:(NSString*)code;

/// Gets the MAFLinkedInActivityResources's main bundle and returns it
/// @return The MAFLinkedInActivityResources's main bundle
- (NSBundle *)resourceBundle;
@end
