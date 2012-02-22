//
//  AsynchronousImageView.m
//  twtv
//
//  Created by Gaurav Kumar on 4/4/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import "AsynchronousImageView.h"

@implementation AsynchronousImageView


@synthesize video;
@synthesize delegate;

- (void)loadImageFromVideo:(BCVideo *)bcVideo {
	
    [self setVideo:bcVideo];
	// Cache the thumbnail image but revalidate it with NSURLRequestReloadRevalidatingCacheData
	// in the case the video thumbnail has been changed in the Brightcove Media Manager
	// since the last time the app was loaded.
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.video.thumbnailURL] 
											 cachePolicy:NSURLRequestReloadRevalidatingCacheData 
										 timeoutInterval:30.0];
	
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)theConnection 
	didReceiveData:(NSData *)incrementalData {
    if (data == nil) {
		data = [[NSMutableData alloc] initWithCapacity:2048]; 
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{
    [self setImage:[UIImage imageWithData:data]];
    [data release], data = nil;
	[connection release], connection = nil;
}

//TODO: Add error handling for connection. 

// Let others know that the image was tapped. 
// The BCVideo will be available to the responser
// since it has been added to this class. 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
    [[self delegate] asynchronousImageViewWasTapped:self];
    
}

- (void)dealloc {
	[data release];
	[connection release];
    [video release];
    [super dealloc];
}

@end