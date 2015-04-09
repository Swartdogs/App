//
//  SDEventStore.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/19/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDEventStore.h"
#import "SDEvent.h"
#import "SDEventGroup.h"
#import "SDMatchStore.h"

@implementation SDEventStore

- (void) setEventTitle:(NSString*)title {
    eventTitle = title;
    [[NSUserDefaults standardUserDefaults] setObject:eventTitle forKey:@"ScoutEventPrefKey"];
}

- (NSString*) eventTitle {
    return eventTitle;
}

- (void) setBuildListTitle:(NSString*)title {
    if ([title length] > 0) {
        buildListTitle =  [NSString stringWithFormat:@"%@: %@", [eventTitle uppercaseString], title];
    } else {
        buildListTitle = @"";
    }

    [[NSUserDefaults standardUserDefaults] setObject:buildListTitle forKey:@"ScoutBuildTitlePrefKey"];
}

- (NSString*) buildListTitle {
    return buildListTitle;
}

- (NSArray*) allEvents {
    return allEvents;
}

- (NSArray*) allGroups {
    return allGroups;
}

- (NSString*) selectedID {
    return selectedID;
}

- (void) setSeletedID:(NSString*)ID {
    selectedID = ID;
}

+ (id) allocWithZone:(struct _NSZone *)zone {
    return [self sharedStore];
}

+ (SDEventStore*) sharedStore {
    static SDEventStore* sharedStore = nil;
    
    if(!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

- (id) init {
    if(self = [super init]) {
        allEvents = [[NSMutableArray alloc] init];
        allGroups  = [[NSMutableArray alloc] init];
        selectedID = [[NSString alloc] init];
        
        eventTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"ScoutEventPrefKey"];
        if(!eventTitle) eventTitle = @"";
        
        buildListTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"ScoutBuildTitlePrefKey"];
        if(!buildListTitle) buildListTitle = @"";
        
        [self buildEventList];
    }
    
    return self;
}

- (SDEvent*) createEvent {
    SDEvent* newEvent = [[SDEvent alloc] init];
    [allEvents addObject:newEvent];
    
    return newEvent;
}

- (void) removeEvent:(SDEvent *)thisEvent {
    [allEvents removeObjectIdenticalTo:thisEvent];
}

- (void) buildEventList {
    [allEvents removeAllObjects];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"events" ofType:@"txt"];
    
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray* events = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    int groupID = -1;
    
    SDEventGroup* newGroup;
    
    for(int i = 0; i < [events count]; i++) {
        NSString* event = [events objectAtIndex:i];
        
        SDEvent* newEvent = [[SDEvent alloc] init];
        NSArray* properties = [event componentsSeparatedByString:@"|"];
        
        int newEventTypeID = [[properties objectAtIndex:0] intValue];
        
        if(newEventTypeID > groupID) {
            groupID++;
            newGroup = [[SDEventGroup alloc] init];
            newGroup.groupID = groupID;
            newGroup.groupName = [properties objectAtIndex:1];
            newGroup.groupStartIndex = (int)[allEvents count];
            newGroup.groupCount = 0;
            [allGroups addObject:newGroup];
        }
        
        newGroup.groupCount++;
        
        newEvent.eventTypeID   = newEventTypeID;
        newEvent.eventType     = [properties objectAtIndex:1];
        newEvent.eventName     = [properties objectAtIndex:2];
        newEvent.eventVenue    = [properties objectAtIndex:3];
        newEvent.eventLocation = [properties objectAtIndex:4];
        newEvent.eventDate     = [properties objectAtIndex:5];
        newEvent.eventID       = [properties objectAtIndex:6];
        
        [allEvents addObject:newEvent];
    }
}

- (SDEvent*) getEventInSection:(int)section atIndex:(int)index {
    SDEventGroup* group = [allGroups objectAtIndex:section];
    return [allEvents objectAtIndex:(group.groupStartIndex+index)];
}

- (int) getGroupCountInSection:(int)section {
    SDEventGroup* group = [allGroups objectAtIndex:section];
    return group.groupCount;
}

- (NSString*) getGroupNameInSection:(int)section {
    SDEventGroup* group = [allGroups objectAtIndex:section];
    return group.groupName;
}



@end
