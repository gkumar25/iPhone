//
//  TimeCodeManager.m
//  twtv
//
//  Created by Gaurav Kumar on 4/4/11.
//  Copyright 2011 Bonnier Corporation. All rights reserved.
//

#import "TimeCodeManager.h"

@interface TimeCodeManager (Private)
- (NSMutableDictionary *)timeCodes;
- (BOOL)saveTimeCodesToFile;
- (NSString *)convertVideoIdToKeyString:(long long) videoId;
@end

@implementation TimeCodeManager

- (id)init {
    if (self = [super init]) {
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                                  NSUserDomainMask, 
                                                                  YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"TimeCodes.plist"];
        NSURL *timeCodesURL = [[NSURL alloc] initFileURLWithPath:plistPath];
        timeCodes = [[NSMutableDictionary alloc] initWithContentsOfURL:timeCodesURL]; 
        [timeCodesURL release];
        
        if (!timeCodes) {
            timeCodes = [[NSMutableDictionary alloc] init]; 
        }
    }
    
    return self;
}

/**
 Public method for saving a time code value for a videoId
 */
- (void)saveTimeCode:(NSTimeInterval)timecode forVideoId:(long long) videoId {
    NSNumber *time = [[NSNumber alloc] initWithDouble:timecode];
    [timeCodes setObject:time forKey:[self convertVideoIdToKeyString:videoId]];
    [time release];
    
    BOOL succes = [self saveTimeCodesToFile];
    if (!succes) {
        // hmmm >:
    }
}

/**
 Removes video's timeCode from the dictionary.
 Called when video completes.
 */
- (void)removeTimeCode:(long long) videoId {
    
    [timeCodes removeObjectForKey:[self convertVideoIdToKeyString:videoId]];
    BOOL succes = [self saveTimeCodesToFile];
    if (!succes) {
        // hmmm >:
    }
}

/**
 Returns the time code value for the videoId
 */
- (NSTimeInterval)timeCodeForVideoId:(long long) videoId {
    NSNumber *num = [timeCodes objectForKey:[self convertVideoIdToKeyString:videoId]];
    return (NSTimeInterval)[num doubleValue];
}

/**
 Saves the NSDictionary stored in the ivar timeCodes
 */
- (BOOL)saveTimeCodesToFile {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                              NSUserDomainMask, 
                                                              YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"TimeCodes.plist"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:plistPath];
    BOOL success = [timeCodes writeToURL:url atomically:YES];
    [url release];
    
    return success;
}

/**
 Converts the videoId long long value to an NSString
 */
- (NSString *)convertVideoIdToKeyString:(long long) videoId {
    NSString *idKey = [[[NSString alloc] initWithFormat:@"%lld", videoId] autorelease];
    
    return idKey;
}

/**
 
 */
- (void)dealloc {
    [timeCodes release];
    
    [super dealloc];
}

@end
