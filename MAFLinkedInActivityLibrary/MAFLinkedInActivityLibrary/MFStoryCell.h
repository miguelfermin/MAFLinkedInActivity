//
//  MFStoryCell.h
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/15/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import <UIKit/UIKit.h>

#warning This class is to be deleted, since we no longer posting text by itself.
@interface MFStoryCell : UITableViewCell

///  UITextView to display the story.
@property(nonatomic,strong) UITextView *commentTextView;


//-(id)initWithStoryText:(NSString*)story;

@end
