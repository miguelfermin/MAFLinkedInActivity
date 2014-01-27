//
//  MFTargetAudienceCell.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/15/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFTargetAudienceCell.h"

@implementation MFTargetAudienceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        /*
        CGRect rect;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            rect = CGRectMake(350.0, 8.0, 171.0, 29.0);
        }
        else {
            rect = CGRectMake(119.0, 8.0, 181.0, 29.0);
        }
        
        // Segmented Control to set share target audience.
        _targetAudienceSegmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"Public",@"Connections"]];
        [_targetAudienceSegmentedControl setFrame:rect];
        [_targetAudienceSegmentedControl setSelectedSegmentIndex:0];
        
        
        
        // This is very important if setting up constraints in code.
        [_targetAudienceSegmentedControl  setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        
        [self.contentView addSubview:_targetAudienceSegmentedControl];
        
        [self createSegmentedControlAutoLayoutConstraints];
         
         */
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)createSegmentedControlAutoLayoutConstraints {
    
    // Create constraints
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem: _targetAudienceSegmentedControl
                                                                     attribute: NSLayoutAttributeTop
                                                                     relatedBy: NSLayoutRelationEqual
                                                                        toItem: self.contentView
                                                                     attribute: NSLayoutAttributeTop
                                                                    multiplier: 1.0
                                                                      constant: 8.0];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem: _targetAudienceSegmentedControl
                                                                          attribute: NSLayoutAttributeTrailing
                                                                          relatedBy: NSLayoutRelationEqual
                                                                             toItem: self.contentView
                                                                          attribute: NSLayoutAttributeTrailing
                                                                         multiplier: 1.0
                                                                           constant: -20.0];
    
    // Set priority
    
    [topConstraint      setPriority:UILayoutPriorityRequired];
    [trailingConstraint setPriority:UILayoutPriorityRequired];
    
    
    // Add to parent view
    
    [self.contentView addConstraint:topConstraint];
    [self.contentView addConstraint:trailingConstraint];
}




-(void)createConstraint {
    
    /*
     * Describe the Layout with Constrains Using Code: Step 1: Create constraint. The API for that is "NSLayoutConstraint.h"
     * ---------------------------------------------------------------------------------------------------------------------
     *
     * item1.attribute1 = multiplier x item2.attribute2 + constant |OR| item1.attribute1 <= multiplier x item2.attribute2 + constant
     *
     *
     * Method Description
     * -------------------
     *
     * Create a constraint of the form "view1.attr1 <relation> view2.attr2 * multiplier + constant".
     
     * Constraints are of the form "view1.attr1 <relation> view2.attr2 * multiplier + constant".
     
     * If the constraint you wish to express does not have a second view and attribute, use nil and NSLayoutAttributeNotAnAttribute.
     *
     *
     *
     * Method Parameters
     * ------------------
     *
     * [NSLayoutConstraint constraintWithItem:<#(id)#> item1 - The view for the left-hand side of the constraint.
     *
     *                              attribute:<#(NSLayoutAttribute)#> attribute1 - The attribute of the view for the left-hand side of the constraint.
     *
     *                              relatedBy:<#(NSLayoutRelation)#> relation - The relationship between the left-hand side of the constraint and the right-hand side of the constraint.
     *
     *                                 toItem:<#(id)#> item2 - The view for the right-hand side of the constraint.
     *
     *                              attribute:<#(NSLayoutAttribute)#> attribute2 - The attribute of the view for the right-hand side of the constraint.
     *
     *                             multiplier:<#(CGFloat)#> multiplier - The constant multiplied with the attribute on the right-hand side of the constraint as part of getting the modified attribute.
     *
     *                               constant:<#(CGFloat)#>]; constant - The constant added to the multiplied attribute value on the right-hand side of the constraint to yield the final modified attribute.
     *
     *
     *
     *
     * Step 2: Add constraint to View. This is one of the API methods: -(void)addConstraint:(NSLayoutConstraint *)constraint
     *
     *
     * ---------------------
     * NSLayoutAttribute
     * ---------------------
     * NSLayoutAttributeLeft - The left side of the object’s alignment rectangle.
     *
     * NSLayoutAttributeRight - The right side of the object’s alignment rectangle.
     *
     * NSLayoutAttributeTop - The top of the object’s alignment rectangle.
     *
     * NSLayoutAttributeBottom - The bottom of the object’s alignment rectangle.
     *
     *
     * NSLayoutAttributeLeading - The leading edge of the object’s alignment rectangle.
     *
     * NSLayoutAttributeTrailing - The trailing edge of the object’s alignment rectangle.
     *
     *
     * NSLayoutAttributeWidth - The width of the object’s alignment rectangle.
     *
     * NSLayoutAttributeHeight - The height of the object’s alignment rectangle.
     *
     *
     * NSLayoutAttributeCenterX - The center along the x-axis of the object’s alignment rectangle.
     *
     * NSLayoutAttributeCenterY - The center along the y-axis of the object’s alignment rectangle.
     *
     *
     * NSLayoutAttributeNotAnAttribute - The requested attribute does not exist. This result would be returned if you asked a constraint with no second object for the attribute of its second object.
     *
     *
     * -----------------
     * NSLayoutRelation
     * -----------------
     * NSLayoutRelationLessThanOrEqual - The constraint requires that the first attribute be less than or equal to the modified second attribute.
     *
     * NSLayoutRelationEqual - The constraint requires that the first attribute be exactly equal to the modified second attribute.
     *
     * NSLayoutRelationGreaterThanOrEqual - The constraint requires that the first attribute by greater than or equal to the modified second attribute.
     *
     */
    
    // Create constraints
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem: _targetAudienceSegmentedControl
                                                                     attribute: NSLayoutAttributeTop
                                                                     relatedBy: NSLayoutRelationEqual
                                                                        toItem: self.contentView
                                                                     attribute: NSLayoutAttributeTop
                                                                    multiplier: 1.0
                                                                      constant: 8.0];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem: _targetAudienceSegmentedControl
                                                                          attribute: NSLayoutAttributeTrailing
                                                                          relatedBy: NSLayoutRelationEqual
                                                                             toItem: self.contentView
                                                                          attribute: NSLayoutAttributeTrailing
                                                                         multiplier: 1.0
                                                                           constant: 20.0];
    
    /*NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem: _targetAudienceSegmentedControl
                                                                        attribute: NSLayoutAttributeBottom
                                                                        relatedBy: NSLayoutRelationEqual
                                                                           toItem: self.contentView
                                                                        attribute: NSLayoutAttributeBottom
                                                                       multiplier: 1.0
                                                                         constant: 0.0];*/
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem: _targetAudienceSegmentedControl
                                                                         attribute: NSLayoutAttributeLeading
                                                                         relatedBy: NSLayoutRelationEqual
                                                                            toItem: self.contentView
                                                                         attribute: NSLayoutAttributeLeading
                                                                        multiplier: 1.0
                                                                          constant: 129.0];
    
    // Set priority
    [topConstraint setPriority:UILayoutPriorityRequired];
    
    [trailingConstraint setPriority:UILayoutPriorityRequired];
    
    //[bottomConstraint setPriority:UILayoutPriorityRequired];
    
    [leadingConstraint setPriority:100];
    
    
    
    
    // Add to parent view
    [self.contentView addConstraint:topConstraint];
    
    [self.contentView addConstraint:trailingConstraint];
    
    //[self.contentView addConstraint:bottomConstraint];
    
    [self.contentView addConstraint:leadingConstraint];
}




@end
