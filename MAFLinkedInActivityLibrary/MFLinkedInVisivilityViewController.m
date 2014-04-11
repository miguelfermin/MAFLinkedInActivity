//
//  MFLinkedInVisivilityViewController.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/24/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFLinkedInVisivilityViewController.h"
#import "MAFLinkedInActivity.h"

@interface MFLinkedInVisivilityViewController ()

// IB Connections
// For some reason, self.title, makes the text shift left, so I made this connection to update the title.
@property(nonatomic,weak) IBOutlet UINavigationItem *audienceLabel;

@property(nonatomic,weak) IBOutlet UILabel *anyoneLabel;

@property(nonatomic,weak) IBOutlet UILabel *connectionsOnlyLabel;


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
    
    // Set alpha to simulate built-in service transucent activity
    
     self.view.alpha = 0.96f;
    
    
    // Update UI with Localized Strings. First get the resource bundle and then update the labels
    
    NSBundle *resourceBundle = [_composeViewController resourceBundle];
    
    [_audienceLabel setTitle:NSLocalizedStringFromTableInBundle(@"Posting/Labels/Audience label", nil, resourceBundle, nil)];
    
    [_anyoneLabel setText:NSLocalizedStringFromTableInBundle(@"Posting/Labels/Anyone label", nil, resourceBundle, nil)];
    
    [_connectionsOnlyLabel setText:NSLocalizedStringFromTableInBundle(@"Posting/Labels/Connections Only label", nil, resourceBundle, nil)];
}

-(void)viewWillAppear:(BOOL)animated{
    
    // Table cells don't finish drawing correctly when presented on landscape (iPhone only). Reloading the tableView data fixes that issue.
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            
            [[self tableView] reloadData];
        }
    }
}


#pragma mark - Update UI

-(void)updateInterface {
    
    MFLog(@"MFLinkedInVisivilityViewController-updateInterface. Visibility Code: %@",_composeViewController.visibilityCode);
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set LinkedIn visibility code based on selection
    
    switch (indexPath.row) {
        case 0:
            [_composeViewController updateVisibilityCodeWithLocalizedString:@"anyone"];
            break;
        case 1:
            [_composeViewController updateVisibilityCodeWithLocalizedString:@"connections-only"];
            break;
            
        default:
            break;
    }
    
    // Update table view with new selection
    
    [self updateInterface];
    
    
    // Delay the popViewControllerAnimated: so the user can see the check mark before the view disappears.
    
    NSTimeInterval delay = 0.3f;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self.navigationController popViewControllerAnimated:YES];
    });
    
    
    // Flash cell when selected for better visual
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Make sure the entire cell content view has the same color, when set in IB the disclosure indicator area stayed white on iPad.
    
    [cell setBackgroundColor:[UIColor colorWithRed:239.0f/255.0f green:239.0/255.0 blue:244.0/255.0 alpha:1]];
}


@end
