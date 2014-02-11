//
//  MFLinkedInAccount.h
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/6/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Access Token possible state
typedef enum: NSInteger {
    
    MFAccessTokenStatusGood = 26,       // Access Token is good, it's safe to make the API call.
    
    MFAccessTokenStatusAboutToExpire,   // Access Token is about to expire (based on DAYS_BEFORE_EXPIRATION), refresh without the authorization dialog (preferred method).
    
    MFAccessTokenStatusExpired            // Access Token doesn't exist, refresh token by going through the authorization dialog.

} MFAccessTokenStatus;


///  This class is responsable for saving a LinkedIn access token to a keychain, fetch the access token from the keychain, and refresh the access token when it expires.
@interface MFLinkedInAccount : NSObject <NSURLSessionDelegate,NSURLSessionDataDelegate,NSURLSessionTaskDelegate>


///  LinkedIn access token. An access token is unique to a user and an API Key. You need access tokens in order to make API calls to LinkedIn on behalf of the user who authorized your application. Access tokens have a life span of 60 days
@property (nonatomic,strong) NSString *accessToken;

///  The value of parameter "expires_in" is the number of seconds from the date the access_token is obtained that this access_token will expire in (usually in 60 days).
@property (nonatomic,strong) NSString *expiresIn;

///  A timestamp string representing the date the access_token was obtain. This value will be used to reconstruct a date from expiresIn and compare that date to the present date to determine if the access_token needs to be refreshed.
@property (nonatomic,strong) NSString *tokenIssueDateString;


// LinkedIn's authorization dialog redirect parameters
@property (nonatomic,strong) NSString *APIKey;
@property (nonatomic,strong) NSString *secretKey;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSString *redirectURI;
@property (nonatomic,strong) NSString *scope;


///  Determines the access token status and return a MFAccessTokenStatus to indicate the actions that need to be taken.
///  @return A MFAccessTokenStatus representing the access token state. Possible values are: MFAccessTokenStatusGood, MFAccessTokenStatusAboutToExpire, MFAccessTokenStatusExpired, or MFAccessTokenStatusNone (if token doesn't exist).
/// @note The MFAccessTokenStatusNone is never returned by this method.
-(MFAccessTokenStatus)tokenStatus;

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
///  @param days The number of days away from the passed date. For days in the past, pass a negative value to the days parameter.
///  @param date The reference date to create earlier, equal, or later dates.
///
///  @return A date which is n days away from the passed date, where n = days parameter.
-(NSDate*)dateWithDays:(NSInteger)days FromDate:(NSDate*)date;

///  Go through the authorization flow in order to fetch a new access token with an additional 60 day life span.
///  @discussion The following two conditions must exist:
///  (1) User is still logged into Linkedin.com.
///  (2) The current access token isn't expired (within the 60 life span).
-(void)refreshToken;


///  Signs user out of their LinkedIn account by deleting their login information from the keychain. This method calls UICKeyChainStore's removeAllItemsForService: method and passes the service to be deleted, "com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn". Next time the user wants to use LinkedIn, they'll have to go through the authentication process.
-(void)signOutUser;


@end
