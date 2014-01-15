//
//  MFStoryLinkCell.h
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/15/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFStoryLinkCell : UITableViewCell

-(id)initWithURL:(NSURL*)storyURL;

@property(nonatomic,strong) UITextView *commentTextView;

@property(nonatomic,strong) UITextView *linkTextView;

@end
