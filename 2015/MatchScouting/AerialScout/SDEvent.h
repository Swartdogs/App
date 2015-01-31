//
//  SDEvent.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/19/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDEvent : NSObject

@property (nonatomic) int       eventTypeID;
@property (nonatomic) NSString* eventType;
@property (nonatomic) NSString* eventName;
@property (nonatomic) NSString* eventVenue;
@property (nonatomic) NSString* eventLocation;
@property (nonatomic) NSString* eventDate;
@property (nonatomic) NSString* eventID;

- (id) initWithCopy:(SDEvent*)copy;
- (void) setToDefaults;

@end
