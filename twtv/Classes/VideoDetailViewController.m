    //
//  VideoDetailViewController.m
//  twtv
//
//  Created by Gaurav Kumar on 3/11/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "AppUtils.h"


@implementation VideoDetailViewController
@synthesize video;
@synthesize videoDescription;
@synthesize videoDuration;
@synthesize videoName;
@synthesize sharingButton;
@synthesize firstRelatedVideoThumbnail;
@synthesize secondRelatedVideoThumbnail;
@synthesize videoViews;
@synthesize videoDate;
@synthesize firstRelatedVideoDesc;
@synthesize firstRelatedVideoViews;
@synthesize firstRelatedVideoDuration;
@synthesize secondRelatedVideoDesc;
@synthesize secondRelatedVideoViews;
@synthesize secondRelatedVideoDuration;
@synthesize delegate;
@synthesize backgroundImage;
@synthesize firstRelatedVideoBackgroundImage;
@synthesize secondRelatedVideoBackgroundImage;
@synthesize relatedVideosLabel;
@synthesize loadSpinner;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"view load");
    [loadSpinner setHidesWhenStopped:YES];    
    [loadSpinner startAnimating];
    [firstRelatedVideoThumbnail setDelegate:self];
    [secondRelatedVideoThumbnail setDelegate:self];
    [self hideVideoDetailView];
    
    portraitBackground = [[UIImage imageNamed:@"img_videoinfobg_port.png"] retain];
    landscapeBackground = [[UIImage imageNamed:@"img_videoinfobg_land.png"] retain];
    
    [self animateRotation:[self interfaceOrientation] duration:0.0f];
}

- (void)hideVideoDetailView {
    
    [[self videoDescription] setAlpha:0.0f];
    [[self videoDuration] setAlpha:0.0f];
    [[self videoDate] setAlpha:0.0f];
    [[self videoViews] setAlpha:0.0f];
    [[self videoName] setAlpha:0.0f];
    [[self firstRelatedVideoDesc] setAlpha:0.0f];
    [[self firstRelatedVideoDuration] setAlpha:0.0f];
    [[self firstRelatedVideoThumbnail] setAlpha:0.0f];
    [[self firstRelatedVideoViews] setAlpha:0.0f];
    [[self firstRelatedVideoBackgroundImage] setAlpha:0.0f];
    [[self secondRelatedVideoDesc] setAlpha:0.0f];
    [[self secondRelatedVideoDuration] setAlpha:0.0f];
    [[self secondRelatedVideoThumbnail] setAlpha:0.0f];
    [[self secondRelatedVideoViews] setAlpha:0.0f];
    [[self secondRelatedVideoBackgroundImage] setAlpha:0.0f];
    [[self relatedVideosLabel] setAlpha:0.0f];
	
}

- (void)setWithBCVideo:(BCVideo *) v {
	
	NSLog(@"setvideo");
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle]; 
    
    [self setVideo:v];	
    
    /*[[self videoDescription] setText:[[self video] longDescription]];
    [[self videoDuration] setText:[AppUtils formatVideoLengthToStandardTime:[[self video] length]]]; 
    [[self videoName] setText:[[self video] name]];
    [[self videoViews] setText:
     [NSString stringWithFormat:@"%lld views", [[self video] playsTotal]]];
    [[self videoDate] setText:[formatter stringFromDate:[[self video] publishedDate]]]; 
	
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:2.0];
    [[self videoDescription] setAlpha:1.0f];
    [[self videoDuration] setAlpha:1.0f];
    [[self videoDate] setAlpha:1.0f];
    [[self videoViews] setAlpha:1.0f];
    [[self videoName] setAlpha:1.0f];
    [UIView commitAnimations];
    */
	
	/*twtvAppDelegate *onePlanetDelegate = (twtvAppDelegate *)
	[[UIApplication sharedApplication] delegate];
	
	// init our operation queue
	operationQueue = onePlanetDelegate.operationQueue;
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self 
																			selector:@selector(fetchRelatedVideos) object:nil];
	[operationQueue addOperation:operation];
	[operation release];
	*/
	
}
- (void)fetchRelatedVideos {	
	
	NSLog(@"fetchvideo");
	NSAutoreleasePool * threadPool = [[NSAutoreleasePool alloc] init] ;
	
	twtvAppDelegate *onePlanetDelegate = (twtvAppDelegate *)
	[[UIApplication sharedApplication] delegate];
	BCMediaAPI *bc = onePlanetDelegate.bcServices;
	
    NSArray *videoFields = [[NSArray alloc] initWithObjects:@"id", 
							@"FLVURL", 
							@"thumbnailURL", 
							@"name", 
							@"playsTotal", 
							@"shortDescription", 
							@"renditions",
							@"longDescription", 
							@"publishedDate",
							@"length",
							nil]; 
	NSError *err;
	BCItemCollection *relatedVideos = [bc findRelatedVideos:[[self video] videoId] 
												referenceId:[[self video] referenceId]
									               pageSize:2.0f 
                                                 pageNumber:0
                                               getItemCount:YES								
                                                videoFields:videoFields
                                               customFields:nil 
                                                      error:&err];
    [videoFields release];
    
	// the Media API error'd out, call 
	if (!relatedVideos) {
        NSLog(@"fetchRelatedVideos is null: %@", err);
        if ([err code] != 0) {
            [[ErrorHandlerService sharedInstance] logMediaAPIError:err];
        }
	} else {
        [self performSelectorOnMainThread:@selector(setRelatedBCVideos:) 
                               withObject:[relatedVideos items] waitUntilDone:NO];
    }
	
    
	[threadPool release];	
}

-(void) setRelatedBCVideos:(NSArray *) relatedVideos {
    
    if([relatedVideos count] == 0){
        
		[loadSpinner stopAnimating];
        return;
    }
	
	// Add the two first related videos.
    BCVideo *firstVideo =  (BCVideo *) [relatedVideos objectAtIndex:(0)];
    [[self firstRelatedVideoDesc] setText:[firstVideo shortDescription]];
    [[self firstRelatedVideoViews] setText:
     [NSString stringWithFormat:@"%lld views", [firstVideo playsTotal]]];    
    [[self firstRelatedVideoDuration] setText:
     [AppUtils formatVideoLengthToStandardTime:[firstVideo length]]];
    
    
    BCVideo *secondVideo =  (BCVideo *) [relatedVideos objectAtIndex:(1)];
    [[self secondRelatedVideoDesc] setText:[secondVideo shortDescription]];
    [[self secondRelatedVideoViews] setText:
     [NSString stringWithFormat:@"%lld views",[secondVideo playsTotal]]];
    [[self secondRelatedVideoDuration] setText:
     [AppUtils formatVideoLengthToStandardTime:[secondVideo length]]];
    
    
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:2.0];
	
    [[self firstRelatedVideoDesc] setAlpha:1.0f];
    [[self firstRelatedVideoDuration] setAlpha:1.0f];
    [[self firstRelatedVideoThumbnail] setAlpha:1.0f];
    [[self firstRelatedVideoViews] setAlpha:1.0f];
    [[self firstRelatedVideoBackgroundImage] setAlpha:1.0f];
    [[self secondRelatedVideoDesc] setAlpha:1.0f];
    [[self secondRelatedVideoDuration] setAlpha:1.0f];
    [[self secondRelatedVideoThumbnail] setAlpha:1.0f];
    [[self secondRelatedVideoViews] setAlpha:1.0f];
    [[self secondRelatedVideoBackgroundImage] setAlpha:1.0f];
    [[self relatedVideosLabel] setAlpha:1.0f];
    [UIView commitAnimations];
    
	
	// Load thumbnails asynchronously
	[firstRelatedVideoThumbnail loadImageFromVideo:firstVideo];
	[secondRelatedVideoThumbnail loadImageFromVideo:secondVideo];
	[loadSpinner stopAnimating];
}


- (IBAction)openSharingView {
    
    [[self delegate] initSharingView:[self video]];
}

// Called when a related video thumbnail has been tapped.
- (void)asynchronousImageViewWasTapped:(AsynchronousImageView *)tiv {
    [[self delegate] relatedVideoSelected:[tiv video]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)animateRotation:(UIInterfaceOrientation)interfaceOrientation 
               duration:(NSTimeInterval)duration {
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait || 
        interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		
        CGRect portraitFrame = CGRectMake(0.0f,432.0f, 768.0f, 222.0f);
        
        [[self view] setFrame:portraitFrame];
        
        [loadSpinner setCenter:CGPointMake(364.0f, 111.0f)];
        [backgroundImage setFrame:CGRectMake(0.0f, 0.0f, 768.0f, 222.0f)];
        [backgroundImage setImage:portraitBackground];
        
		
		 NSLog(@"animation");
        [[self videoDuration] setHidden:NO];
        [[self firstRelatedVideoDesc] setHidden:NO];
        [[self firstRelatedVideoDuration] setHidden:NO];
        [[self firstRelatedVideoThumbnail] setHidden:NO];
        [[self firstRelatedVideoViews] setHidden:NO];
        [[self firstRelatedVideoBackgroundImage] setHidden:NO];
        [[self secondRelatedVideoBackgroundImage] setHidden:NO]; 
        [[self secondRelatedVideoDesc] setHidden:NO];
        [[self secondRelatedVideoDuration] setHidden:NO];
        [[self secondRelatedVideoThumbnail] setHidden:NO];
        [[self secondRelatedVideoViews] setHidden:NO];
        [[self relatedVideosLabel] setHidden:NO];
        [[self videoName] setFrame:CGRectMake(20.0f,20.0f,283.0f,38.0f)];
        [[self videoName] setFont:[UIFont fontWithName:self.videoName.font.fontName size:24]]; 
        [[self videoDescription] setFrame:CGRectMake(20.0f,64.0f,315.0f,50.0f)];
        [[self videoDescription] setNumberOfLines:4];
        [[self videoDate] setFrame:CGRectMake(20.0f,130.0f,170.0f,14.0f)];
        [[self videoDate] setFont:[UIFont fontWithName:self.videoDate.font.fontName size:14]];
        [[self videoViews] setFrame:CGRectMake(20.0f,143.0f,57.0f,14.0f)];
        [[self videoViews] setFont:[UIFont fontWithName:self.videoViews.font.fontName size:14]];
        [[self sharingButton] setFrame: CGRectMake(20.0f,161.0f, 72.0f,37.0f)];
        
    }
    else {
		
        CGRect landscapeFrame = CGRectMake(0.0f,349.0f,1024.0f,53.0f);
        
        [[self view] setFrame:landscapeFrame];
        
        [loadSpinner setCenter:CGPointMake(512.0f, 10.0f)];
        
        [backgroundImage setFrame:CGRectMake(0.0f, 0.0f, 1024.0f, 53.0f)];
        [backgroundImage setImage:landscapeBackground];
		
        [[self videoDuration] setHidden:YES];
        [[self firstRelatedVideoDesc] setHidden:YES];
        [[self firstRelatedVideoDuration] setHidden:YES];
        [[self firstRelatedVideoThumbnail] setHidden:YES];
        [[self firstRelatedVideoViews] setHidden:YES];
        [[self firstRelatedVideoBackgroundImage] setHidden:YES];
        [[self secondRelatedVideoBackgroundImage] setHidden:YES]; 
        [[self secondRelatedVideoDesc] setHidden:YES];
        [[self secondRelatedVideoDuration] setHidden:YES];
        [[self secondRelatedVideoThumbnail] setHidden:YES];
        [[self secondRelatedVideoViews] setHidden:YES];
        [[self relatedVideosLabel] setHidden:YES];
        [[self videoName] setFrame:CGRectMake(20.0f,0.0f,180.0f,50.0f)]; 
        [[self videoName] setFont:[UIFont fontWithName:self.videoName.font.fontName size:14]]; 
        [[self videoDescription] setNumberOfLines:1];
        [[self videoDescription] setFrame:CGRectMake(205.0f,5.0f,450.0f,40.0f)];
        [[self videoDate] setFrame:CGRectMake(750.0f,0.0f,80.0f,50.0f)];
        [[self videoDate] setFont:[UIFont fontWithName:self.videoDate.font.fontName size:12]];
        [[self videoViews] setFrame:CGRectMake(840.0f,0.0f,80.0f,50.0f)];
        [[self videoViews] setFont:[UIFont fontWithName:self.videoViews.font.fontName size:12]];      
        [[self sharingButton] setFrame:CGRectMake(930.0f,10.0f,72.0f,37.0f)];
        
    }
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
    [self setLoadSpinner:nil];
    [self setVideoDescription:nil];
    [self setVideoName:nil];
    [self setVideoViews:nil];
    [self setVideoDate:nil];
    [self setVideoDuration:nil];
    [self setSharingButton:nil];
    [self setFirstRelatedVideoThumbnail:nil];
    [self setFirstRelatedVideoDesc:nil];
    [self setFirstRelatedVideoViews:nil];
    [self setFirstRelatedVideoDuration:nil];
    [self setSecondRelatedVideoThumbnail:nil];
    [self setSecondRelatedVideoDesc:nil];
    [self setSecondRelatedVideoViews:nil];
    [self setSecondRelatedVideoDuration:nil];
    [self setRelatedVideosLabel:nil];
    [self setBackgroundImage:nil];
}


- (void)dealloc {
    [loadSpinner release];
    [operationQueue release];
    [video release];
    [videoDescription release];
    [videoName release];
    [videoViews release];
    [videoDate release];
    [videoDuration release];
    [sharingButton release];
    [firstRelatedVideoThumbnail release];
    [firstRelatedVideoDesc release];
    [firstRelatedVideoViews release];
    [firstRelatedVideoDuration release];
    [firstRelatedVideoBackgroundImage release];
    [secondRelatedVideoBackgroundImage release];
    [secondRelatedVideoThumbnail release];
    [secondRelatedVideoDesc release];
    [secondRelatedVideoViews release];
    [secondRelatedVideoDuration release];
    [relatedVideosLabel release];
    [backgroundImage release];
    [portraitBackground release];
    [landscapeBackground release];
    
    [super dealloc];
}


@end
