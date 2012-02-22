//
//  custom_keyboardViewController.h
//  custom-keyboard
//
//  Created by Gaurav Kumar on 6/26/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookAgent.h";
#import "SA_OAuthTwitterController.h"
#import<AVFoundation/AVAudioPlayer.h>


@class custom_keyboardAppDelegate;
@class SA_OAuthTwitterEngine;

@interface custom_keyboardViewController : UIViewController<FacebookAgentDelegate,SA_OAuthTwitterControllerDelegate,AVAudioPlayerDelegate,UIAlertViewDelegate> {
		FacebookAgent* fbAgent;
	    IBOutlet UITextView * textField;
	    SA_OAuthTwitterEngine *_engine;  
}

-(IBAction) facebook_feed: (id) sender;
-(IBAction) twitter_feed: (id) sender;

@property (nonatomic, retain) IBOutlet UITextView * textField;

@end

