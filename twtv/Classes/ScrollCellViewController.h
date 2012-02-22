//
//  ScrollCellViewController.h
//  twtv
//
//  Created by Gaurav Kumar on 3/11/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsynchronousImageView;
@class BCVideo;
@protocol ScrollCellViewDelegate;

@interface ScrollCellViewController : UIViewController {
    IBOutlet UILabel *videoName;
    IBOutlet UILabel *videoLength;
    IBOutlet AsynchronousImageView *videoThumbnail;
    IBOutlet UIView *imageBackground;
    IBOutlet UIImageView *selectedHighlight;
    BCVideo *video;
    id<ScrollCellViewDelegate> delegate;
}

@property(nonatomic, retain) UILabel *videoName;
@property(nonatomic, retain) UILabel *videoLength;
@property(nonatomic, retain) AsynchronousImageView *videoThumbnail;
@property(nonatomic, retain) UIView *imageBackground;
@property(nonatomic, retain) UIImageView *selectedHighlight;
@property(nonatomic, retain) BCVideo *video;
@property(nonatomic, assign) id<ScrollCellViewDelegate> delegate;

- (id)initWithBCVideo:(BCVideo *)v;
- (void)setSelected:(BOOL)state;
- (IBAction)buttonTouchUpInside:(id)sender;

@end

@protocol ScrollCellViewDelegate

- (void)scrollCellViewTouchUpInside:(id)sender;

@end

