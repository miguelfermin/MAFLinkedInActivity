//
//  MFLinkedInAuthenticationViewController.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/6/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFLinkedInAuthenticationViewController.h"
#import "MAFLinkedInActivity.h"

#define DENIED_REQUEST_ERROR_DESCRIPTION @"the+user+denied+your+request" // Short description of the user canceled authorization error. Provided by LinkedIn Documentation.

static NSString *MAFLinkedInActivityErrorDomain = @"MAFLinkedInActivityErrorDomain";

@interface MFLinkedInAuthenticationViewController ()

@property (nonatomic,strong) UIViewController *authenticationViewController;
@property (nonatomic,strong) UIWebView *authenticationWebView;

@end

@implementation MFLinkedInAuthenticationViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIWebViewDelegate Methods

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    /* 
     * Here we have the opportunity to prevent the URI (URL) redirect and handle the response accordingly.
     * 
     * A custom URL Scheme would add unnecessary complexity that can easily be avoided by intervening the request and extract the
     * LinkedIn Authorization Code.
     *
     * Upon successful authorization, the redirected URL should look like:                                  YOUR_REDIRECT_URI/?code=AUTHORIZATION_CODE&state=STATE
     *
     * If the user does not allow authorization to your application, the redirected URL should look like:   YOUR_REDIRECT_URI/?error=access_denied&error_description=the+user+denied+your+request&state=STATE
     *
     * Once the Authorization Code is obtained, we request the Access Token by exchanging the authorization_code for it.
     */
    
    NSString *redirectedURLString = [[request URL] absoluteString];
    MFLog(@"MFLinkedInAuthenticationViewController-webViewshouldStartLoadWithRequest:navigationType: Request URL absoluteString: %@\n ",[[request URL] absoluteString]);
    
    
    // Ensure the response has the redirected URI to then avoid it althogether. This is to make sure the redirect is avoided only when the authorization_code is requested.
    
    if ([redirectedURLString hasPrefix:_linkedInAccount.redirectURI]) {
        
        // If the keyword "error" is in the response string, authorization was denied. Here are two possible reasons, (1) user tapped the cancel button, (2) An unknown error occurred.
        
        if ([redirectedURLString rangeOfString:@"error"].location != NSNotFound) {
            
            // Determine if user denied authorization or if there was an unknown error
            
            if ([redirectedURLString rangeOfString:DENIED_REQUEST_ERROR_DESCRIPTION].location != NSNotFound) {
                
                MFLog(@"MFLinkedInAuthenticationViewController-webViewshouldStartLoadWithRequest:navigationType:. ACCESS WAS DENIED\n ");
                
                [self cancelActivity];
            }
            else {
                
                // Handle error
                
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"User Authorization was unsuccessful.", nil),
                                           NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"An error other than -user canceled authorization error- in the response.", nil),
                                           NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Re-attempt to authenticate user", nil)
                                           };
                
                NSError *error = [NSError errorWithDomain:MAFLinkedInActivityErrorDomain code:26 userInfo:userInfo];
                
                [self handleLinkedInAuthenticationError:error];
            }
        }
        else {
            // Extract the response state from the redirected response
            
            NSString *redirectURLExtractedState = [self extractGetParameter:@"state" fromURLString: redirectedURLString];
            
            
            // If the state changed, the request may be a result of CSRF and must be rejected.
            
            if ([redirectURLExtractedState isEqualToString:_linkedInAccount.state]) {
                
                // Extract response authorization code.
                
                NSString *authorizationCode = [self extractGetParameter:@"code" fromURLString: redirectedURLString];
                
                
                // Request Access Token by exchanging the authorization_code for it.
                
                [self requestAccessTokenByExchangingAuthorizationCode:authorizationCode];
                
            }
            else {
                
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"User Authorization was unsuccessful.", nil),
                                           NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Received state parameter != STATE macro def, this could be a due to CSRF.", nil),
                                           NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Re-attempt to authenticate user", nil)
                                           };
                
                NSError *error = [NSError errorWithDomain:MAFLinkedInActivityErrorDomain code:27 userInfo:userInfo];
                
                [self handleLinkedInAuthenticationError:error];
                
            }
        }
    }
    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    // LinkedIn Authorization Dialog on iPad modal form sheet is too wide.
    // Use javascript to adjust the width to the equivalent of a modal form sheet.
    
	if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
		NSString* javascript =
		@"var meta = document.createElement('meta'); "
		@"meta.setAttribute( 'name', 'viewport' ); "
		@"meta.setAttribute( 'content', 'width = 540px, initial-scale = 1.0, user-scalable = yes' ); "
		@"document.getElementsByTagName('head')[0].appendChild(meta)";
        
		[webView stringByEvaluatingJavaScriptFromString: javascript];
	}
}


#pragma mark - Handle Authorization Results. Note: this methods are duplicated, here and in MFLinkedAccount class, needs future refactoring.

///  Request Access Token by exchanging the authorization_code for it. The response will be a JSON object containing the "expires_in" and "access_token" parameters.
///  @discussion    The value of parameter expires_in is the number of seconds from now that this access_token will expire in (5184000 seconds is 60 days). Ensure to keep the user access tokens secure.
///  @param         authorizationCode authorization_code obtained when the user was redirected to LinkedIn's authorization dialog.
-(void)requestAccessTokenByExchangingAuthorizationCode:(NSString*)authorizationCode {
    
    MFLog(@"MFLinkedInAuthenticationViewController-requestAccessTokenByExchangingAuthorizationCode:. Authorization Code: %@\n ",authorizationCode);
    
    // Perform request to get access_token
    
    NSURLSessionConfiguration *SessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *delegateFreeSession =  [NSURLSession sessionWithConfiguration:SessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *requestBodyString = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@",authorizationCode,_linkedInAccount.redirectURI,_linkedInAccount.APIKey,_linkedInAccount.secretKey];
    
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
                                //MFLog(@"MFLinkedInAuthenticationViewController-requestAccessTokenByExchangingAuthorizationCode:. data: %@\n \n ",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                                MFLog(@"MFLinkedInAuthenticationViewController-requestAccessTokenByExchangingAuthorizationCode:. response: %@\n \n ",[[response URL]absoluteString]);
                                
                                
                                // This method will extract the JSON object by using the NSJSONSerialization class, saves the values in the Keychain, and dismisses the authentication view.
                                
                                [self completeAuthenticationProcessWithResponseData:data];
                                
                                
                                // Once the completeAuthenticationProcessWithResponseData: method finished executing.
                                // Allow Library clients to handle response by letting them know authentication was succesful.
                                
                                id<MFLinkedInActivityDelegate> delegate = _linkedInUIActivity.delegate;
                                
                                if ([delegate respondsToSelector:@selector(authenticationWithResponse:didSucceedWithData:)]) {
                                    
                                    [delegate authenticationWithResponse:response didSucceedWithData:data];
                                }
    }
     ]resume];
}

///  Conclude the authentication process by parsing the JSON objects from the date parameter into Foundation objects, saving the values in the Keychain, and dismissing the uthentication view controller
///
///  @param data The NSDate object that contains the JSON object to parse and get the access_token and expires_in values
-(void)completeAuthenticationProcessWithResponseData:(NSData*) data {
    
    // Extract "access_toke" and "expires_in" values from JSON response using the NSJSONSerialization class
    
    NSError *jsonParsingError = nil;
    
    NSJSONSerialization *dictionayFromJsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonParsingError];
    
    NSString *accessTokenString = [(NSDictionary*)dictionayFromJsonData objectForKey:@"access_token"];
    
    
    
    // Save access_token and expires_in in Keychain, along with a timestamp to know the date the token was created
    
    [_linkedInAccount setAccessToken:accessTokenString];
    
    [_linkedInAccount setExpiresIn:[[(NSDictionary*)dictionayFromJsonData objectForKey:@"expires_in"] doubleValue]];
    
    [_linkedInAccount setTokenIssueDate:[NSDate date]];
    
    
    
    // Dismiss Authentication Dialog
    
    [self dismissAuthenticationView];
}


#pragma mark - Helper Methods

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

-(void)prepareAuthenticationView {
    
    // Initialize WebView and set its Delegate.
    
    _authenticationWebView = [[UIWebView alloc]init];
    
    _authenticationWebView.delegate = self;
    
    //_authenticationWebView.scalesPageToFit = YES;
    
    _authenticationViewController = [[UIViewController alloc]init];
    
    _authenticationViewController.view = _authenticationWebView;
    
    
    // Setup cancel button
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelActivity)];
    
    _authenticationViewController.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    
    // Generate Authorization Code by redirecting user to LinkedIn's authorization dialog. UIWebViewDelegate methods will handle the redirected URI
    
    NSString *linkedInAuthorizationDialog = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=%@&scope=%@&state=%@&redirect_uri=%@", _linkedInAccount.APIKey, _linkedInAccount.scope, _linkedInAccount.state, _linkedInAccount.redirectURI];
    
    [_authenticationWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:linkedInAuthorizationDialog]]];
    
    
    // iPhone and iPod modal view are always in full screen and will ignore this presentation style
    
    [self setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self addChildViewController:_authenticationViewController];
}

///  This method calls _linkedInUIActivity's activityDidFinish: method passing YES to the didFinishe parameter to indicate the authentication was successful.
-(void)dismissAuthenticationView {
    
    [_composeViewController dismissViewControllerAnimated:YES completion:nil];
    
    [_composeViewController.contentCommentTextView becomeFirstResponder];
}

///  This method dismisses the sharing interface, whether it is the LinkedIn authentication interface or the Composing interface.
///  This method calls activityDidFinish: method and sends NO to it's complete parameter to indicate that the service wasn't completed successfully.
-(void)cancelActivity; {
    
    [_linkedInUIActivity activityDidFinish:NO];
}

///  Handle LinkedIn Authentication error.
///  @param error The error object to handle.
///  @warning As of version 1.0 of the library, this method doesn nothing. Future implementation is needed.
-(void)handleLinkedInAuthenticationError:(NSError*)error {
    // Don't have any code to handle the error, just log to console for now. MF, 2014.01.08
    MFLog(@"MFLinkedInAuthenticationViewController-handleLinkedInAuthenticationError:. error code: %ld, error domain: %@",(long)error.code,error.domain);
}

// Before releasing an instance of UIWebView for which you have set a delegate, you must first set the UIWebView delegate property to nil before disposing of the UIWebView instance.
- (void)dealloc {
    _authenticationWebView.delegate = nil;
}

@end
