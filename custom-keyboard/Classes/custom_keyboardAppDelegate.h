//
//  custom_keyboardAppDelegate.h
//  custom-keyboard
//
//  Created by Gaurav Kumar on 6/26/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<AVFoundation/AVAudioPlayer.h>

@class custom_keyboardViewController;


@interface custom_keyboardAppDelegate : NSObject <UIApplicationDelegate,AVAudioPlayerDelegate> {
    UIWindow *window;
    custom_keyboardViewController *viewController;
	UIWindow* tempWindow;
	NSInteger *count;
	UIView *keyboardView;
	UIButton *button1;
	UIButton *button2;
	
}

-(IBAction) print_vowels: (id) sender;
-(IBAction) print: (id) sender;


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIWindow *tempWindow;
@property (nonatomic, retain) IBOutlet custom_keyboardViewController *viewController;
@property (nonatomic, retain) IBOutlet UIView *keyboardView;
@property (nonatomic, retain) IBOutlet UIButton *button1;
@property (nonatomic, retain) IBOutlet UIButton *button2;
@property  NSInteger *count; 


@end

