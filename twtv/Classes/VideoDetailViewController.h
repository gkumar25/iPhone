//
//  VideoDetailViewController.h
//  twtv
//
//  Created by Gaurav Kumar on 3/11/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCMediaAPI.h"
#import "BCVideo.h"
#import "Constants.h"
#import "ErrorHandlerService.h"
#import "twtvAppDelegate.h"
#import "BCItemCollection.h"
#import "AsynchronousImageView.h"

@protocol VideoDetailViewControllerDelegate

- (void)initSharingView:(BCVideo *) video;
- (void)relatedVideoSelected:(BCVideo *) video;

@end

@interface VideoDetailViewController : UIViewController <AsynchronousImageViewDelegate> {
	
    id <VideoDetailViewControllerDelegate> delegate;
    BCVideo *video;
    UILabel *videoDescription;
    UILabel *videoName;
    UILabel *videoViews;
    UILabel *videoDate;    
    UILabel *videoDuration; 
    UIButton *sharingButton;
    NSOperationQueue *operationQueue;
    AsynchronousImageView *firstRelatedVideoThumbnail;
    UILabel *firstRelatedVideoDesc;
    UILabel *firstRelatedVideoViews;
    UILabel *firstRelatedVideoDuration;    
    AsynchronousImageView *secondRelatedVideoThumbnail;
    UILabel *secondRelatedVideoDesc;
    UILabel *secondRelatedVideoViews;
    UILabel *secondRelatedVideoDuration;  
    UILabel *relatedVideosLabel;
    UIImageView *backgroundImage;
    UIView *firstRelatedVideoBackgroundImage;
    UIView *secondRelatedVideoBackgroundImage;
    UIActivityIndicatorView *loadSpinner;
    UIImage *portraitBackground;
    UIImage *landscapeBackground;
}

@property (nonatomic, retain) BCVideo *video;
@property (nonatomic, retain) IBOutlet UIButton *sharingButton;
@property (nonatomic, retain) IBOutlet UILabel *videoName;
@property (nonatomic, retain) IBOutlet UILabel *videoDuration;
@property (nonatomic, retain) IBOutlet UILabel *videoDescription;
@property (nonatomic, retain) IBOutlet AsynchronousImageView *firstRelatedVideoThumbnail;
@property (nonatomic, retain) IBOutlet AsynchronousImageView *secondRelatedVideoThumbnail;
@property (nonatomic, assign) id <VideoDetailViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *videoViews;
@property (nonatomic, retain) IBOutlet UILabel *videoDate;
@property (nonatomic, retain) IBOutlet UILabel *firstRelatedVideoDesc;
@property (nonatomic, retain) IBOutlet UILabel *firstRelatedVideoViews;
@property (nonatomic, retain) IBOutlet UILabel *firstRelatedVideoDuration;
@property (nonatomic, retain) IBOutlet UILabel *secondRelatedVideoDesc;
@property (nonatomic, retain) IBOutlet UILabel *secondRelatedVideoViews;
@property (nonatomic, retain) IBOutlet UILabel *secondRelatedVideoDuration;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) IBOutlet UIView *firstRelatedVideoBackgroundImage;
@property (nonatomic, retain) IBOutlet UIView *secondRelatedVideoBackgroundImage;
@property (nonatomic, retain) IBOutlet UILabel *relatedVideosLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadSpinner;

- (void)setWithBCVideo:(BCVideo *) v;

- (IBAction)openSharingView;

- (void)animateRotation:(UIInterfaceOrientation)interfaceOrientation 
               duration:(NSTimeInterval )duration;

- (void)hideVideoDetailView;

//AsynchronousImageViewDelegate implementation
- (void)asynchronousImageViewWasTapped: (AsynchronousImageView *)tiv;

@end
