//
//  AppUtils.m
//  twtv
//
//  Created by Gaurav Kumar on 4/4/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import "AppUtils.h"


@implementation AppUtils 

// Formats the video length given in milliseconds to a standard time format
// of mm:ss

+ (NSString *)formatVideoLengthToStandardTime:(long long)videoLength {
    //mm:ss
    NSString *standardTime = nil;
    
    long long videoSeconds = floorl(videoLength/1000);
    
    standardTime = [NSString stringWithFormat:@"%02qi:%02qi", 
                    (videoSeconds)/60, videoSeconds%60];
    return standardTime;
    
}


@end
