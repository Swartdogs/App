//
//  SDMatchStore.h
//  RecycleScout
//
//  Created by Srinivas Dhanwada on 1/6/14.
//  Made worse by Seth Harwood 1/27/15.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDMatch;

@interface SDMatchStore : NSObject {
    NSMutableArray *allMatches;
}

+ (SDMatchStore*) sharedStore;

- (NSArray*) allMatches;
- (SDMatch*) createMatch;
- (NSString*) csvFilePath;
- (NSString*) matchArchivePath;
- (void) removeMatch:(SDMatch*)thisMatch;
- (void) replaceMatch:(SDMatch*)oldMatch withMatch:(SDMatch*)newMatch;
- (BOOL) saveChanges;
- (void) writeCSVFile;

@end
