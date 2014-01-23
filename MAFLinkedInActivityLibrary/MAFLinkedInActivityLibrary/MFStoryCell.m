//
//  MFStoryCell.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/15/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFStoryCell.h"

@implementation MFStoryCell

/*
-(id)initWithStoryText:(NSString*)story {
    
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    [self configureStoryTextView];
    
    [_commentTextView  setTranslatesAutoresizingMaskIntoConstraints:NO]; // This is very important if setting up constraints in code.
    
    [self.contentView addSubview:_commentTextView];
    
    [self createTextViewConstraints];
    
    return self;
}*/

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        // Initialization code
        
        [self configureStoryTextView];
        
        [_commentTextView  setTranslatesAutoresizingMaskIntoConstraints:NO]; // This is very important if setting up constraints in code.
        
        [self.contentView addSubview:_commentTextView];
        
        [self createTextViewConstraints];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Helper Methods

-(void)configureStoryTextView {
    
    // NOTE: This code is temporary and needs to be revised.
    
    CGFloat width = 0.0;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        width  = 540;
    }
    else {
        width = 300;
    }
    
    
    // Create text view and it's text
    
    _commentTextView = [[UITextView alloc]initWithFrame:CGRectMake(10.0, 10.0, width, 139.0)];
    
    _commentTextView.textAlignment = NSTextAlignmentLeft;
    
    _commentTextView.font = [UIFont fontWithName:@"Helvetica-light" size:17];
    
    //[_storyTextView becomeFirstResponder];
    
}


-(void)createTextViewConstraints {
    
    // Create constraints
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem: _commentTextView
                                                                     attribute: NSLayoutAttributeTop
                                                                     relatedBy: NSLayoutRelationEqual
                                                                        toItem: self.contentView
                                                                     attribute: NSLayoutAttributeTop
                                                                    multiplier: 1.0
                                                                      constant: 10.0];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem: _commentTextView
                                                                          attribute: NSLayoutAttributeTrailing
                                                                          relatedBy: NSLayoutRelationEqual
                                                                             toItem: self.contentView
                                                                          attribute: NSLayoutAttributeTrailing
                                                                         multiplier: 1.0
                                                                           constant: -10.0];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem: _commentTextView
                                                                        attribute: NSLayoutAttributeBottom
                                                                        relatedBy: NSLayoutRelationEqual
                                                                           toItem: self.contentView
                                                                        attribute: NSLayoutAttributeBottom
                                                                       multiplier: 1.0
                                                                         constant: -10.0];
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem: _commentTextView
                                                                         attribute: NSLayoutAttributeLeading
                                                                         relatedBy: NSLayoutRelationEqual
                                                                            toItem: self.contentView
                                                                         attribute: NSLayoutAttributeLeading
                                                                        multiplier: 1.0
                                                                          constant: 10.0];
    // Set priority
    [topConstraint setPriority:UILayoutPriorityRequired];
    [trailingConstraint setPriority:UILayoutPriorityRequired];
    [bottomConstraint setPriority:UILayoutPriorityRequired];
    [leadingConstraint setPriority:UILayoutPriorityRequired];
    
    
    // Add to parent view
    [self.contentView addConstraint:topConstraint];
    [self.contentView addConstraint:trailingConstraint];
    [self.contentView addConstraint:bottomConstraint];
    [self.contentView addConstraint:leadingConstraint];
}



@end
