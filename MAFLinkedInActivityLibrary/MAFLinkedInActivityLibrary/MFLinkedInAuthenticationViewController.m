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
#define SECRET_KEY      @"0000"                     // Required. Value of your secret key given when you registered your application with LinkedIn.
#define SCOPE           @"r_basicprofile"           // Optional. Use it to specify a list of member permissions that you need and these will be shown to the user on LinkedIn's authorization form.
#define STATE           @"DCMMFWF10268sdffef102"    // Required. A long unique string value of your choice that is hard to guess. Used to prevent CSRF.
#define REDIRECT_URI    @"https://www.google.com"   // Required. URI in your app where users will be sent after authorization.


@interface MFLinkedInAuthenticationViewController ()

// Private properties
@property (nonatomic,strong) UIViewController *authenticationViewController;
@property (nonatomic,strong) UIWebView *authenticationWebView;

@end

@implementation MFLinkedInAuthenticationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //NSLog(@"MFLinkedInAuthenticationViewController, initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ");
        
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
    _authenticationWebView.scalesPageToFit = YES;
    _authenticationViewController = [[UIViewController alloc]init];
    _authenticationViewController.view = _authenticationWebView;
    
    // Setup cancel button
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelActivity)];
    _authenticationViewController.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    // Prepare redirect to LinkedIn's authorization dialog
    NSString *linkedInAuthorizationDialog = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=%@&scope=%@&state=%@&redirect_uri=%@", API_KEY, SCOPE, STATE, REDIRECT_URI];
    [_authenticationWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:linkedInAuthorizationDialog]]];
    
    // iPhone and iPod modal view are always in full screen and will ignore this presentation style
    [self setModalPresentationStyle:UIModalPresentationFormSheet];
    [self addChildViewController:_authenticationViewController];
}



///  This method dismisses the sharing interface, whether it is the LinkedIn authentication interface or the Composing interface.
///  This method calls activityDidFinish: method and sends NO to it's complete parameter to indicate that the service wasn't completed successfully.
-(void)cancelActivity; {
    //NSLog(@"cancelActivity");
    [_linkedInUIActivity activityDidFinish:NO];
}



// Before releasing an instance of UIWebView for which you have set a delegate, you must first set the UIWebView delegate property to nil before disposing of the UIWebView instance.
- (void)dealloc {
    _authenticationWebView.delegate = nil;
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
    NSLog(@"Redirect URL: %@\n ",redirectedURLString);
    
    
    // Make sure the redirect URL used when making the request matches the redirected one
    if ([redirectedURLString hasPrefix:REDIRECT_URI]) {
        
        // If the keyword "error" is in the response string, authorization was denied. Here are two possible reasons, (1) user tapped the cancel button, (2) An unknown error occurred.
        if ([redirectedURLString rangeOfString:@"error"].location != NSNotFound) {
            NSLog(@"error was found on the response string");
            
            
            // Determine if user denied authorization or if there was an unknown error
            if ([redirectedURLString rangeOfString:@"the+user+denied+your+request"].location != NSNotFound) {
                NSLog(@"ACCESS WAS DENIED\n ");
                // Dismiss the web view
                [self cancelActivity];
            }
            else {
                // Handle error
                NSLog(@"THERE WAS A ERROR IN THE RESPONSE\n ");
                // Need to add error handler code, for now just dismiss the view. MF, 2014.01.07
                [self cancelActivity];
                //NSError *error = [[ NSError alloc]initWithDomain:@"" code:1 userInfo:@{}];
            }
        }
        else {
            NSLog(@"no error found on the response string");
            
            // do not show redirect_uri page
            //redirectURL = NO;
            
            
            // Ensure the state is correct, e.g. CSRF didn't occurred.
            // Extract the response state, make sure it matches the one sent in prepareAuthenticationView method.
            NSString *redirectURLExtractedState = [self extractGetParameter:@"state" fromURLString: redirectedURLString];
            
            if ([redirectURLExtractedState isEqualToString:STATE]) {
                
                NSLog(@"extractGetParameter: STATE: %@",[self extractGetParameter:@"state" fromURLString: redirectedURLString]);
                
                // Extract response authorization code. Request Access Token by exchanging the authorization_code for it
                NSLog(@"extractGetParameter: CODE: %@",[self extractGetParameter:@"code" fromURLString: redirectedURLString]);
            }
            else {
                NSLog(@"received state doesn't matched sent state, this could be a due to Cross-site request forgery,");
                // If the State recieve doesn't match the State sent, there was an error, check for this and handle it.
            }
            
        }
    }
    // Need to add to to avoid the redirect. MF, 2014.01,07
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView { // To be determined if the rest of the delegate methods are needed.
    //NSLog(@"webViewDidStartLoad:(UIWebView *)webView\n ");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //NSLog(@"webViewDidFinishLoad:(UIWebView *)webView\n ");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //NSLog(@"webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error\n ");
}




#pragma mark - Extract GET Parameter values from URL Response

-(NSString *)extractGetParameter:(NSString *)parameter fromURLString:(NSString *)redirectedURLString {
    
    // This dictionary will be used to store parameter names and values once they are extracted in the fast enumeration below.
    NSMutableDictionary *queryStringsDictionary = [[NSMutableDictionary alloc] init];
    
    // Produce an array containing the response strings which are separated by the character '?'.
    // Then fetch the array object at index one.
    // This separates the redirect URL from the response parameters
    redirectedURLString = [[redirectedURLString componentsSeparatedByString:@"?"] objectAtIndex:1];
    
    // These variables will be used to store the request parameter names and values into the dictionary as key-object pairs
    NSString *parameterValue = nil;
    NSString *parameterKey = nil;
    
    // Now instead of separating the redirect URL from the response parameters, do a fast enumeration to
    // iterate over all parameters, and store it in the mutable dictionary.
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




@end
