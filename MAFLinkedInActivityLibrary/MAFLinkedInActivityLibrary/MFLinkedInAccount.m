//
//  MFLinkedInAccount.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/6/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFLinkedInAccount.h"
#import "UICKeyChainStore.h"

#define DENIED_REQUEST_ERROR_DESCRIPTION @"the+user+denied+your+request" // Short description of the user canceled authorization error. Provided by LinkedIn Documentation.

#define DAYS_BEFORE_EXPIRATION -1 // How soon would you like to refresh the access_token from the expiration date. This value must be negative.

@interface MFLinkedInAccount ()
@end

@implementation MFLinkedInAccount

- (id)init {
    self = [super init];
    
    if (self) {
        
        // Uncomment to see all items in keychain
        //NSLog(@"_keychainStore: %@", [UICKeyChainStore keyChainStoreWithService:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"]);
        
        // Uncomment to remove all items from keychain
        //[self removeAllItemsFromKeyChain];
        //NSLog(@"AFTER--_keychainStore: %@", [UICKeyChainStore keyChainStoreWithService:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"]);
        
        
#pragma mark - LinkedIn's authorization dialog redirect parameters
        _APIKey =       @"77tp47xbo381qe";          // Required  (A.K.A. client_id). Value of your API Key given when you registered your application with LinkedIn.
        
        _secretKey =    @"kFz3z5L4XxKnbljU";        // Required. Value of your secret key given when you registered your application with LinkedIn.
        
        _state =        @"DCMMFWF10268sdffef102";   // Required. A long unique string value of your choice that is hard to guess. Used to prevent CSRF.
        
        _redirectURI =  @"https://www.newstex.com";  // Required. URI in your app where users will be sent after authorization.
        
        _scope =        @"rw_nus";                  // Optional. Use it to specify a list of member permissions that you need and these will be shown to the user on LinkedIn's authorization form.
                                                    // However, for the purpose of this library (share story) this value is required, and it must be of value "rw_nus" to retrieve and post updates
                                                    // to LinkedIn as authenticated user.
    }
    return self;
}



#pragma mark - Custom Getters, To abstract the keychain operation

-(NSString*)username {
    
    return [UICKeyChainStore stringForKey:@"user_name" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}

-(NSString*)accessToken {
    
    return [UICKeyChainStore stringForKey:@"access_token" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}

-(NSString*)expiresIn {
    
    return [UICKeyChainStore stringForKey:@"expires_in" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}

-(NSString*)tokenIssueDateString {
    
    return [UICKeyChainStore stringForKey:@"token_issue_date_string" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}



#pragma mark - Custom Setters

-(void)setUsername:(NSString *)username {
    
    [UICKeyChainStore setString:username forKey:@"user_name" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}

-(void)setAccessToken:(NSString *)accessToken {
    
    [UICKeyChainStore setString:accessToken forKey:@"access_token" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}

-(void)setExpiresIn:(NSString *)expiresIn {
    
    [UICKeyChainStore setString:expiresIn forKey:@"expires_in" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}

-(void)setTokenIssueDateString:(NSString *)tokenIssueDateString {
    
    [UICKeyChainStore setString:tokenIssueDateString forKey:@"token_issue_date_string" service:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}



#pragma mark - Access Token Refresh Mechanism

-(MFAccessTokenStatus)tokenStatus {
    
    // 1. Convert "token_issue_date_string" NSString to NSDate using the tokenIssueDateString property
    
    NSDate *tokenIssueDate = [self dateFromString:[self tokenIssueDateString]];
    
    
    // 2. Convert expires_in NSString to NSDate using tokenIssueDate and the expiresIn property
    
    NSTimeInterval expires_in = [[NSNumber numberWithInt:[[self expiresIn] doubleValue]] doubleValue]; //
    
    NSDate *tokenExpirationDate = [NSDate dateWithTimeInterval:expires_in sinceDate:tokenIssueDate];
    //NSLog(@"Access Token Expiration Date: %@",tokenExpirationDate);
    
    
    // 3. Create an NSDate representing 'n' days before the access_token expiration date.
    //    NOTE: the value you pass to the dateWithDays:FromDate: method's 'days' parameter will be the number of days.
    
    NSDate *daysBeforeExpiration = [self dateWithDays:DAYS_BEFORE_EXPIRATION FromDate:tokenExpirationDate];
    
    /*
     * 4. Determine the access token status and return approproate value.
     *    The time graph below shows the process for determining the token status, the examples show the possible scenarios
     *
     *     example 1                            example 2                            example 3
     *     currentDate                         currentDate                           currentDate
     *         |                                      |                                      |
     *---------|---------daysBeforeExpiration---------|----------tokenExpirationDate---------|-------------> time
     */
    
    NSDate *currentDate = [NSDate date];
    
    // worst case return MFAccessTokenStatusExpired
    MFAccessTokenStatus status = 0;
    
    // daysBeforeExpiration is earlier in time than currentDate. See currentDate example 2
    
    if (([daysBeforeExpiration compare:currentDate] == NSOrderedAscending) == YES) {
        
        status =  MFAccessTokenStatusAboutToExpire;
    }
    
    // daysBeforeExpiration is later in time than currentDate. See currentDate example 1

    if (([daysBeforeExpiration compare:currentDate] == NSOrderedAscending) == NO) {
        
        status =  MFAccessTokenStatusGood;
    }
    
    // tokenExpirationDate is earlier in time than currentDate. See currentDate example 3
    
    if (([tokenExpirationDate compare:currentDate] == NSOrderedAscending)) {
        
        status =  MFAccessTokenStatusExpired;
    }
    
    return status;
    
    
    // Testing Algorithm: change to 1, comment the "return status" statement above, and pass one of the example values to the dateWithDays: method.
#if 0
    NSDate *daysBeforeExpirationTest = [self dateWithDays:DAYS_BEFORE_EXPIRATION FromDate:tokenExpirationDate];
    // NOTE: these values would need to be change based on the expiration date
    int example1 = -20;  //      3/08
    int example2 = -5;   //      3/23
    int example3 = 1;    //      3/29
    //
    NSDate *currentDateTest =          [self dateWithDays:example2 FromDate:tokenExpirationDate];
    //NSLog(@"tokenExpirationDate:        %@",tokenExpirationDate);
    //NSLog(@"daysBeforeExpirationTest:   %@\n ",daysBeforeExpirationTest);
    //NSLog(@"currentDateTest:            %@\n ",currentDateTest);
    // daysBeforeExpiration is earlier in time than currentDate. See currentDate example 2
    if (([daysBeforeExpirationTest compare:currentDateTest] == NSOrderedAscending) == YES) {
        status =  MFAccessTokenStatusAboutToExpire;
        NSLog(@"MFAccessTokenStatusAboutToExpire RAN...");
    }
    // daysBeforeExpiration is later in time than currentDate. See currentDate example 1
    if (([daysBeforeExpirationTest compare:currentDateTest] == NSOrderedAscending) == NO) {
        status =  MFAccessTokenStatusGood;
        NSLog(@"MFAccessTokenStatusGood RAN...");
    }
    // tokenExpirationDate is earlier in time than currentDate. See currentDate example 3
    if (([tokenExpirationDate compare:currentDateTest] == NSOrderedAscending)) {
        status =  MFAccessTokenStatusExpired;
        NSLog(@"MFAccessTokenStatusExpired RAN...");
    }
    NSLog(@"\n ");
    return status;
#endif
}

-(void)refreshToken {
    
    // Request Authorization Code in order to refresh the token
    NSURLSessionConfiguration *SessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session =  [NSURLSession sessionWithConfiguration:SessionConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    //NSURLSession *delegateFreeSession =  [NSURLSession sessionWithConfiguration:SessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *authorizationRequestBody = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=%@&scope=%@&state=%@&redirect_uri=%@", _APIKey, _scope, _state, _redirectURI];
    //NSURLRequest *authorizationCodeRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:authorizationRequestBody]];
    
    
    NSURL *url = [NSURL URLWithString:authorizationRequestBody];
    //NSURL *url2 = [NSURL URLWithString:@"http://www.iphone.org"]; // used to test redirect delegate
    //NSURL *url3 = [NSURL URLWithString:@"https://www.linkedin.com"];
    
    
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc]init];
    [mutableRequest setURL:url];
    [mutableRequest setHTTPMethod:@"GET"];
    [mutableRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    //[mutableRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    //[mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //[mutableRequest setHTTPShouldHandleCookies:NO];
    //[mutableRequest setValue:authorizationRequestBody forHTTPHeaderField:@"Location"];
    
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    //NSArray *cookies = [cookieStorage cookiesForURL:url3];
    NSArray *cookies = [cookieStorage cookies];
    //NSLog(@"cookies: %i\n ",cookies.count);
    
    for (NSHTTPCookie *cookie in cookies) {
        //[cookieStorage deleteCookie:cookie];
        NSLog(@"cookie.name: %@\n ",cookie.name);
    }
    
    NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    NSString *cookie = [dict objectForKey:@"Cookie"];
    
    //NSLog(@"Cookie: %@\n ",cookie);
    [mutableRequest setValue:cookie forHTTPHeaderField:@"Cookie"];
    //NSLog(@"Cookie: %@\n ",[mutableRequest valueForHTTPHeaderField:@"Cookie"]);
    
    [[session dataTaskWithRequest:mutableRequest]resume];
    //[[session dataTaskWithRequest:authorizationCodeRequest]resume];
}



#pragma mark - NSURLSessionDelegates

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"URLSession:dataTask:didReceiveData:\n ");
    NSLog(@"data: %@\n",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"URLSession:task:didCompleteWithError: %@",error);
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler {
    
    NSLog(@"URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:....\n ");
    NSLog(@"[[response URL]absoluteString]: %@\n ",[[response URL]absoluteString]);
    NSLog(@"[[request URL]absoluteString]: %@",[[request URL]absoluteString]);
    NSLog(@"[httpResponse allHeaderFields]: %@\n ",[response allHeaderFields]);
    NSLog(@"[request allHTTPHeaderFields]: %@\n ",[request allHTTPHeaderFields]);
    
    
}
/*
 -(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
 
 NSLog(@"[[response URL]absoluteString]: %@\n ",[[response URL]absoluteString]);
 }*/



#pragma mark - Handle Authorization Results

-(void)handleAuthorizationCodeWithResponse:(NSString*)response {
    
    // If the keyword "error" is in the response string, authorization failed.
    
    if ([response rangeOfString:@"error"].location != NSNotFound) {
        
        [self handleLinkedInAuthenticationError:[[ NSError alloc]initWithDomain:@"An error other in the response while trying to refresh the access token" code:0 userInfo:@{}]];
        
    }
    else {
        // Extract the response state from the redirected response. If the state changed, the request may be a result of CSRF and must be rejected.
        
        NSString *redirectURLExtractedState = [self extractGetParameter:@"state" fromURLString: response];
        
        if ([redirectURLExtractedState isEqualToString:_state]) {
            
            // Extract response authorization code.
            
            NSString *authorizationCode = [self extractGetParameter:@"code" fromURLString: response];
            
            
            // Request Access Token by exchanging the authorization_code for it.
            
            [self requestAccessTokenByExchangingAuthorizationCode:authorizationCode];
            
            NSLog(@"handleAuthorizationCodeWithResponse::");
        }
        else {
            [self handleLinkedInAuthenticationError:[[ NSError alloc]initWithDomain:@"Received state parameter != STATE macro def, this could be a due to CSRF" code:1 userInfo:@{}]];
        }
    }
}

///  Request Access Token by exchanging the authorization_code for it. The response will be a JSON object containing the "expires_in" and "access_token" parameters.
///  @discussion    The value of parameter expires_in is the number of seconds from now that this access_token will expire in (5184000 seconds is 60 days). Ensure to keep the user access tokens secure.
///  @param         authorizationCode authorization_code obtained when the user was redirected to LinkedIn's authorization dialog.
-(void)requestAccessTokenByExchangingAuthorizationCode:(NSString*)authorizationCode {
    
    NSLog(@"Authorization Code: %@\n ",authorizationCode);
    
    // Perform request to get access_token
    
    NSURLSessionConfiguration *SessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *delegateFreeSession =  [NSURLSession sessionWithConfiguration:SessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *requestBodyString = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@",authorizationCode,_redirectURI,_APIKey,_secretKey];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestBodyString]];
    
    [[delegateFreeSession dataTaskWithRequest:request
                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                
                                /*
                                 * NOTE: The data parameter of the block contains a JSON response with the "access_token" and "expires_in" values
                                 *
                                 * The response will be in the following form: {"expires_in":5184000,"access_token":"AQXdSP_W41_UPs5ioT_t8HESyODB4FqbkJ8LrV_5mff4gPODzOYR"}
                                 *
                                 * You can uncomment the line below to log the response to the console.
                                 *
                                 */
                                //NSLog(@"dataString..: %@\n",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                                
                                // This method will extract the JSON object by using the NSJSONSerialization class and saves the values in the Keychain.
                                
                                [self completeAuthenticationProcessWithResponseData:data];
                            }
      ]resume];
}

///  Conclude the authentication process by parsing the JSON objects from the date parameter into Foundation objects, saving the values in the Keychain, and dismissing the uthentication view controller
///  @param data The NSDate object that contains the JSON object to parse and get the access_token and expires_in values
-(void)completeAuthenticationProcessWithResponseData:(NSData*) data {
    
    // Extract "access_toke" and "expires_in" values from JSON response using the NSJSONSerialization class
    
    NSError *jsonParsingError = nil;
    
    NSJSONSerialization *dictionayFromJsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonParsingError];
    
    NSString *accessTokenString = [(NSDictionary*)dictionayFromJsonData objectForKey:@"access_token"];
    
    NSString *expiresInString =   [NSString stringWithFormat:@"%@",[(NSDictionary*)dictionayFromJsonData objectForKey:@"expires_in"]]; // NSJSONSerialization returns __NSCFNumber, convert to NSString
    
    
    // Save access_token and expires_in in Keychain, along with a timestamp to know the date the token was created
    
    [self setAccessToken:accessTokenString];
    
    [self setExpiresIn:expiresInString];
    
    [self setTokenIssueDateString:[self stringFromDate:[NSDate date]]];
    
    
#warning Setting the username is pending... todo when working on the sign out feature. MF, 2014.01.13
    
    // Dismiss Authentication Dialog. This applies to web view only
    //[self dismissAuthenticationView];
}



#pragma mark - Helper Methods

-(NSString*)stringFromDate:(NSDate *)date {
          
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // Format is very important!!
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

-(NSDate*)dateFromString:(NSString*)string {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // Format is very important!!
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    return [dateFormatter dateFromString:string];
}

-(NSDate*)dateWithDays:(NSInteger)days FromDate:(NSDate*)date {
    
    NSDateComponents *daysBeforeComponents = [[NSDateComponents alloc]init];
    
    daysBeforeComponents.day = days;
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:daysBeforeComponents toDate:date options:0];
}

// Extract GET Parameter values from URL Response
-(NSString *)extractGetParameter:(NSString *)parameter fromURLString:(NSString *)redirectedURLString {
    
    // This dictionary will be used to store parameter names and values once they are extracted in the fast enumeration below.
    
    NSMutableDictionary *queryStringsDictionary = [[NSMutableDictionary alloc] init];
    
    
    // Get an array that only contains the response parameters. Array index[0] will have the redirect_uri string  and index[1] will have all parameters in one string
    
    redirectedURLString = [[redirectedURLString componentsSeparatedByString:@"?"] objectAtIndex:1];
    
    
    // These variables will be used to store the request parameter names and values into the dictionary as key-object pairs
    
    NSString *parameterValue = nil;
    NSString *parameterKey = nil;
    
    
    // Now instead of separating the redirect URL from the response parameters, do a fast enumeration to iterate over all parameters, and store it in the dictionary.
    
    for (NSString *queryString in [redirectedURLString componentsSeparatedByString:@"&"]) {
        
        // Extract the characters after the '=', replace '+' with empty string, replace the percent escapes, and then assign this string to the parameterValue variable.
        
        parameterValue = [[[[queryString componentsSeparatedByString:@"="] objectAtIndex:1]stringByReplacingOccurrencesOfString:@"+" withString:@" "]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        // Extract the characters before the '=', this is the parameter name.
        
        parameterKey = [[queryString componentsSeparatedByString:@"="] objectAtIndex:0];
        
        
        // Enter the extracted value-key pair into the dictionary
        
        [queryStringsDictionary setValue:parameterValue forKey:parameterKey];
    }
    
    return [queryStringsDictionary objectForKey:parameter];
}

///  Handle LinkedIn Authentication error.
///  @param error The error object to handle.
-(void)handleLinkedInAuthenticationError:(NSError*)error {
    
#warning Don't have any code to handle the error, just log to console for now. MF, 2014.01.08
    NSLog(@"error code: %ld, error domain: %@",(long)error.code,error.domain);
}



#pragma mark - Delete Account From Keychain

-(void)removeAllItemsFromKeyChain {
    
    [UICKeyChainStore removeAllItemsForService:@"com.newstex.MAFLinkedInActivityLibrary.activity.PostToLinkedIn"];
}


@end

