//
//  MFStoryCell.h
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/15/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFStoryCell : UITableViewCell

///  UITextView to display the story.
@property(nonatomic,strong) UITextView *storyTextView;

///  Initializes a MFStoryCell instance with the story string to the the storyTextView property. This method calls the
///
///  @param story The story string used to set the storyTextView property.
///
///  @return Initialized MFStoryCell.
-(id)initWithStoryText:(NSString*)story;

@end
