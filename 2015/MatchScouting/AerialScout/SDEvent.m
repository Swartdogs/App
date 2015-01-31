//
//  SDEvent.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/19/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDEvent.h"

@implementation SDEvent

@synthesize eventDate, eventID, eventLocation, eventName, eventType, eventTypeID, eventVenue;

- (id) init {
    if(self = [super init]) {
        [self setToDefaults];
    }
    
    return self;
}

- (id) initWithCopy:(SDEvent*)copy {
    if(self = [super init]) {
        self.eventDate     = copy.eventDate;
        self.eventID       = copy.eventID;
        self.eventLocation = copy.eventLocation;
        self.eventName     = copy.eventName;
        self.eventType     = copy.eventType;
        self.eventTypeID   = copy.eventTypeID;
        self.eventVenue    = copy.eventVenue;
    }
    
    return self;
}

- (void) setToDefaults {
    self.eventDate     = @"";
    self.eventID       = @"";
    self.eventLocation = @"";
    self.eventName     = @"";
    self.eventType     = @"";
    self.eventTypeID   = -1;
    self.eventVenue    = @"";
}

@end
