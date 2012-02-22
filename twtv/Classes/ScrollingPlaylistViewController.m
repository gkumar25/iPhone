    //
//  ScrollingPlaylistViewController.m
//  twtv
//
//  Created by Gaurav Kumar on 3/11/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import "ScrollingPlaylistViewController.h"
#import "BCPlaylist.h"
#import "BCVideo.h"
#import "ScrollCellViewController.h"


@interface ScrollingPlaylistViewController()

@property(nonatomic, retain) BCPlaylist *playlist;

@end

@implementation ScrollingPlaylistViewController

@synthesize playlist;
@synthesize delegate;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	 NSLog(@"view loding");
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    UIColor *bgColor = [[UIColor alloc] initWithPatternImage:
                        [UIImage imageNamed:@"img_videothumbsbg_port.png"]];
    [v setBackgroundColor:bgColor];
    [bgColor release];
    [self setView:v];
    [v release];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [scrollView setDelaysContentTouches:YES];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:YES];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [[self view] addSubview:scrollView];
    
    [self animateRotation:[self interfaceOrientation] duration:0.0f];
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)animateRotation:(UIInterfaceOrientation)interfaceOrientation 
               duration:(NSTimeInterval)duration {
    if (interfaceOrientation == UIInterfaceOrientationPortrait || 
        interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        UIView *v = [self view];
        [v setFrame:CGRectMake(0.0f, 654.0f, 768.0f, 251.0f)];
        [scrollView setFrame:CGRectMake(0.0f, 5.0f, 768.0f, 251.0f)];
    } else {
        UIView *v = [self view];
        [v setFrame:CGRectMake(0.0f, 402.0f, 1024.0f, 251.0f)];
        [scrollView setFrame:CGRectMake(0.0f, 5.0f, 1024.0f, 251.0f)];        
    }
	
}

- (void)selectNextVideo {
    NSUInteger currentVideoIndex = [cellsArray indexOfObject:selectedScrollCellView];
    ScrollCellViewController *nextVideo;
    if (currentVideoIndex == [cellsArray count] - 1) {
        nextVideo = [cellsArray objectAtIndex:0];
    } else {
        nextVideo = [cellsArray objectAtIndex:currentVideoIndex + 1];
    }
	
    [self scrollCellViewTouchUpInside:nextVideo];
}

- (void)selectPreviousVideo {
    NSUInteger currentVideoIndex = [cellsArray indexOfObject:selectedScrollCellView];
    ScrollCellViewController *nextVideo;
    if (currentVideoIndex == 0) {
        nextVideo = [cellsArray lastObject];
    } else {
        nextVideo = [cellsArray objectAtIndex:currentVideoIndex - 1];
    }
	
    [self scrollCellViewTouchUpInside:nextVideo];
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

- (void)renderPlaylist {
    cellsArray = [[NSMutableArray alloc] initWithCapacity:8];
    
    CGFloat xPos = 10.0f;
    BOOL firstCellDrawn = NO;
    for (BCVideo *video in [[self playlist] videos]) {
        ScrollCellViewController *cell = [[ScrollCellViewController alloc] initWithBCVideo:video];
        [cell setDelegate:self];
        [[cell view] setFrame:CGRectMake(xPos, 0.0f, 220.0f, 237.0f)];
        [scrollView addSubview:[cell view]];
        [cellsArray addObject:cell];
        if (!firstCellDrawn) {
            firstCellDrawn = YES;
            [self scrollCellViewTouchUpInside:cell];
        }
        [cell release];
        xPos += 220.0f;
    }
    
    CGSize size = CGSizeMake(xPos + 10.0f, 237.0f);
    [scrollView setContentSize:size];
}

- (void)scrollCellViewTouchUpInside:(id)sender {
    if (selectedScrollCellView) {
        [selectedScrollCellView setSelected:NO];
    }
    selectedScrollCellView = (ScrollCellViewController *)sender;
    [selectedScrollCellView setSelected:YES];
    
    [scrollView scrollRectToVisible:[[selectedScrollCellView view] frame] animated:YES];
    
    [delegate videoSelectedFromPlaylist:[selectedScrollCellView video]];
}

- (void)setData:(BCPlaylist *)list {
    [self setPlaylist:list];
    [self renderPlaylist];
}

- (void)highlightCellWithVideoId:(long long) videoId {
    if (selectedScrollCellView) {
        [selectedScrollCellView setSelected:NO];
    }
    
    for (ScrollCellViewController *cell in cellsArray) {
        if ([[cell video] videoId] == videoId) {
            selectedScrollCellView = cell;
            [selectedScrollCellView setSelected:YES];
            [scrollView scrollRectToVisible:[[selectedScrollCellView view] frame] animated:YES];
            break;
        }
    }
}

- (void)dealloc {
    [scrollView release];
    [cellsArray release];
    
    [super dealloc];
}


@end
