    //
//  MoviePlayerViewController.m
//  twtv
//
//  Created by Gaurav Kumar on 3/11/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import "MoviePlayerViewController.h"
#import "BCMoviePlayerController.h"
#import "BCVideo.h"
#import "Reachability.h"
#import "twtvAppDelegate.h"
#import "TimeCodeManager.h"
// #import "BCPlayer.h"

@implementation MoviePlayerViewController

@synthesize video;
@synthesize chanel;
@synthesize activityIndicator;
@synthesize delegate;

// The designated initializer.  Override if you create the controller programmatically and want to 
//perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
       
		[self setTitle:@"VideoPlayer"];

		
        
        bcPlayer = [[BCMoviePlayerController alloc] init];
		
		
        [bcPlayer setUseApplicationAudioSession:NO];
		
		
        
      /*  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self 
               selector:@selector(playbackStateDidChange:) 
                   name:MPMoviePlayerPlaybackStateDidChangeNotification 
                 object:bcPlayer];
        [nc addObserver:self 
               selector:@selector(loadStateDidChange:) 
                   name:MPMoviePlayerLoadStateDidChangeNotification
                 object:bcPlayer];
        [nc addObserver:self 
               selector:@selector(willEnterFullscreen:) 
                   name:MPMoviePlayerWillEnterFullscreenNotification
                 object:bcPlayer];
        [nc addObserver:self 
               selector:@selector(didExitFullscreen:) 
                   name:MPMoviePlayerDidExitFullscreenNotification
                 object:bcPlayer];
        [nc addObserver:self 
               selector:@selector(playbackDidFinish:) 
                   name:MPMoviePlayerPlaybackDidFinishNotification
                 object:bcPlayer];
		*/
       
        
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];	
     bcPlayer.view.frame = CGRectMake(10, 10, 300, 350);  
	 [self.view addSubview:bcPlayer.view];
	 [bcPlayer play];
	
  }




- (void)setWithBCVideo:(BCVideo *) v {
     
    if (!isStreamingVideo) {
        [activityIndicator startAnimating];
		
    } else {
        [self saveTimeCode];
    }
	
	[self setVideo:v];
    
	
		
		
	if ( video ) {
		
		bcPlayer = [[BCMoviePlayerController alloc] init];
		if ([bcPlayer respondsToSelector:@selector(setFullscreen:animated:)]) {
			[bcPlayer setContentURL:v];
			
			
			[bcPlayer prepareToPlay];
			
			
			twtvAppDelegate *appDelegate = 
			(twtvAppDelegate *)[[UIApplication sharedApplication] delegate]; 
			if ([appDelegate currentNetworkStatus] == ReachableViaWiFi) {
				[bcPlayer searchForRenditionsBetweenLowBitRate:[NSNumber numberWithInt:800000] 
												andHighBitRate:[NSNumber numberWithInt:2000000]];
			} else {
				[bcPlayer searchForRenditionsBetweenLowBitRate:[NSNumber numberWithInt:200000] 
												andHighBitRate:[NSNumber numberWithInt:500000]];
			    }
			
		 }
		
	}		
	
	NSString *currentVideoURL = [[bcPlayer contentURL] absoluteString];
     NSLog(@"video: %@",currentVideoURL);
	if ([currentVideoURL hasSuffix:@".mp4"]) {
        isStreamingVideo = NO;
     //    NSLog(@"mp4");
	} else {
        isStreamingVideo = YES;
    }
    
    // On 3G networks with weak signals we saw odd behavior with the 'shouldAutoplay'
    // property, lets manually manage this for now
    if (shouldAutoPlay || isStreamingVideo) {
        [bcPlayer play];        
    }
    
    if (!shouldAutoPlay && !isStreamingVideo) {
        shouldAutoPlay = YES;
    }

}

- (void)animateRotation:(UIInterfaceOrientation)interfaceOrientation 
               duration:(NSTimeInterval)duration {
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait || 
        interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        CGRect portraitRect = CGRectMake(0.0f, 0.0f, 768.0f, 432.0f);
        [[self view] setFrame:portraitRect];
        [[bcPlayer view] setFrame:portraitRect];
        if (![bcPlayer isFullscreen]) {
            [[bcPlayer backgroundView] setFrame:portraitRect];
            [[bcPlayer backgroundView] setBackgroundColor:portraitBackground];
        }
        
        [activityIndicator setCenter:CGPointMake(384.0f,160.0f)];
    } else {
        CGRect landscapeRect = CGRectMake(0.0f, 0.0f, 1024.0f, 348.0f);        
        [[self view] setFrame:landscapeRect];        
        [[bcPlayer view] setFrame:CGRectMake(205.0f, 0.0f, 619.0f, 348.0f)];
        if (![bcPlayer isFullscreen]) {
            [[bcPlayer backgroundView] setFrame:CGRectMake(-205.0f, 0.0f, 1024.0f, 348.0f)];
            [[bcPlayer backgroundView] setBackgroundColor:landscapeBackground];
        }
        [activityIndicator setCenter:CGPointMake(512.0f,110.0f)];
    }
}

- (void)exitFullscreenAndContinuePlaylist:(NSTimeInterval) currentPlaybackTime {
    [bcPlayer setFullscreen:NO animated:YES];
    if ([bcPlayer currentPlaybackTime] >= 1.0) {
        [delegate playNextVideo:self];
    } else {
        [delegate playPreviousVideo:self];
    }
}

- (void)playbackStateDidChange:(NSNotification *)notification {
    if ([bcPlayer playbackState] == MPMoviePlaybackStateStopped) {
        if ([bcPlayer isFullscreen]) {
            [self exitFullscreenAndContinuePlaylist:[bcPlayer currentPlaybackTime]];
        }
    }
}

- (void)loadStateDidChange:(NSNotification *)notification {
    
    if ([bcPlayer loadState] == (MPMovieLoadStatePlaythroughOK | MPMovieLoadStatePlayable) ) {
        
        if (isStreamingVideo) { 
            TimeCodeManager *manager = [[TimeCodeManager alloc] init];
            NSTimeInterval timecodeSaved = [manager timeCodeForVideoId:[[self video] videoId]];
            if (timecodeSaved > 0) {
				[bcPlayer setCurrentPlaybackTime:timecodeSaved]; 
				if (!shouldAutoPlay) {
                    [bcPlayer pause];
                    shouldAutoPlay = YES;
                }
            }
            
            // Remove this timeCode. A new one will be created when the user
            // switches to a new video. 
            [manager removeTimeCode:[[self video] videoId]];
            [manager release];
        }
        [activityIndicator stopAnimating];
        
    }
}

- (void)willEnterFullscreen:(NSNotification *)notification {
    [[bcPlayer backgroundView] setBackgroundColor:[UIColor blackColor]];
}

- (void)playbackDidFinish:(NSNotification *)notification {
    // Rewind the video to the beginning. 
    [bcPlayer setCurrentPlaybackTime:0.0f];
}

- (void)didExitFullscreen:(NSNotification *)notification {
    UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
    if (interfaceOrientation == UIInterfaceOrientationPortrait || 
        interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [[bcPlayer backgroundView] setFrame:CGRectMake(0.0f, 0.0f, 768.0f, 432.0f)];
        [[bcPlayer backgroundView] setBackgroundColor:portraitBackground];
    } else {
        [[bcPlayer backgroundView] setFrame:CGRectMake(-205.0f, 0.0f, 1024.0f, 348.0f)];
        [[bcPlayer backgroundView] setBackgroundColor:landscapeBackground];
    }
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	// Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)saveTimeCode {
    NSTimeInterval stopTime = [bcPlayer currentPlaybackTime];
    if (isStreamingVideo && stopTime != 0.0) {
        // save it
        TimeCodeManager *manager = [[TimeCodeManager alloc] init];
        [manager saveTimeCode:stopTime forVideoId:[[self video] videoId]];
        [manager release];
    }
}
- (void)saveMediaPlayerState{
    [self saveTimeCode];
    
}

- (void)dealloc {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self 
                  name:MPMoviePlayerPlaybackStateDidChangeNotification 
                object:bcPlayer];
    [nc removeObserver:self 
                  name:MPMoviePlayerLoadStateDidChangeNotification 
                object:bcPlayer]; 
    [nc removeObserver:self 
                  name:MPMoviePlayerWillEnterFullscreenNotification
                object:bcPlayer]; 
    [nc removeObserver:self 
                  name:MPMoviePlayerDidExitFullscreenNotification
                object:bcPlayer]; 
    [nc removeObserver:self 
                  name:MPMoviePlayerPlaybackDidFinishNotification
                object:bcPlayer]; 
    
    [activityIndicator release];
    [bcPlayer release];
    [video release];
    [portraitBackground release];
    [landscapeBackground release];
    
    [super dealloc];
}


@end
