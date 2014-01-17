//
//  MFStoryLinkCell.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/15/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFStoryLinkCell.h"

@implementation MFStoryLinkCell


-(id)initWithURL:(NSURL*)storyURL {
    
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    [self configureStoryLinkWithURL:storyURL];
    
    [self addSubview:_commentTextView];
    
    
    //[self addSubview:_linkTextView];
    [self.contentView addSubview:_linkTextView];
    
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

-(void)configureStoryLinkWithURL:(NSURL*)storyURL {
    
    // Configure Comment TextView
    
    CGRect textViewRect;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        textViewRect = CGRectMake(0.0, 12.0, 196.0, 147.0);
    } else {
        textViewRect = CGRectMake(0.0, 12.0, 196.0, 147.0);
    }
    
    _commentTextView = [[UITextView alloc]initWithFrame:textViewRect];
    
    _commentTextView.textAlignment = NSTextAlignmentLeft;
    
    _commentTextView.font = [UIFont fontWithName:@"Helvetica-light" size:17];
    
    [_commentTextView becomeFirstResponder];
    
    
    // Configure Link TextView
    
    CGRect linkViewRect;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        linkViewRect = CGRectMake(404.0, 12.0, 110.0, 99.0);
    } else {
        linkViewRect = CGRectMake(204.0, 12.0, 110.0, 99.0);
    }
    _linkTextView = [[UITextView alloc]initWithFrame:linkViewRect];
    
    _linkTextView.text = [NSString stringWithFormat:@"%@",storyURL];
    [_linkTextView setEditable:NO];
    _linkTextView.scrollEnabled = NO;
    
    
    [_linkTextView setDataDetectorTypes:UIDataDetectorTypeLink];
    
}


@end
