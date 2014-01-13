//
//  MFLinkedInAccount.h
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/6/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import <Foundation/Foundation.h>

///  This class is responsable for saving a LinkedIn access token to a keychain, fetch the access token from the keychain, and refresh the access token when it expires.
@interface MFLinkedInAccount : NSObject


///  LinkedIn access token. An access token is unique to a user and an API Key. You need access tokens in order to make API calls to LinkedIn on behalf of the user who authorized your application. Access tokens have a life span of 60 days
@property (nonatomic,strong) NSString *accessToken;

///  The value of parameter "expires_in" is the number of seconds from the date the access_token is obtained that this access_token will expire in (usually in 60 days).
@property (nonatomic,strong) NSString *expiresIn;

///  A timestamp string representing the date the access_token was obtain. This value will be used to reconstruct a date from expiresIn and compare that date to the present date to determine if the access_token needs to be refreshed.
@property (nonatomic,strong) NSString *tokenIssueDateString;

///  User's LinkedIn account user name.
@property (nonatomic,strong) NSString *username;


///  Checks the date the access_token was created to determine if it needs to be refreshed.
///  @return Returns YES if it needs fresh, and NO if it doesn't.
-(BOOL)tokenNeedsToBeRefreshed;


///  Converts a NSDate with the format "dd-MM-yyyy" to a NSString.
///  @return A NSString representing the passed parameter date formatted as "dd-MM-yyyy"
-(NSString*)stringFromDate:(NSDate*)date;


///  Converts passed string parameter to a NSDate object with the format "dd-MM-yyyy".
///
///  @param string NSString to convert to NSDate
///
///  @return NSDate object with format "dd-MM-yyyy"
-(NSDate*)dateFromString:(NSString*)string;


///  Creates an NSDate with n days away from the passed date parameter, where n = days parameter.
///
///  @param days The number of days away from the passed date. For days before pass negative values.
///  @param date The reference date to create earlier, equal, or later dates.
///
///  @return A date which is n days away from the passed date, where n = days parameter.
-(NSDate*)dateWithDays:(NSInteger)days FromDate:(NSDate*)date;


///  Calls UICKeyChainStore's removeAllItems method.
-(void)removeAllItemsFromKeyChain;


@end
