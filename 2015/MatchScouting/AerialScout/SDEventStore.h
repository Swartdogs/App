//
//  SDEventStore.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/19/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDEvent;

@interface SDEventStore : NSObject {
    NSMutableArray* allEvents;
    NSMutableArray* allGroups;
    NSString*       selectedID;
    NSString*       eventTitle;
    NSString*       buildListTitle;
    BOOL            scoutHeader;
    BOOL            updateHeader;
}

+ (SDEventStore*) sharedStore;

- (void) updateHeader:(BOOL)update;
- (BOOL) shouldUpdateHeader;
- (void) setHeaderIsShown:(BOOL)shown;
- (BOOL) scoutHeader;
- (void) setEventTitle:(NSString*)title;
- (NSString*) eventTitle;
- (void) setBuildListTitle:(NSString*)title;
- (NSString*) buildListTitle;

- (NSArray*) allEvents;
- (NSArray*) allGroups;
- (NSString*) selectedID;
- (void) setSeletedID:(NSString*)ID;
- (SDEvent*) getEventInSection:(int)section atIndex:(int)index;
- (int) getGroupCountInSection:(int)section;
- (SDEvent*) createEvent;
- (void) removeEvent:(SDEvent*)thisEvent;
- (void) buildEventList;
- (NSString*) getGroupNameInSection:(int)section;

@end
