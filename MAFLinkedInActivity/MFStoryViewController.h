//
//  MFDetailViewController.h
//  MAFLinkedInActivity
//
//  Created by Miguel Fermin on 12/11/13.
//  Copyright (c) 2013 Miguel Fermin. All rights reserved.
//
//  Description: This class presents the static content (stories) to be used to test 'MFLinkedInSharingLibrary' static library.
//               This class is responsable to handle views transition; presents and dismiss the UIActivityView, etc.

#import <UIKit/UIKit.h>

@interface MFStoryViewController : UIViewController <UISplitViewControllerDelegate>

@property(weak, nonatomic) IBOutlet UILabel *storyTitleLabel;
@property(weak, nonatomic) IBOutlet UITextView *storyTextView;
@property(weak, nonatomic) IBOutlet UIImageView *storyImageView;

@end
