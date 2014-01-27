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

@interface MFLinkedInComposeViewController : UITableViewController

///  Parent ViewController; responsable for the overlay presentation
@property (nonatomic,weak) MFLinkedInComposePresentationViewController *composePresentationViewController;

///  Child View Controller; responsable for setting the LinkedIn Visibility code, which can be "anyone" or "connections only"
@property(nonatomic,strong) MFLinkedInVisivilityViewController *visivilityViewController;

///  MFLinkedInActivityItem has the share content encapsulated.
@property(nonatomic,strong) MFLinkedInActivityItem *linkedInActivityItem;

///  LinkedIn share API field value, could be one of anyone: all members or connections-only: connections only.
@property(nonatomic,strong) NSString *visibilityCode;


///  Update visibilityCode property and contentVisibilityLabel.
///
///  @param code The LinkedIn visibility code string, can be anyone or connections-only.
-(void)updateVisibilityCodeWithString:(NSString*)code;


//@property(nonatomic,strong) IBOutlet MFStoryImageCell *imageCell; // Could be deleted...
//@property(nonatomic,strong) IBOutlet MFTargetAudienceCell *linkCell;
//@property(nonatomic,weak) IBOutlet UIWebView *storyLinkWebView;
//@property(nonatomic,weak) IBOutlet UITextView *storyLinkCommentTextView;
@end
