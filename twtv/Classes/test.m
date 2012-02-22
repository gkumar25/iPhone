    //
//  test.m
//  twtv
//
//  Created by Gaurav Kumar on 3/26/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import "test.h"
#import <MediaPlayer/MPMoviePlayerController.h>


@implementation test

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"test2" ofType:@"mp4"];
	NSURL *url = [NSURL fileURLWithPath:urlStr];
	moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
	
	
	 moviePlayer.view.frame = CGRectMake(10, 10, 300, 300);  
	[self.view addSubview:moviePlayer.view];
	[moviePlayer play];
	
	NSLog(@"video: %@",url);

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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


- (void)dealloc {
    [super dealloc];
}


@end
