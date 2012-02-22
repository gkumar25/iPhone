//
//  twtvAppDelegate.h
//  twtv
//
//  Created by Gaurav Kumar on 3/9/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCMediaAPI.h"
#import "Reachability.h"
 // #import "FeaturedViewController.h"

@class FeaturedViewController;
@class Reachability;
@class ErrorHandlerService;
@class BrightcoveLibrary;
@class ChanelViewController;
@class BCPlaylist;
@class ChanelNavController;


@interface twtvAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	BCMediaAPI *bcServices;
	NSOperationQueue *operationQueue;
    //UITabBarController *tabBarController;
    ChanelViewController *chanel;
    Reachability *reach;
    NetworkStatus currentNetworkStatus;
	BrightcoveLibrary *bcove;
	 BCPlaylist *playlist;
	//UINavigationController *navigationController;
	IBOutlet ChanelNavController *ChanelNavController;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet ChanelNavController *ChanelNavController;
@property (nonatomic, readonly) NSOperationQueue *operationQueue;
@property (nonatomic, readonly) BCMediaAPI *bcServices;
@property (nonatomic, retain) BCPlaylist *playlist;
@property (nonatomic, readonly) NetworkStatus currentNetworkStatus;
//@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;


@end
