//
//  custom_keyboardAppDelegate.m
//  custom-keyboard
//
//  Created by Gaurav Kumar on 6/26/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import "custom_keyboardAppDelegate.h"
#import "custom_keyboardViewController.h"


@implementation custom_keyboardAppDelegate

@synthesize window;
@synthesize tempWindow;
@synthesize viewController;
@synthesize count;
@synthesize keyboardView;
@synthesize button1;
@synthesize button2;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	// Override point for customization after application launch.
	
	//Add a handler for the keyboardwillshow event -  This is where we will add the button to the keyboard
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    // Add the view controller's view to the window and display.
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

    return YES;
}


 - (void)keyboardWillShow:(NSNotification *)note {
    
	//Just used to reference windows of our application while we iterate though them
	//UIWindow* tempWindow;
	
	
	//Check each window in our application
	for(int c = 0; c < [[[UIApplication sharedApplication] windows] count]; c ++)
	{
		//Get a reference of the current window
		tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:c];
				
		
		if([[tempWindow description] hasPrefix:@"<UITextEffectsWindow"] == YES){
			
			
			//[tempWindow setFrame:CGRectMake(0,-20, tempWindow.frame.size.width, tempWindow.frame.size.height)];
		
			button1 = [UIButton buttonWithType:UIButtonTypeCustom];
			button2 = [UIButton buttonWithType:UIButtonTypeCustom];
			
			
			//Position the button - I found these numbers align fine (0, 0 = top left of keyboard)
			 button1.frame = CGRectMake(65,432, 80, 50);
			 button2.frame = CGRectMake(128,432, 110, 50); 
			
			//Add images to our button so that it looks proper when we click
			[button1 setImage:[UIImage imageNamed:@"globe.gif"] forState:UIControlStateNormal];
			[button1 addTarget:self action:@selector(change_keyboard:) forControlEvents:UIControlEventTouchUpInside];
			
			//Add images to our button so that it looks proper when we click
			[button2 setImage:[UIImage imageNamed:@"space.gif"] forState:UIControlStateNormal];
			[button2 addTarget:self action:@selector(space:) forControlEvents:UIControlEventTouchUpInside];
			
			
			 [tempWindow addSubview:button1];	
			 [tempWindow addSubview:button2]; 
         		
		     
			return;			
			
		}
			
	}
}


- (void) change_keyboard:(id)sender {
	NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"HindiKeyboardView" owner:self options:nil];
	keyboardView = [nibViews objectAtIndex:0];
	keyboardView.frame = CGRectMake(0,245,320, 480);
	[tempWindow addSubview:keyboardView];

}


- (void) hide_keyboard_view : (id)sender {
	[keyboardView removeFromSuperview];
	}


- (void) show_vowels: (id) sender {
	[keyboardView removeFromSuperview];
	NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"HindiVowels" owner:self options:nil];
	keyboardView = [nibViews objectAtIndex:0];
	keyboardView.frame = CGRectMake(0,245,320, 480);
    [tempWindow addSubview:keyboardView];
}

- (void) show_alphabets: (id) sender {
	[keyboardView removeFromSuperview];
	NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"HindiKeyboardView" owner:self options:nil];
	keyboardView = [nibViews objectAtIndex:0];	
	keyboardView.frame = CGRectMake(0,245,320, 480);
    [tempWindow addSubview:keyboardView];
}

- (void) print: (id) sender {
	
	NSString *pressedAlphabet =  [[NSString alloc] initWithFormat:@"%@",[[sender titleLabel] text] ];
	if(count == 0){
		viewController.textField.text = pressedAlphabet;
		count++; 	
	} else {
		viewController.textField.text =   [[viewController.textField.text stringByAppendingString: pressedAlphabet] retain];	
		count++; 	
	}

	[pressedAlphabet release]; 	
		
}


- (void) print_vowels: (id) sender {
	
	NSString *pressedAlphabet =  [[NSString alloc] initWithFormat:@"%@",[[sender titleLabel] text] ];
	if(count == 0){
		viewController.textField.text = pressedAlphabet;
		count++; 	
	} else {
		viewController.textField.text =   [[viewController.textField.text stringByAppendingString: pressedAlphabet] retain];	
		count++; 	
	}
	
	[pressedAlphabet release]; 		
	
}


- (void) space: (id) sender {
	
	NSString *pressedSpace = @" ";
	
	if(count == 0){
	    viewController.textField.text = pressedSpace;
		count++; 	
	} else {
		viewController.textField.text =   [[viewController.textField.text stringByAppendingString: pressedSpace] retain];	
		count++; 	
	}
	
	[pressedSpace release]; 
	
}


- (void) clear: (id) sender {
	
	NSString *pressedSpace = @" ";
	
	
	if(count == 0){
	   viewController.textField.text = pressedSpace;
		
	} else {
		viewController.textField.text =   [[viewController.textField.text substringToIndex:[viewController.textField.text length] - 1] retain];	
		count--; 	
	}
	
	[pressedSpace release]; 
	
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
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
