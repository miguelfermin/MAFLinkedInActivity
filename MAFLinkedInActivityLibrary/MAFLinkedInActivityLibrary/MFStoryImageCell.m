//
//  MFImageCell.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/15/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFStoryImageCell.h"

@implementation MFStoryImageCell

-(id)initWithImageURL:(NSURL*)imageURL {
    
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    [self configureStoryWithImageURL:imageURL];
    
    [_commentTextView  setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_storyImageView   setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addSubview:_commentTextView];
    [self.contentView addSubview:_storyImageView];
    
    [self createTextViewConstraints];
    [self createImageViewConstraints];
    
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

-(void)configureStoryWithImageURL:(NSURL*)imageURL {
    
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
    
    
    
    // Configure Image View
    
    CGRect imageViewRect;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        imageViewRect = CGRectMake(404.0, 12.0, 110.0, 99.0);
    } else {
        imageViewRect = CGRectMake(207.0, 10.0, 103.0, 90.0);
    }
    _storyImageView = [[UIImageView alloc]initWithFrame:imageViewRect];
    
    
    
    // Get image from URL
    
    _storyImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
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
                                                                            toItem: _storyImageView
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


-(void)createImageViewConstraints {
    
    // Create constraints
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem: _storyImageView
                                                                     attribute: NSLayoutAttributeTop
                                                                     relatedBy: NSLayoutRelationEqual
                                                                        toItem: self.contentView
                                                                     attribute: NSLayoutAttributeTop
                                                                    multiplier: 1.0
                                                                      constant: 10.0];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem: _storyImageView
                                                                          attribute: NSLayoutAttributeTrailing
                                                                          relatedBy: NSLayoutRelationEqual
                                                                             toItem: self.contentView
                                                                          attribute: NSLayoutAttributeTrailing
                                                                         multiplier: 1.0
                                                                           constant: -10.0];
    
    NSLayoutConstraint *aspectRatioConstraint = [NSLayoutConstraint constraintWithItem: _storyImageView
                                                                             attribute: NSLayoutAttributeWidth
                                                                             relatedBy: NSLayoutRelationEqual
                                                                                toItem: _storyImageView
                                                                             attribute: NSLayoutAttributeHeight
                                                                            multiplier: _storyImageView.image.size.width / _storyImageView.image.size.height
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
