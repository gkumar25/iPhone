//
//  ErrorHandlerService.m
//  twtv
//
//  Created by Gaurav Kumar on 3/10/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
// and associated documentation files (the "Software"), to deal in the Software without restriction, 
// including without limitation the rights to use, copy, modify, merge, publish, distribute, 
// sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
// 
// 1.  The permission granted herein does not extend to commercial use of the Software by entities 
// primarily engaged in providing online video and related services; and
// 
// 2.  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING 
// BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ErrorHandlerService.h"
#import "twtvAppDelegate.h"

@implementation ErrorHandlerService

// track if we currently have a UIAlert erro view showing to avoid duplicate error messages
static BOOL isErrorDialogShowing = NO;



+ (ErrorHandlerService *) sharedInstance {
    // our singleton instance
    static ErrorHandlerService *sSharedInstance;
    
    @synchronized(self) {
        if (!sSharedInstance)  {
            sSharedInstance = [[ErrorHandlerService alloc] init];
        }
    }
    
    return sSharedInstance;
}

// single method to handle errors that happen as a result of the Media API
// we just log this to our log/console for now so that we could introspect the errors
// at a later point.
- (void)logMediaAPIError:(NSError *)error {
    if (!isErrorDialogShowing) {
        isErrorDialogShowing = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"We encountered a problem connecting to the Brightcove service, please try again later" 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
		
    }
}

// Once we have received a callback that the UIAlertView has been dismissed, we can reset our state
// to indicate no alert view is being shown
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    isErrorDialogShowing = NO;
}

@end
