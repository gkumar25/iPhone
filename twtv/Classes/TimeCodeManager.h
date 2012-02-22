//
//  TimeCodeManager.h
//  twtv
//
//  Created by Gaurav Kumar on 4/4/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TimeCodeManager : NSObject {
@private
    NSMutableDictionary *timeCodes;
}

- (void)saveTimeCode:(NSTimeInterval)timecode forVideoId:(long long) videoId;
- (void)removeTimeCode:(long long) videoId;
- (NSTimeInterval)timeCodeForVideoId:(long long) videoId;

@end
