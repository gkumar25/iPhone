//
//  ChanelViewController.h
//  twtv
//
//  Created by Gaurav Kumar on 3/16/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCVideo.h";
#import "Constants.h";
#import "ErrorHandlerService.h"
#import "VideoDetailViewController.h";
#import "MoviePlayerViewController.h";
#import "BCSharingViewController.h"

@class BCPlaylist;
@class AsynchronousImageView;


@protocol ScrollingPlaylistViewDelegate; 

@interface ChanelViewController : UITableViewController <VideoDetailViewControllerDelegate, 
BCSharingViewDelegate,
MoviePlayerViewControllerDelegate> {

	
	MoviePlayerViewController *moviePlayerViewController;
	VideoDetailViewController *videoDetailViewController;
	IBOutlet UIView *imageBackground;
    IBOutlet UIImageView *selectedHighlight; 
	BCSharingViewController *sharingViewController;
	BCPlaylist *featuredPlaylist;

	NSOperationQueue *operationQueue;
	BCVideo *currentVideo;
	IBOutlet UITableViewCell *videocell;
}

@property(nonatomic, retain) BCPlaylist *featuredPlaylist;

// @property (nonatomic, retain) BCVideo *currentVideo;
// @property(nonatomic, retain) UILabel *videoName;
// @property(nonatomic, retain) UILabel *videoLength;
// @property(nonatomic, retain) AsynchronousImageView *videoThumbnail;
@property (nonatomic, retain) MoviePlayerViewController *moviePlayerViewController;
@property (nonatomic, retain) VideoDetailViewController *videoDetailViewController;
@property(nonatomic, retain) UIView *imageBackground;
@property(nonatomic, retain) UIImageView *selectedHighlight;
// @property(nonatomic, retain) BCVideo *video;
@property (nonatomic, retain) BCSharingViewController *sharingViewController;


// VideoDetailViewControllerDelegate methods 
- (void)initSharingView:(BCVideo *) video;
- (void)relatedVideoSelected:(BCVideo *) video;
- (void)startCallToServer;
- (void)centerSharingView:(UIInterfaceOrientation)interfaceOrientation;


//- (void)startCallToServer;
// - (void)fetchPlaylistById;
@end
