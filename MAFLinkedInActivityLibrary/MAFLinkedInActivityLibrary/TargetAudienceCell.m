//
//  TargetAudienceCell.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/15/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "TargetAudienceCell.h"

@implementation TargetAudienceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect rect;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            rect = CGRectMake(350.0, 8.0, 171.0, 29.0);
        } else {
            rect = CGRectMake(129.0, 8.0, 171.0, 29.0);
        }
        
        _targetAudienceSegmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"Public",@"Connections"]];
        
        [_targetAudienceSegmentedControl setFrame:rect];
        
        [_targetAudienceSegmentedControl setSelectedSegmentIndex:0];
        
        [self addSubview:_targetAudienceSegmentedControl];
    }
    return self;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
