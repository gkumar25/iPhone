    //
//  ScrollCellViewController.m
//  twtv
//
//  Created by Gaurav Kumar on 3/11/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import "ScrollCellViewController.h"
#import "AsynchronousImageView.h"
#import "BCVideo.h"
#import "AppUtils.h"
#import <QuartzCore/QuartzCore.h>


@implementation ScrollCellViewController

@synthesize videoName;
@synthesize videoLength;
@synthesize videoThumbnail;
@synthesize imageBackground;
@synthesize selectedHighlight;
@synthesize video;
@synthesize delegate;


// The designated initializer.  Override if you create the controller programmatically and want to 
// perform customization that is not appropriate for viewDidLoad.
- (id)initWithBCVideo:(BCVideo *)v {
    if ((self = [super initWithNibName:@"ScrollCellView" bundle:nil])) {
        // Custom initialization
        [self setVideo:v];
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    BCVideo *currentVideo = [self video];
    
    [videoName setText:[currentVideo name]];
    
    [videoLength setText:[AppUtils formatVideoLengthToStandardTime:[currentVideo length]]];
    
    [videoThumbnail loadImageFromVideo:video];
}

- (IBAction)buttonTouchUpInside:(id)sender {
    [delegate scrollCellViewTouchUpInside:self];
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
    [self setVideoName:nil];
    [self setVideoLength:nil];
    [self setVideoThumbnail:nil];
    [self setImageBackground:nil];
    [self setSelectedHighlight:nil];
}

- (void)setSelected:(BOOL)state {
    if (state) {
        [UIView beginAnimations:@"deselect" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.15f];
        [imageBackground setFrame:CGRectMake(20.0f, 35.0f, 188.0f, 138.0f)];
        [selectedHighlight setFrame:CGRectMake(0.0f, 0.0f, 228.0f, 237.0f)];
        [selectedHighlight setAlpha:1.0f];
        [UIView commitAnimations];
    } else {
        [UIView beginAnimations:@"deselect" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.15f];
        [imageBackground setFrame:CGRectMake(23.0f, 38.0f, 182.0f, 132.0f)];
        [selectedHighlight setFrame:CGRectMake(0.0f, 20.0f, 228.0f, 237.0f)];
        [selectedHighlight setAlpha:0.0f];        
        [UIView commitAnimations];
    }
}

- (void)dealloc {
    [videoName release];
    [videoLength release];
    [videoThumbnail release];
    [imageBackground release];
    [selectedHighlight release];
    [video release];
    
    [super dealloc];
}


@end
