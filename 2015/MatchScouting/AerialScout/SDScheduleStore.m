//
//  SDScheduleStore.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/8/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDScheduleStore.h"
#import "SDSchedule.h"

@implementation SDScheduleStore

- (NSArray*) allSchedules {
    return allSchedules;
}

+ (id) allocWithZone:(NSZone *)zone {
    return [self sharedStore];
}

- (SDSchedule*) createSchedule {
    // Create and return a New Schedule
    
    SDSchedule* newSchedule = [[SDSchedule alloc] init];
    [allSchedules addObject:newSchedule];
    
    return newSchedule;
}

- (int) getSearchTeam {
    return searchTeam;
}

- (id) init {
    if(self = [super init]) {
        NSString* path = [self scheduleArchivePath];
        
        allSchedules = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!allSchedules) {
            allSchedules = [[NSMutableArray alloc] init];
            searchTeam = 0;
            [[NSUserDefaults standardUserDefaults] setInteger:searchTeam forKey:@"SearchTeamPrefKey"];
        } else {
            searchTeam = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"SearchTeamPrefKey"];
        }
    }
    
    return self;
}

- (BOOL) saveChanges {
    // Archive Match Array
    
    NSString* path = [self scheduleArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:allSchedules toFile:path];
}

- (void) setSearchTeam:(int)team {
    searchTeam = team;
    [[NSUserDefaults standardUserDefaults] setInteger:searchTeam forKey:@"SearchTeamPrefKey"];
}

- (void) removeAll {
    [allSchedules removeAllObjects];
    searchTeam = 0;
    [[NSUserDefaults standardUserDefaults] setInteger:searchTeam forKey:@"SearchTeamPrefKey"];
}

- (void) removeSchedule:(SDSchedule *)thisSchedule {
    [allSchedules removeObjectIdenticalTo:thisSchedule];
}

- (NSString*) scheduleArchivePath {
    // Return path to application document filder with Archive File name
    
    NSArray* documentFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentFolder = [documentFolders objectAtIndex:0];
    
    return [documentFolder stringByAppendingPathComponent:@"Schedule.archive"];
}

+ (SDScheduleStore*) sharedStore {
    // Get singleton instance of Schedule Store
    
    static SDScheduleStore* sharedStore = nil;
    
    if(!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

@end
