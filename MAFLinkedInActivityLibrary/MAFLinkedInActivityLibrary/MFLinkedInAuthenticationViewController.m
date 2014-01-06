//
//  MFLinkedInAuthenticationViewController.m
//  MAFLinkedInActivityLibrary
//
//  Created by Miguel Fermin on 1/6/14.
//  Copyright (c) 2014 Miguel Fermin. All rights reserved.
//

#import "MFLinkedInAuthenticationViewController.h"

// Authentication data
#define API_KEY             @"77tp47xbo381qe"
#define SECRET_KEY          @"0000"


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




#pragma mark -

-(void)prepareAuthenticationView {
    
    // NOTE: This method needs to be refactored. MF 2014.01.06
    
    // Initialize the webview presenting LinkedIn's authentication dialog.
    _authenticationWebView = [[UIWebView alloc]init];
    _authenticationViewController = [[UIViewController alloc]init];
    _authenticationViewController.view = _authenticationWebView;
    
    // Setup cancel button
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelActivity)];
    _authenticationViewController.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    // Prepare redirect to LinkedIn's authorization dialog
    NSString *scope = @"r_basicprofile";
    NSString *state = @"DCMMFWF10268sdffef102";
    NSString *redirectURI = @"https://www.google.com";// redirect to Google now, need to figure out the app URI.
    NSString *linkedInAuthorizationDialog = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=%@&scope=%@&state=%@&redirect_uri=%@", API_KEY, scope, state, redirectURI];
    [_authenticationWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:linkedInAuthorizationDialog]]];
    
    // iPhone and iPod modal view are always in full screen and will ignore this presentation style
    [self setModalPresentationStyle:UIModalPresentationFormSheet];
    [self addChildViewController:_authenticationViewController];
}


///  This method dismisses the sharing interface, whether it is the LinkedIn authentication interface or the Composing interface.
///  This method calls activityDidFinish: method and sends NO to it's complete parameter to indicate that the service wasn't completed successfully.
-(void)cancelActivity; {
    NSLog(@"cancelActivity");
    [_linkedInUIActivity activityDidFinish:NO];
}

@end
