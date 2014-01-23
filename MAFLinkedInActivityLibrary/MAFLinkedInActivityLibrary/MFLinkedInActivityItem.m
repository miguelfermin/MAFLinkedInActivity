//
//  MFLinkedInActivityItem.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/23/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFLinkedInActivityItem.h"

@implementation MFLinkedInActivityItem

-(id)initWithURL:(NSURL*)URL {
    
    self = [super init];
    if (self) {
        // Initialize self.
        
        _submittedURL = URL;
    }
    return self;
}

@end
