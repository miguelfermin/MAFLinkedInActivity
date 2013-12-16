//
//  MFDetailViewController.h
//  MAFLinkedInActivity
//
//  Created by Miguel Fermin on 12/11/13.
//  Copyright (c) 2013 Miguel Fermin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFStoryViewController : UIViewController <UISplitViewControllerDelegate>

//@property (strong, nonatomic) id detailItem;


@property(weak, nonatomic) IBOutlet UILabel *storyTitleLabel;

@property(weak, nonatomic) IBOutlet UITextView *storyTextView;

@property(weak, nonatomic) IBOutlet UIImageView *storyImageView;


@end
