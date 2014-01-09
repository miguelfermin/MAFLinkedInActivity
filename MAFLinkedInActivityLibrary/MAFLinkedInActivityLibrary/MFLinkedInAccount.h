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

///  The LinkedIn's access token expiration date.
@property (nonatomic,strong) NSDate *accessTokenExpirationDate;

///  User's LinkedIn account user name.
@property (nonatomic,strong) NSString *username;


@end
