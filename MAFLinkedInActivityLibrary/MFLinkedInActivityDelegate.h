//
//  MAFLinkedInPostDelegate.h
//  MAFLinkedInActivity
//
//  Created by Miguel Fermin on 2/21/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MFLinkedInActivityDelegate <NSObject>

/* The following methods are for library clients to act accordingly after receiving a LinkedIn response. */

@optional

///  Tells the delegate that the request was successful.
///
///  @param response The body of the response after a successful post request.
///  @param data     The response data received after a successful post request.
///  @note  both parameters are actually a reference sent from the completion handler of the uploadTaskWithRequest:fromData:completionHandler: method after posting a story.
-(void)postWithResponse:(NSURLResponse *)response didSucceedWithData:(NSData *)data;

///  Tells the delegate that the request was invalid, which is usually caused by a programming error. Ensure that the request is formatted correctly.
///
///  @param response The body of the response after the post failed.
///  @param data     The response data received after the post failed.
///  @param error    This is an error originally sent by the uploadTaskWithRequest:fromData:completionHandler: when there's an error with the response.
///  @note  all parameters are actually a reference sent from the completion handler of the uploadTaskWithRequest:fromData:completionHandler: method after posting a story.
-(void)postWithResponse:(NSURLResponse *)response didFailWithBadRequestWithData:(NSData *)data error:(NSError *)error;

///  Tells the delegate that the access token has expired or has become invalid. Your application needs to take the user through the authorization flow again since their access token has expired. You need to ensure that a valid access token is being used in your API call.
///
///  @param response The body of the response after the post failed because the access token was expired or invalid.
///  @param data     The response data received after the post failed because the access token was expired or invalid.
///  @param error    This is an error originally sent by the uploadTaskWithRequest:fromData:completionHandler: when there's an error with the response.
///  @note  all parameters are actually a reference sent from the completion handler of the uploadTaskWithRequest:fromData:completionHandler: method after posting a story.
-(void)postWithResponse:(NSURLResponse *)response didFailWithInvalidOrExpiredTokenWithData:(NSData *)data error:(NSError *)error;

///  Tells the delegate that you've reached the throttle limit for a particular resource. Visit LinkedIn documentation to see all throttle limits, https://developer.linkedin.com/documents/throttle-limits.
///
///  @param response The body of the response after the post failed because the user reached the daily throttle limit.
///  @param data     The response data received after the post failed because the user reached the daily throttle limit.
///  @param error    This is an error originally sent by the uploadTaskWithRequest:fromData:completionHandler: when there's an error with the response.
///  @note  all parameters are actually a reference sent from the completion handler of the uploadTaskWithRequest:fromData:completionHandler: method after posting a story.
-(void)postWithResponse:(NSURLResponse *)response didReachThrottleLimitWithData:(NSData *)data error:(NSError *)error;

///  Tells the delegate that the endpoint or resource your application is trying to reach doesn't exist
///
///  @param response The body of the response after the post failed because the endpoint or resource your application is trying to reach doesn't exist.
///  @param data     The response data received after the post failed because the endpoint or resource your application is trying to reach doesn't exist.
///  @param error    This is an error originally sent by the uploadTaskWithRequest:fromData:completionHandler: when there's an error with the response.
///  @note  all parameters are actually a reference sent from the completion handler of the uploadTaskWithRequest:fromData:completionHandler: method after posting a story.
-(void)postWithResponse:(NSURLResponse *)response didFailWithPageNotFoundWithData:(NSData *)data error:(NSError *)error;

///  Tells the delegate that there was an application error on the LinkedIn server. Usually your request is valid but needs to be made at a later time.
///
///  @param response The body of the response after the post failed because there was an application error on the LinkedIn server.
///  @param data     The response data received after the post failed because there was an application error on the LinkedIn server.
///  @param error    This is an error originally sent by the uploadTaskWithRequest:fromData:completionHandler: when there's an error with the response.
///  @note  all parameters are actually a reference sent from the completion handler of the uploadTaskWithRequest:fromData:completionHandler: method after posting a story.
-(void)postWithResponse:(NSURLResponse *)response didFailWithInternalServiceErrorWithData:(NSData *)data error:(NSError *)error;

///  Tells the delegate that the user has granted the client app access to their LinkedIn account. This method is called after the user has entered their user name and password
///  in the LinkedIn Authentication WebView and an access_token has been obtained.
///
///  @param response The body of the response after the user has successfully logged-in to their LinkedIn account.
///  @param data     The response data in the form of a JSON object containing the access_token and the exipes_in LinkedIn paramenters.
-(void)authenticationWithResponse:(NSURLResponse *)response didSucceedWithData:(NSData *)data;

@end