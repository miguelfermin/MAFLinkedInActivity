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
    
    [_commentTextView  setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_linkTextView   setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addSubview:_commentTextView];
    [self.contentView addSubview:_linkTextView];
    
    [self createTextViewConstraints];
    [self createLinkTextViewConstraints];
    
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
        textViewRect = CGRectMake(10.0, 10.0, 189.0, 139.0);
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
        linkViewRect = CGRectMake(207.0, 10.0, 103.0, 90.0);
    }
    _linkTextView = [[UITextView alloc]initWithFrame:linkViewRect];
    
    _linkTextView.text = [NSString stringWithFormat:@"%@",storyURL];
    [_linkTextView setEditable:NO];
    _linkTextView.scrollEnabled = NO;
    
    
    [_linkTextView setDataDetectorTypes:UIDataDetectorTypeLink];
    
}


#pragma mark - Auto Layout Constraints

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
                                                                           constant: -121.0];
    
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
    
    NSLayoutConstraint *siblingConstraint = [NSLayoutConstraint constraintWithItem: _commentTextView
                                                                         attribute: NSLayoutAttributeTrailing
                                                                         relatedBy: NSLayoutRelationEqual
                                                                            toItem: _linkTextView 
                                                                         attribute: NSLayoutAttributeLeading
                                                                        multiplier: 1.0
                                                                         constant: -8.0];
    
    // Set priority
    [topConstraint setPriority:UILayoutPriorityRequired];
    [trailingConstraint setPriority:UILayoutPriorityRequired];
    [bottomConstraint setPriority:UILayoutPriorityRequired];
    [leadingConstraint setPriority:UILayoutPriorityRequired];
    [siblingConstraint setPriority:UILayoutPriorityRequired];
    
    // Add to parent view
    [self.contentView addConstraint:topConstraint];
    [self.contentView addConstraint:trailingConstraint];
    [self.contentView addConstraint:bottomConstraint];
    [self.contentView addConstraint:leadingConstraint];
    [self.contentView addConstraint:siblingConstraint];
}


-(void)createLinkTextViewConstraints {
    
    // Create constraints
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem: _linkTextView
                                                                     attribute: NSLayoutAttributeTop
                                                                     relatedBy: NSLayoutRelationEqual
                                                                        toItem: self.contentView
                                                                     attribute: NSLayoutAttributeTop
                                                                    multiplier: 1.0
                                                                      constant: 10.0];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem: _linkTextView
                                                                          attribute: NSLayoutAttributeTrailing
                                                                          relatedBy: NSLayoutRelationEqual
                                                                             toItem: self.contentView
                                                                          attribute: NSLayoutAttributeTrailing
                                                                         multiplier: 1.0
                                                                           constant: -10.0];
    
    NSLayoutConstraint *aspectRatioConstraint = [NSLayoutConstraint constraintWithItem: _linkTextView
                                                                             attribute: NSLayoutAttributeWidth
                                                                             relatedBy: NSLayoutRelationEqual
                                                                                toItem: _linkTextView
                                                                             attribute: NSLayoutAttributeHeight
                                                                            multiplier: 1
                                                                              constant: 0.0];
    
    // Set priority
    [topConstraint setPriority:UILayoutPriorityRequired];
    [trailingConstraint setPriority:UILayoutPriorityRequired];
    [aspectRatioConstraint setPriority:UILayoutPriorityRequired];
    
    // Add to parent view
    [self.contentView addConstraint:topConstraint];
    [self.contentView addConstraint:trailingConstraint];
    [self.contentView addConstraint:aspectRatioConstraint];
}




@end
