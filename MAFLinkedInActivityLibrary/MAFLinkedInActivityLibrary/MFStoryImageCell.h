//
//  MFImageCell.h
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/15/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFStoryImageCell : UITableViewCell

-(id)initWithImage:(UIImage*)storyImage;

@property(nonatomic,strong) UITextView *commentTextView;

@property(nonatomic,strong) UIImageView *storyImageView;

@end
