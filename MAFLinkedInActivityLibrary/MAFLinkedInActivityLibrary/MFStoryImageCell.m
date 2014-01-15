//
//  MFImageCell.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/15/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFStoryImageCell.h"

@implementation MFStoryImageCell

-(id)initWithImage:(UIImage*)storyImage {
    
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    [self configureStoryWithImage:storyImage];
    
    [self addSubview:_commentTextView];
    
    [self addSubview:_storyImageView];
    
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

-(void)configureStoryWithImage:(UIImage*)storyImage {
    
    // Configure Comment TextView
    
    CGRect textViewRect;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        textViewRect = CGRectMake(0.0, 12.0, 196.0, 147.0);
    } else {
        textViewRect = CGRectMake(0.0, 12.0, 196.0, 147.0);
    }
    _commentTextView = [[UITextView alloc]initWithFrame:textViewRect];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-light" size:17];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@" "
                                                                    attributes:@ {
                                                                        NSFontAttributeName : font,
                                                                        NSParagraphStyleAttributeName:paragraphStyle}];
    
    [_commentTextView setAttributedText:attString];
    
    [_commentTextView becomeFirstResponder];
    
    
    
    
    // Configure Image View
    
    CGRect imageViewRect;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        imageViewRect = CGRectMake(404.0, 12.0, 110.0, 99.0);
    } else {
        imageViewRect = CGRectMake(204.0, 12.0, 110.0, 99.0);
    }
    _storyImageView = [[UIImageView alloc]initWithFrame:imageViewRect];
    
    _storyImageView.image = storyImage;
}

@end
