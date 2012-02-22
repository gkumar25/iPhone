//
//  ScrollingPlaylistViewController.h
//  twtv
//
//  Created by Gaurav Kumar on 3/11/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollCellViewController.h"

@class BCPlaylist;

@protocol ScrollingPlaylistViewDelegate;

@interface ScrollingPlaylistViewController : UIViewController <ScrollCellViewDelegate> {
    UIScrollView *scrollView;
    BCPlaylist *playlist;
    NSMutableArray *cellsArray;
@private
    ScrollCellViewController *selectedScrollCellView;
    id<ScrollingPlaylistViewDelegate> delegate;
}

@property(nonatomic, assign) id<ScrollingPlaylistViewDelegate> delegate;

- (void)setData:(BCPlaylist *)list;
- (void)selectNextVideo;
- (void)selectPreviousVideo;
- (void)highlightCellWithVideoId:(long long) videoId;
- (void)animateRotation:(UIInterfaceOrientation)interfaceOrientation 
			   duration:(NSTimeInterval)duration;

@end

@protocol ScrollingPlaylistViewDelegate

- (void)videoSelectedFromPlaylist:(BCVideo *)video; 

@end
