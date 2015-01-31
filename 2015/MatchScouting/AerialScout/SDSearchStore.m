//
//  SDSearchStore.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 3/24/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDSearchStore.h"
#import "SDSearch.h"
#import "SDScheduleStore.h"
#import "SDSchedule.h"

@interface SDSearchStore()

- (BOOL) isNewRobot:(int)robot;
- (BOOL) isNewTime:(NSString*)time;

@end

@implementation SDSearchStore

@synthesize all, matches, times, robots;

+ (id) allocWithZone:(struct _NSZone *)zone {
    return [self sharedStore];
}

+ (SDSearchStore*) sharedStore {
    static SDSearchStore* sharedStore = nil;
    
    if(!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

- (id) init {
    
    if(self=[super init]) {
        
        all = [[NSMutableArray alloc] init];
        matches = [[NSMutableArray alloc] init];
        times = [[NSMutableArray alloc] init];
        robots = [[NSMutableArray alloc] init];
        
        order = [[NSMutableArray alloc] init];
        sectionNames = [[NSMutableArray alloc] init];
        
        [self importSearchItems];
    }
    
    return self;
}

- (NSArray*) order {
    [order removeAllObjects];
    if(robots.count > 0) [order addObject:robots];
    if(matches.count > 0) [order addObject:matches];
    if(times.count > 0) [order addObject:times];
    
    return order;
}

- (NSArray*) sectionNames {
    [sectionNames removeAllObjects];
    if(robots.count > 0) [sectionNames addObject:@"Robots"];
    if(matches.count > 0) [sectionNames addObject:@"Matches"];
    if(times.count > 0) [sectionNames addObject:@"Times"];
    
    return sectionNames;
}

- (void) importSearchItems {
    NSArray* schedules = [[SDScheduleStore sharedStore] allSchedules];
    [all removeAllObjects];
    [robots removeAllObjects];
    [times removeAllObjects];
    [matches removeAllObjects];
    
    for(SDSchedule* schedule in schedules) {
        SDSearch* search = nil;
        if([self isNewRobot:schedule.teamBlue1]) {
            search = [[SDSearch alloc] initWithName:[NSString stringWithFormat:@"%d", schedule.teamBlue1] andType:@"Robot"];
            [robots addObject:search];
            [all addObject:search];
        }
        if([self isNewRobot:schedule.teamBlue2]) {
            search = [[SDSearch alloc] initWithName:[NSString stringWithFormat:@"%d", schedule.teamBlue2] andType:@"Robot"];
            [robots addObject:search];
            [all addObject:search];
        }
        if([self isNewRobot:schedule.teamBlue3]) {
            search = [[SDSearch alloc] initWithName:[NSString stringWithFormat:@"%d", schedule.teamBlue3] andType:@"Robot"];
            [robots addObject:search];
            [all addObject:search];
        }
        if([self isNewRobot:schedule.teamRed1]) {
            search = [[SDSearch alloc] initWithName:[NSString stringWithFormat:@"%d", schedule.teamRed1] andType:@"Robot"];
            [robots addObject:search];
            [all addObject:search];
        }
        if([self isNewRobot:schedule.teamRed2]) {
            search = [[SDSearch alloc] initWithName:[NSString stringWithFormat:@"%d", schedule.teamRed2] andType:@"Robot"];
            [robots addObject:search];
            [all addObject:search];
        }
        if([self isNewRobot:schedule.teamRed3]) {
            search = [[SDSearch alloc] initWithName:[NSString stringWithFormat:@"%d", schedule.teamRed3] andType:@"Robot"];
            [robots addObject:search];
            [all addObject:search];
        }
        if([self isNewTime:schedule.matchTime]) {
            search = [[SDSearch alloc] initWithName:schedule.matchTime andType:@"Time"];
            [times addObject:search];
            [all addObject:search];
        }
        search = [[SDSearch alloc] initWithName:[NSString stringWithFormat:@"%d", schedule.matchNumber] andType:@"Match"];
        [matches addObject:search];
        [all addObject:search];
        
    }
}

- (BOOL) isNewRobot:(int)robot {
    
    for(SDSearch* search in robots) {
        NSString* temp = [NSString stringWithFormat:@"%d", robot];
        if([temp isEqualToString:search.name]) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL) isNewTime:(NSString*)time {
    for(SDSearch* search in times) {
        if([time isEqualToString:search.name]) {
            return NO;
        }
    }
    return YES;
}

- (void) filterArray:(NSArray*)array {
    [robots removeAllObjects];
    [times removeAllObjects];
    [matches removeAllObjects];
    
    for(SDSearch* search in array) {
        if([search.type isEqualToString:@"Robot"]) {
            [robots addObject:search];
        } else if([search.type isEqualToString:@"Match"]) {
            [matches addObject:search];
        } else if([search.type isEqualToString:@"Time"]) {
            [times addObject:search];
        }
    }
}

@end
