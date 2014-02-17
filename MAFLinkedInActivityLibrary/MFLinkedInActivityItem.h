//
//  MFLinkedInActivityItem.h
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/23/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import <Foundation/Foundation.h>

///  Designed to encapsulate the data to be posted.
@interface MFLinkedInActivityItem : NSObject

@property (nonatomic,strong) NSString *contentTitle;
@property (nonatomic,strong) NSString *contentDescription;
@property (nonatomic,strong) NSURL *submittedURL;
@property (nonatomic,strong) NSURL *submittedImageURL;

///  Designater initializer. Clients must only use this method for initialization.
///
///  @param URL This value will be used for the LinkedIn Share API submitted-url field.
///
///  @warning The passed URL parameter must not be nil.
///  @return An initialized MFLinkedInActivityItem object with it's submittedURL property set.
-(id)initWithURL:(NSURL*)URL;

@end
