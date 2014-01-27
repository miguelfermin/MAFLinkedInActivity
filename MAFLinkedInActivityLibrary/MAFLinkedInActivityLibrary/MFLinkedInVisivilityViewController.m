//
//  MFLinkedInVisivilityViewController.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/24/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFLinkedInVisivilityViewController.h"

@interface MFLinkedInVisivilityViewController ()

@end

@implementation MFLinkedInVisivilityViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Reload table view to see current selection
    
    [[self tableView] reloadData];
}



#pragma mark - Update UI

-(void)updateInterface {
    
    //NSLog(@"_composeViewController.visibilityCode: %@",_composeViewController.visibilityCode);
    
    // Make sure all cells accessory types are "UITableViewCellAccessoryNone" before setting them.
    
    for (int dynamicRow = 0; dynamicRow < 2; ++dynamicRow) {
        
        [[[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:dynamicRow inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    
    // Check mark cell depending on current visibilityCode
    
    if ([_composeViewController.visibilityCode isEqualToString:@"anyone"]) {
        
        [[[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryCheckmark];
        
    }
    else {
        [[[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
}



#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            [_composeViewController updateVisibilityCodeWithString:@"anyone"];
            break;
        case 1:
            [_composeViewController updateVisibilityCodeWithString:@"connections-only"];
            break;
            
        default:
            break;
    }
    // Update table view with new selection and pop current VC
    
    [self updateInterface];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
