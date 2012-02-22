//
//  ChanelViewController.m
//  twtv
//
//  Created by Gaurav Kumar on 3/16/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import "ChanelViewController.h"
#import "BCPlaylist.h"
#import "BCVideo.h"
#import "ScrollCellViewController.h"
#import "AsynchronousImageView.h";
#import "twtvAppDelegate.h"
#import "AppUtils.h"
#import "MoviePlayerViewController.h";
#import "VideoDetailViewController.h";

@implementation ChanelViewController

@synthesize featuredPlaylist;
@synthesize imageBackground;
@synthesize selectedHighlight;

@synthesize moviePlayerViewController;
@synthesize videoDetailViewController;
@synthesize sharingViewController;
 


#pragma mark -
#pragma mark Initialization


/* - (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

	BrightcoveLibrary *bcove =[[BrightcoveLibrary alloc] retain];
	// [bcove fetchPlaylistById];
	[bcove startCallToServer];
	
	
	if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/



#pragma mark -
#pragma mark View lifecycle

- (void)startCallToServer {
	
    twtvAppDelegate *onePlanetDelegate = (twtvAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// init our operation queue
	operationQueue = onePlanetDelegate.operationQueue;
	
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
                                        initWithTarget:self 
                                        selector:@selector(fetchPlaylistById) 
                                        object:nil];
    
	[operationQueue addOperation:operation];
	[operation release];
}

- (void)fetchPlaylistById {
	
	NSAutoreleasePool * threadPool = [[NSAutoreleasePool alloc] init] ;
	
	twtvAppDelegate *onePlanerDelegate = (twtvAppDelegate *)
	[[UIApplication sharedApplication] delegate];
    
	BCMediaAPI *bc = onePlanerDelegate.bcServices;
	
	NSError *err = NULL;
	featuredPlaylist = [bc findPlaylistById:FEATURED_PLAYLIST  
								videoFields:[NSArray 
											 arrayWithObjects:@"id", @"FLVURL", 
                                             @"thumbnailURL", @"name", @"playsTotal", 
                                             @"publishedDate", @"length",
											 @"longDescription", @"renditions", nil] 
							 playlistFields:[NSArray arrayWithObjects:@"name", @"videos", nil] 
							   customFields:nil error:&err];
	
	
    if (!featuredPlaylist) {
        NSLog(@"Error, featuredPlaylist is null: %@", err);
    }
    
	// the Media API error'd out, call 
	if (!featuredPlaylist) {
		[[ErrorHandlerService sharedInstance] logMediaAPIError:err];
	}
	
	[featuredPlaylist retain];

	[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES]; 
	
	
	 [threadPool release] ;					
}





- (void)viewDidLoad {
    
   [super viewDidLoad];
	self.title = @"videos";
	[self startCallToServer];
	
	
}



/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return featuredPlaylist.videos.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"video";
    // BrightcoveLibrary bcove =[[BrightcoveLibrary alloc] init];
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	      if (cell == nil) {
          //    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	      [[NSBundle mainBundle] loadNibNamed:@"video" owner:self options:nil]; 
		  cell = videocell;
	      }
       
		// Configure the cell..   
	
	 NSString *video_url = [[[featuredPlaylist videos] objectAtIndex:indexPath.row] FLVURL];
	 //if ([video_url hasSuffix:@".MP4"]) {
	  
	  UILabel* videoName = (UILabel*) [cell viewWithTag:1]; 
	  currentVideo = (BCVideo *) [[featuredPlaylist videos] objectAtIndex:indexPath.row]; 
	  NSString *video_name = [[[featuredPlaylist videos] objectAtIndex:indexPath.row] name];
	  [videoName setText:(NSString *) video_name];
		
	  UILabel* videoLength = (UILabel*) [cell viewWithTag:2];
      [videoLength setText:[AppUtils formatVideoLengthToStandardTime:[currentVideo length]]];
		
	  AsynchronousImageView* videoThumbnail = (AsynchronousImageView*) [cell viewWithTag:3];
	  [videoThumbnail loadImageFromVideo:currentVideo];
		  
	  //}	
		

		return cell;
	
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 DetailViewController *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
	 
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
		
	
	MoviePlayerViewController *moviecontroller = [[MoviePlayerViewController alloc] init];
	VideoDetailViewController *videocontroller = [[VideoDetailViewController alloc] init];
	//moviecontroller.chanel = self;
	//FeaturedViewController *feature = [[FeaturedViewController alloc] initWithNibName:@"feature" bundle:nil];
	//twtvAppDelegate *theDelegate = (twtvAppDelegate *)[[UIApplication sharedApplication] delegate];
	[moviecontroller setWithBCVideo:currentVideo];
	
	// [self setViewsWithBCVideo:currentVideo];
	[self.navigationController pushViewController:moviecontroller animated:YES];
	 
	[moviecontroller release];
}



// Open Sharing view
- (void) initSharingView:(BCVideo *) video {
	
	
	 NSLog(@"init sharing");
    
    if ([self sharingViewController] != nil){
        return;
    }
    BCSharingViewController *sharingView = [[BCSharingViewController alloc] init];
    [self setSharingViewController:sharingView];
    [sharingView release];
    [[self sharingViewController] setVideo:video];
    [[self sharingViewController] setSharingPlayerId:5843654001LL];
    [[self sharingViewController] setDelegate:self];
    [[[self sharingViewController] view] setAlpha:0.0f];
    [self centerSharingView:[self interfaceOrientation]];
    [[self view] addSubview:[[self sharingViewController] view]];
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [[[self sharingViewController] view] setAlpha:1.0f];
    [UIView commitAnimations];
	
    
}

- (void)closeSharingView {
    
    [UIView beginAnimations:@"fadeOut" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [[[self sharingViewController] view] setAlpha:0.0f];
    [UIView commitAnimations];
    [self setSharingViewController:nil];
    
}

- (void)relatedVideoSelected:(BCVideo *) video {
   // [self setViewsWithBCVideo:video];
    // [scrollingPlaylistView highlightCellWithVideoId:[video videoId]];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
                                         duration:(NSTimeInterval)duration {
    
    [self centerSharingView:interfaceOrientation];
    
    [videoDetailViewController animateRotation:interfaceOrientation duration:duration];
    [moviePlayerViewController animateRotation:interfaceOrientation duration:duration];
  //  [scrollingPlaylistView animateRotation:interfaceOrientation duration:duration];    
    
}

- (void)centerSharingView:(UIInterfaceOrientation)interfaceOrientation {
	
    if ( [[self sharingViewController] view] != nil ) {
        
        if (interfaceOrientation == UIInterfaceOrientationPortrait || 
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            [[[self sharingViewController] view] setFrame:CGRectMake(243.0f,
                                                                     50.0f,
                                                                     BC_SHARING_VIEW_WIDTH,
                                                                     BC_SHARING_VIEW_HEIGHT)];
        } else {
            [[[self sharingViewController] view] setFrame:CGRectMake(391.0f,
                                                                     20.0f,
                                                                     BC_SHARING_VIEW_WIDTH,
                                                                     BC_SHARING_VIEW_HEIGHT)];
        }
        
    }
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished 
				 context:(void *)context {
    
    if ([animationID isEqualToString:@"fadeOut"]) {
        [[[self sharingViewController] view] removeFromSuperview];
    }
    
}

- (UIViewController *)viewControllerToPresentEmailCompose {
    return self;
}

- (BOOL)shouldAnimateEmailComposePresentation {
    return YES;
}

- (BOOL) shouldExitApplicationToSendEmail {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)videoSelectedFromPlaylist:(BCVideo *)video {
   // [self setViewsWithBCVideo:video];
}

- (void)playNextVideo:(id)sender {
    // [scrollingPlaylistView selectNextVideo];
}

- (void)playPreviousVideo:(id)sender {
    // [scrollingPlaylistView selectPreviousVideo];
}





#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

