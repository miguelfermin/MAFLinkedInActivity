//
//  MFLinkedInAuthenticationViewController.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/6/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFLinkedInAuthenticationViewController.h"

// LinkedIn's authorization dialog redirect parameters macros.
#define API_KEY         @"77tp47xbo381qe"           // Required  (A.K.A. client_id). Value of your API Key given when you registered your application with LinkedIn.
#define SECRET_KEY      @"kFz3z5L4XxKnbljU"         // Required. Value of your secret key given when you registered your application with LinkedIn.
#define STATE           @"DCMMFWF10268sdffef102"    // Required. A long unique string value of your choice that is hard to guess. Used to prevent CSRF.
#define REDIRECT_URI    @"https://www.google.com"   // Required. URI in your app where users will be sent after authorization.
#define SCOPE           @"rw_nus"                   // Optional. Use it to specify a list of member permissions that you need and these will be shown to the user on LinkedIn's authorization form.
                                                    // However, for the purpose of this library (share story) this value is required, and it must be of value "rw_nus" to retrieve and post updates
                                                    // to LinkedIn as authenticated user.

#define DENIED_REQUEST_ERROR_DESCRIPTION @"the+user+denied+your+request" // Short description of the user canceled authorization error. Provided by LinkedIn Documentation.


@interface MFLinkedInAuthenticationViewController ()

// Private properties
@property (nonatomic,strong) UIViewController *authenticationViewController;
@property (nonatomic,strong) UIWebView *authenticationWebView;

@end

@implementation MFLinkedInAuthenticationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Prepared Authentication View as soon as this controller is initialized
        
        [self prepareAuthenticationView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSString *linkedInAuthorizationDialog = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=%@&scope=%@&state=%@&redirect_uri=%@", API_KEY, SCOPE, STATE, REDIRECT_URI];
    
    [_authenticationWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:linkedInAuthorizationDialog]]];
    
    
    // iPhone and iPod modal view are always in full screen and will ignore this presentation style
    
    [self setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self addChildViewController:_authenticationViewController];
}


#pragma mark - UIWebViewDelegate Methods

// NOTE: This method is not complete. MF, 2014.01.07
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //NSLog(@"webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType\n ");
    
    /* 
     * Here we have the opportunity to prevent the URI (URL) redirect and handle the response accordingly.
     * 
     * A custome URL Scheme would add unnecessary complexity that can easily be avoided by intervening the request and extract the
     * LinkedIn Authorization Code.
     *
     * Upon successful authorization, the redirected URL should look like:                                  YOUR_REDIRECT_URI/?code=AUTHORIZATION_CODE&state=STATE
     *
     * If the user does not allow authorization to your application, the redirected URL should look like:   YOUR_REDIRECT_URI/?error=access_denied&error_description=the+user+denied+your+request&state=STATE
     *
     * Once the Authorization Code is obtained, we request the Access Token by exchanging the authorization_code for it.
     */
    
    NSString *redirectedURLString = [[request URL] absoluteString];
    //NSLog(@"Redirect URL: %@\n ",redirectedURLString);
    
    // Ensure the response has the redirected URI to then avoid it althogether. This is to make sure the redirect is avoided only when the authorization_code is requested.
    
    if ([redirectedURLString hasPrefix:REDIRECT_URI]) {
        
        // If the keyword "error" is in the response string, authorization was denied. Here are two possible reasons, (1) user tapped the cancel button, (2) An unknown error occurred.
        
        if ([redirectedURLString rangeOfString:@"error"].location != NSNotFound) {
            
            // Determine if user denied authorization or if there was an unknown error
            
            if ([redirectedURLString rangeOfString:DENIED_REQUEST_ERROR_DESCRIPTION].location != NSNotFound) {
                
                NSLog(@"ACCESS WAS DENIED\n ");
                [self cancelActivity];
            }
            else {
                // Handle error
                [self handleLinkedInAuthenticationError:[[ NSError alloc]initWithDomain:@"An error other than -user canceled authorization error- in the response" code:0 userInfo:@{}]];
            }
        }
        else {
            // Extract the response state from the redirected response
            
            NSString *redirectURLExtractedState = [self extractGetParameter:@"state" fromURLString: redirectedURLString];
            
            
            // If the state changed, the request may be a result of CSRF and must be rejected.
            
            if ([redirectURLExtractedState isEqualToString:STATE]) {
                
                // Extract response authorization code.
                
                NSString *authorizationCode = [self extractGetParameter:@"code" fromURLString: redirectedURLString];
                
                
                // Request Access Token by exchanging the authorization_code for it.
                
                [self requestAccessTokenByExchangingAuthorizationCode:authorizationCode];
                
            }
            else {
                [self handleLinkedInAuthenticationError:[[ NSError alloc]initWithDomain:@"Received state parameter != STATE macro def, this could be a due to CSRF" code:1 userInfo:@{}]];
            }
        }
    }
    // Need to add to to avoid the redirect. MF, 2014.01,07
    return YES;
}

/*
- (void)webViewDidStartLoad:(UIWebView *)webView { // To be determined if the rest of the delegate methods are needed.
    //NSLog(@"webViewDidStartLoad:(UIWebView *)webView\n ");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //NSLog(@"webViewDidFinishLoad:(UIWebView *)webView\n ");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //NSLog(@"webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error\n ");
}*/




#pragma mark - Extract GET Parameter values from URL Response

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



#pragma mark - Handle Authorization Results

///  Request Access Token by exchanging the authorization_code for it. The response will be a JSON object containing the "expires_in" and "access_token" parameters.
///  @discussion    The value of parameter expires_in is the number of seconds from now that this access_token will expire in (5184000 seconds is 60 days). Ensure to keep the user access tokens secure.
///  @param         authorizationCode authorization_code obtained when the user was redirected to LinkedIn's authorization dialog.
-(void)requestAccessTokenByExchangingAuthorizationCode:(NSString*)authorizationCode {
    
    //NSLog(@"Authorization Code: %@\n ",authorizationCode);
    
    // Perform request to get access_token
    
    NSURLSessionConfiguration *SessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *delegateFreeSession =  [NSURLSession sessionWithConfiguration:SessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *requestBodyString = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@",authorizationCode,REDIRECT_URI,API_KEY,SECRET_KEY];
    
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
                                //NSLog(@"dataString: %@\n \n ",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                                
                                
                                // This method will extract the JSON object by using the NSJSONSerialization class, saves the values in the Keychain, and dismisses the authentication view.
                                
                                [self completeAuthenticationProcessWithResponseData:data];
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
    
    NSString *expiresInString =   [NSString stringWithFormat:@"%@",[(NSDictionary*)dictionayFromJsonData objectForKey:@"expires_in"]]; // NSJSONSerialization returns __NSCFNumber, convert to NSString
    
    
    // Save access_token and expires_in in Keychain, along with a timestamp to know the date the token was created
    
    [_linkedInUIActivity.linkedInAccount setAccessToken:accessTokenString];
    
    [_linkedInUIActivity.linkedInAccount setExpiresIn:expiresInString];
    
    [_linkedInUIActivity.linkedInAccount setTokenIssueDateString:[_linkedInUIActivity.linkedInAccount stringFromDate:[NSDate date]]];
    
    // NOTE: setting the username is pending... todo when working on the sign out feature. MF, 2014.01.13
    
    
    // Dismiss Authentication Dialog
    
    [self cancelActivity];
}




///  This method dismisses the sharing interface, whether it is the LinkedIn authentication interface or the Composing interface.
///  This method calls activityDidFinish: method and sends NO to it's complete parameter to indicate that the service wasn't completed successfully.
-(void)cancelActivity; {
    NSLog(@"cancelActivity");
    [_linkedInUIActivity activityDidFinish:NO];
}

///  Handle LinkedIn Authentication error.
///
///  @param error The error object to handle.
-(void)handleLinkedInAuthenticationError:(NSError*)error {
    
    // Don't have any code to handle the error, just log to console for now. MF, 2014.01.08
    NSLog(@"error code: %ld, error domain: %@",(long)error.code,error.domain);
}


// Before releasing an instance of UIWebView for which you have set a delegate, you must first set the UIWebView delegate property to nil before disposing of the UIWebView instance.
- (void)dealloc {
    _authenticationWebView.delegate = nil;
}


@end
