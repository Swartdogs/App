//
//  SDScheduleStore.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/8/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDSchedule;

@interface SDScheduleStore : NSObject {
    NSMutableArray* allSchedules;
}

+ (SDScheduleStore*) sharedStore;

- (NSArray*)  allSchedules;
- (SDSchedule*) createSchedule;
- (void)        removeAll;
- (void)        removeSchedule:(SDSchedule*)thisSchedule;
- (BOOL)        saveChanges;
- (NSString*)   scheduleArchivePath;

@end
