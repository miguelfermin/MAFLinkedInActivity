//
//  MFMasterViewController.m
//  MAFLinkedInActivity
//
//  Created by Miguel Fermin on 12/11/13.
//  Copyright (c) 2013 Miguel Fermin. All rights reserved.
//

#import "MFStoriesViewController.h"

#import "MFStoryViewController.h"

@interface MFStoriesViewController ()

@end

@implementation MFStoriesViewController

- (void)awakeFromNib {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.detailViewController = (MFStoryViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




 /*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}
 */

@end
