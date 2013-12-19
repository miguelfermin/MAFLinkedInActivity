//
//  LinkedInUIActivity.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 12/19/13.
//  Copyright (c) 2013 Miguel Fermin. All rights reserved.
//
//  Description: xx...
//
//  Purpose: xx...
//
//  How to use: xx...


#import "MFLinkedInUIActivity.h"

@implementation MFLinkedInUIActivity


#pragma mark - Methods to Override to provide LinkedIn service information.

// NOTE: all comments have Apple's description, to be changed when customized. MF, 2013.12.19

/*
 * An identifier for the type of service being provided.
 * This method returns nil by default. Subclasses must override this method and return a valid string that identifies the application service. This string is not presented to the user.
 */
-(NSString *)activityType {
    return @"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn";
}

/*
 * A user-readable string describing the service.
 * This method returns nil by default. Subclasses must override this method and return a user-readable string that describes the service. The string you return should be localized.
 */
-(NSString *)activityTitle {
    return NSLocalizedString(@"LinkedIn", @"LinkedIn");
}


/*
 * An image that identifies the service to the user.
 * This method returns nil by default. Subclasses must override this method and return a valid image object. The image is used to generate a button for your service in the UI displayed by the UIActivityViewController object.
 */
-(UIImage *)activityImage {
    // This image is a placeholder for now, needs to be changed. MF, 2013.12.19
    
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"activity" ofType:@"png"]];
    //return [UIImage imageNamed:@"activity.png"];
}

/*
 * Returns a Boolean indicating whether the service can act on the specified data items.
 *
 * The default implementation of this method returns NO. Subclasses must override it and return YES if the data in the activityItems parameter can be operated on by your service. Your 
 * implementation should check the types of the objects
 * in the array and use that information to determine if your service can act on the corresponding data.
 *
 * The UIActivityViewController object calls this method when determining which services to show to the user.
 */
-(BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}


/*
 * Prepares your service to act on the specified data.
 *
 * The default implementation of this method does nothing. This method is called after the user has selected your service but before your service is asked to perform its action.
 * Subclasses should override this method and use it to store a reference to the data items in the activityItems parameter. In addition, if the implementation of your service requires displaying
 * additional UI to the user, you can use this method to prepare your view controller object and make it available from the activityViewController method.
 */
-(void)prepareWithActivityItems:(NSArray *)activityItems {
    //
}


/*
 * Returns the category of the activity, which may be used to group activities in the UI.
 * Override this method to define a different activity category for your custom activity.
 */
+(UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}


@end
