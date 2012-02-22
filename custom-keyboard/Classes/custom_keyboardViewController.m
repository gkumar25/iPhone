//
//  custom_keyboardViewController.m
//  custom-keyboard
//
//  Created by Gaurav Kumar on 6/26/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import "custom_keyboardViewController.h"
#import "custom_keyboardAppDelegate.h";
#import "SA_OAuthTwitterEngine.h"


#define kOAuthConsumerKey				@"PJhSKhrUDLWGIfUM1azWWA"        //REPLACE With Twitter App OAuth Key
#define kOAuthConsumerSecret			@"JZFFurHbEvbkXWr6UTwU5TOlxa71H8bM50RB2NY"    //REPLACE With Twitter App OAuth Secret


@implementation custom_keyboardViewController
@synthesize textField;

NSInteger temp;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	fbAgent = [[FacebookAgent alloc] initWithApiKey:@"220784404624219" 
										  ApiSecret:@"261d40d50f9bed6d788a932b52465980" 
										   ApiProxy:nil];
	fbAgent.delegate = self;
	
	
	}


- (void) facebook_feed:(id)sender {
	
	fbAgent.shouldResumeSession =YES;
    [fbAgent setStatus:textField.text];

}

- (void) twitter_feed:(id)sender {
		
	if(!_engine){
		_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
		_engine.consumerKey    = kOAuthConsumerKey;
		_engine.consumerSecret = kOAuthConsumerSecret;	
	}
	
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];
	
	if (controller){
		[self presentModalViewController: controller animated: YES];
	}
	
	[_engine sendUpdate:textField.text];	
		
}


- (void) facebookAgent:(FacebookAgent*)agent requestFaild:(NSString*) message{
	fbAgent.shouldResumeSession =NO;
	[fbAgent setStatus:@"status from iPhone demo 1 2"];
}
- (void) facebookAgent:(FacebookAgent*)agent statusChanged:(BOOL) success{
}
- (void) facebookAgent:(FacebookAgent*)agent loginStatus:(BOOL) loggedIn{
}

- (void) facebookAgent:(FacebookAgent*)agent dialog:(FBDialog*)dialog didFailWithError:(NSError*)error{
}
//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}




- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	[textField release];
	textField = nil;
}


- (void)dealloc {
    [_engine release];
    [textField release];
       [super dealloc]; 
}



@end
