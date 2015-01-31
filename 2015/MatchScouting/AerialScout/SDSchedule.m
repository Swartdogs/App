//
//  SDSchedule.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/8/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDSchedule.h"

@implementation SDSchedule

@synthesize matchNumber, matchTime, teamBlue1, teamBlue2, teamBlue3, teamRed1, teamRed2, teamRed3;

- (id) init {
    if(self = [super init]) {
        [self setToDefaults];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        self.matchNumber = [aDecoder decodeIntForKey:@"matchNumber"];
        self.matchTime   = [aDecoder decodeObjectForKey:@"matchTime"];
        self.teamRed1    = [aDecoder decodeIntForKey:@"teamRed1"];
        self.teamRed2    = [aDecoder decodeIntForKey:@"teamRed2"];
        self.teamRed3    = [aDecoder decodeIntForKey:@"teamRed3"];
        self.teamBlue1   = [aDecoder decodeIntForKey:@"teamBlue1"];
        self.teamBlue2   = [aDecoder decodeIntForKey:@"teamBlue2"];
        self.teamBlue3   = [aDecoder decodeIntForKey:@"teamBlue3"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:matchNumber  forKey:@"matchNumber"];
    [aCoder encodeObject:matchTime forKey:@"matchTime"];
    [aCoder encodeInt:teamRed1     forKey:@"teamRed1"];
    [aCoder encodeInt:teamRed2     forKey:@"teamRed2"];
    [aCoder encodeInt:teamRed3     forKey:@"teamRed3"];
    [aCoder encodeInt:teamBlue1    forKey:@"teamBlue1"];
    [aCoder encodeInt:teamBlue2    forKey:@"teamBlue2"];
    [aCoder encodeInt:teamBlue3    forKey:@"teamBlue3"];
}

- (void) setToDefaults {
    self.matchNumber = 0;
    self.matchTime   = @"";
    self.teamBlue1   = 0;
    self.teamBlue2   = 0;
    self.teamBlue3   = 0;
    self.teamRed1    = 0;
    self.teamRed2    = 0;
    self.teamRed3    = 0;
}

@end
