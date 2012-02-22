//
//  MoviePlayerViewController.h
//  twtv
//
//  Created by Gaurav Kumar on 3/11/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BCMoviePlayerController.h"
#import <MediaPlayer/MediaPlayer.h>
@class BCVideo;
@class ChanelViewController;

@protocol MoviePlayerViewControllerDelegate;


@interface MoviePlayerViewController: UIViewController {
	
	BCMoviePlayerController *bcPlayer;
	MPMoviePlayerController *moviePlayer;
    BCVideo *video;
    UIActivityIndicatorView *activityIndicator;
    id<MoviePlayerViewControllerDelegate> delegate;
    BOOL shouldAutoPlay;
    UIColor *portraitBackground;
    UIColor *landscapeBackground;
    BOOL isStreamingVideo;
	ChanelViewController *chanel;
}
@property (nonatomic, retain) ChanelViewController *chanel; 
@property (nonatomic, retain) BCVideo *video;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) id<MoviePlayerViewControllerDelegate> delegate;

- (void)setWithBCVideo:(BCVideo *) v;
- (void)animateRotation: (UIInterfaceOrientation) interfaceOrientation 
               duration:(NSTimeInterval )duration;
- (void)saveMediaPlayerState;
- (void)saveTimeCode;

@end

@protocol MoviePlayerViewControllerDelegate

- (void)playNextVideo:(id)sender;
- (void)playPreviousVideo:(id)sender;

@end

