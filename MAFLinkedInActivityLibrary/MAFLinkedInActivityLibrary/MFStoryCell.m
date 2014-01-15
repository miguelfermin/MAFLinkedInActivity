//
//  MFStoryCell.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/15/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFStoryCell.h"

@implementation MFStoryCell

-(id)initWithStoryText:(NSString*)story {
    
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    [self configureStoryTextViewWithString:story];
    
    [self addSubview:_storyTextView];
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Helper Methods

-(void)configureStoryTextViewWithString:(NSString*)story {
    
    // NOTE: This code is temporary and needs to be revised.
    CGFloat width = 0.0;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        width  = 540;
    }
    else {
        width = 320;
    }
    //CGFloat width = self.superview.frame.size.width;
    
    _storyTextView = [[UITextView alloc]initWithFrame:CGRectMake(0.0, 0.0, width, 160.0)];
    
    _storyTextView.text = story;
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-light" size:17];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:story
                                                                    attributes:@ {
                                                                        NSFontAttributeName : font,
                                                                        NSParagraphStyleAttributeName:paragraphStyle}];
    
    [_storyTextView setAttributedText:attString];
    
    [_storyTextView becomeFirstResponder];
}

@end
