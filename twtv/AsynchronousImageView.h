//
//  AsynchronousImageView.h
//  twtv
//
//  Created by Gaurav Kumar on 4/4/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BCVideo.h"

@protocol AsynchronousImageViewDelegate; 

@interface AsynchronousImageView : UIImageView {
    NSURLConnection *connection;
    id <AsynchronousImageViewDelegate> delegate;
    NSMutableData *data;
    BCVideo *video;
    
}

@property (nonatomic, retain) BCVideo *video;
@property (nonatomic, assign) id <AsynchronousImageViewDelegate> delegate;

- (void)loadImageFromVideo:(BCVideo *)video;


@end

@protocol AsynchronousImageViewDelegate <NSObject>

- (void)asynchronousImageViewWasTapped:(AsynchronousImageView *) tiv;

@end
