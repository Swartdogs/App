//
//  SDMatchStore.m
//  RecycleScout
//
//  Created by Srinivas Dhanwada on 1/6/14.
//  Made worse by Seth Harwood 1/27/15.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDMatchStore.h"
#import "SDMatch.h"

@implementation SDMatchStore

- (NSArray*) allMatches {
    return allMatches;
}

+ (id) allocWithZone:(NSZone *)zone {
    return [self sharedStore];
}

- (id) init {
    if(self = [super init]) {
        //Get match.archive path
        NSString *path = [self matchArchivePath];
        
        // Load matches from archive file
        allMatches = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If no matches in file, create empty array
        if (!allMatches) allMatches = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (SDMatch*) createMatch {
    // Create and return a New Match
    
    SDMatch *newMatch = [[SDMatch alloc] init];
    [allMatches addObject:newMatch];
    
    return newMatch;
}

- (NSString*) csvFilePath {
    // Return Path to application DOcument Folder with CSV File name
    NSArray* documentFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                   NSUserDomainMask, YES);
    
    NSString* documentFolder = [documentFolders objectAtIndex:0];
    
    UIDevice* device = [[UIDevice alloc] init];
    NSString* myDevice = [NSString stringWithFormat:@"Match data - %@.csv", [device name]];
    
    return [documentFolder stringByAppendingPathComponent:myDevice];
    
}

- (NSString*) matchArchivePath {
    // REturn path to application document folder with archive file name
    
    NSArray* documentFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                   NSUserDomainMask, YES);
    
    NSString* documentFolder = [documentFolders objectAtIndex:0];
    
    return [documentFolder stringByAppendingPathComponent:@"Match.archive"];
}

- (void) removeMatch:(SDMatch *)thisMatch {
    // Remove thisMatch
    
    [allMatches removeObjectIdenticalTo:thisMatch];
    [self saveChanges];
}

- (void) replaceMatch:(SDMatch *)oldMatch withMatch:(SDMatch *)newMatch {
    NSUInteger matchIndex = [allMatches indexOfObjectIdenticalTo:oldMatch];
    [allMatches replaceObjectAtIndex:matchIndex withObject:newMatch];
}

- (BOOL) saveChanges {
    // Write Match Array to CSV File
    
    [self writeCSVFile];
    
    NSString* path = [self matchArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:allMatches toFile:path];
}

+ (SDMatchStore*) sharedStore {
    // Get singleton instance of Match Store
    
    static SDMatchStore* sharedStore = nil;
    
    if(!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

- (void) writeCSVFile {
    // Create String and add Header
    
    UIDevice* device = [[UIDevice alloc] init];
    
    NSString *myDevice = [NSString stringWithFormat:@"%@ \r\n", [device name]];
    
    NSMutableString *csvFileString = [NSMutableString string];
    
    [csvFileString appendString:myDevice];
    [csvFileString appendString:[SDMatch writeHeader]];
    
    // Add each match to the String
    
    for (SDMatch* match in allMatches) {
        if (match.isCompleted == 31) {
            [csvFileString appendString:[match writeMatch]];
        }
    }
    
    // Write string to the CSV File
    
    [csvFileString writeToFile:[self csvFilePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
