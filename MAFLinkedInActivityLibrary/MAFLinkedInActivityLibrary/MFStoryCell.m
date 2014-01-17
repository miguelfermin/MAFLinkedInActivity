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

    // This is very important if setting up constraints in code.
    [_storyTextView  setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addSubview:_storyTextView];
    
    [self createTextViewConstraints];
    
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
        width = 300;
    }
    
    // Create text view and it's text
    _storyTextView = [[UITextView alloc]initWithFrame:CGRectMake(10.0, 10.0, width, 139.0)];
    _storyTextView.text = story;
    _storyTextView.textAlignment = NSTextAlignmentLeft;
    _storyTextView.font = [UIFont fontWithName:@"Helvetica-light" size:17];
    //[_storyTextView becomeFirstResponder];
    
}


-(void)createTextViewConstraints {
    
    // Create constraints
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem: _storyTextView
                                                                     attribute: NSLayoutAttributeTop
                                                                     relatedBy: NSLayoutRelationEqual
                                                                        toItem: self.contentView
                                                                     attribute: NSLayoutAttributeTop
                                                                    multiplier: 1.0
                                                                      constant: 10.0];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem: _storyTextView
                                                                          attribute: NSLayoutAttributeTrailing
                                                                          relatedBy: NSLayoutRelationEqual
                                                                             toItem: self.contentView
                                                                          attribute: NSLayoutAttributeTrailing
                                                                         multiplier: 1.0
                                                                           constant: -10.0];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem: _storyTextView
                                                                        attribute: NSLayoutAttributeBottom
                                                                        relatedBy: NSLayoutRelationEqual
                                                                           toItem: self.contentView
                                                                        attribute: NSLayoutAttributeBottom
                                                                       multiplier: 1.0
                                                                         constant: -10.0];
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem: _storyTextView
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
