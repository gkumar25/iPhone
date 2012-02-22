//
//  twtvAppDelegate.m
//  twtv
//
//  Created by Gaurav Kumar on 3/9/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import "twtvAppDelegate.h"
#import "Constants.h"
#import "ChanelNavController.h"; 
 // #import "FeaturedViewController.h"
// #import "Reachability.h"
// #import "ErrorHandlerService.h"

// @class FeaturedViewController;
 // @class Reachability;
// @class ErrorHandlerService;

@implementation twtvAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize bcServices;
@synthesize operationQueue;
@synthesize currentNetworkStatus;
@synthesize playlist;
@synthesize ChanelNavController;
// @synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(reachabilityChanged:) 
                                                 name:kReachabilityChangedNotification 
                                               object:nil];
    reach = [[Reachability reachabilityWithHostName:@"api.brightcove.com"] retain];
    [reach startNotifier];
    
	// init Brightcove Media API
	bcServices = [[BCMediaAPI alloc] initWithReadToken:MEDIA_API_KEY];
	
	// init our operation queue
	operationQueue = [[NSOperationQueue alloc] init];
	[operationQueue setMaxConcurrentOperationCount:1];
	
   
		
	/*  tabBarController = [[UITabBarController alloc] init];
	
    featuredView = [[FeaturedViewController alloc] initWithNibName:@"FeaturedView"
												            bundle:nil];
    
    UINavigationController *navigationController = [[UINavigationController alloc] 
                                                    initWithRootViewController:featuredView];
    [[navigationController navigationBar] setBarStyle:UIBarStyleBlack];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured 
                                                                    tag:0];
    [navigationController setTabBarItem:item];
    [item release];
    
    NSArray *controllers = [[NSArray alloc] initWithObjects:navigationController, nil];
    [navigationController release];
    [tabBarController setViewControllers:controllers];
    [controllers release];
    */
	[window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
	
	return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


//Called by Reachability whenever status changes.
- (void)reachabilityChanged:(NSNotification *)note
{
	 NSLog(@"reachability");
	Reachability *curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    currentNetworkStatus = [curReach currentReachabilityStatus];
    if (currentNetworkStatus == NotReachable) {
  //      [chanel startCallToServer];
   // } else {
        [[ErrorHandlerService sharedInstance] logMediaAPIError:nil];
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self 
                                                   name:kReachabilityChangedNotification 
                                                 object:reach];
    
    [reach release];
    reach = nil;
}


- (void)dealloc {
    [tabBarController release];
    [window release];
	[ChanelNavController release];
    [super dealloc];
}

@end

