//
//  SDMatch.m
//  RecycleScout
//
//  Created by Srinivas Dhanwada on 1/6/14.
//  Made worse by Seth Harwood 1/27/15.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDMatch.h"

@implementation SDMatch

@synthesize teamNumber, matchNumber, isCompleted, noShow, autoRobot, autoContainers, autoTotes, autoHandling, autoStep, teleTotesFrom, teleToteMax, teleTotesScored, teleContainerMax, teleContainersScored, teleLitterScored, finalScore, finalPenalty, finalRobot;

- (id) init {
    if (self = [super init]) {
        [self setToDefaults];
    }
    
    return self;
}

- (id) initWithCopy:(SDMatch *)copy {
    if (self = [super init]) {
       
        // Match
        
        self.teamNumber             = copy.teamNumber;
        self.matchNumber            = copy.matchNumber;
        self.isCompleted            = copy.isCompleted;
        self.noShow                 = copy.noShow;
        
        // Auto
        
        self.autoRobot              = copy.autoRobot;
        self.autoContainers         = copy.autoContainers;
        self.autoTotes              = copy.autoTotes;
        self.autoHandling           = copy.autoHandling;
        self.autoStep               = copy.autoStep;
        
        // Teleop - Scoring
        
        self.teleTotesFrom          = copy.teleTotesFrom;
        self.teleToteMax            = copy.teleToteMax;
        self.teleTotesScored        = copy.teleTotesScored;
        self.teleContainerMax       = copy.teleContainerMax;
        self.teleContainersScored   = copy.teleContainersScored;
        self.teleLitterScored       = copy.teleLitterScored;

        // Final
        
        self.finalScore            = copy.finalScore;
        self.finalPenalty          = copy.finalPenalty;
        self.finalRobot            = copy.finalRobot;
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
    
    // Match
        
        self.teamNumber             = [aDecoder decodeIntForKey:@"teamNumber"];
        self.matchNumber            = [aDecoder decodeIntForKey:@"matchNumber"];
        self.isCompleted            = [aDecoder decodeIntForKey:@"isCompleted"];
        self.noShow                 = [aDecoder decodeIntForKey:@"noShow"];
    
    // Auto
    
        self.autoRobot              = [aDecoder decodeIntForKey:@"autoRobot"];
        self.autoContainers         = [aDecoder decodeIntForKey:@"autoContainers"];
        self.autoTotes              = [aDecoder decodeIntForKey:@"autoTotes"];
        self.autoHandling           = [aDecoder decodeIntForKey:@"autoHandling"];
        self.autoStep               = [aDecoder decodeIntForKey:@"autoStep"];
    
    // Teleop
        
        self.teleTotesFrom          = [aDecoder decodeIntForKey:@"teleTotesFrom"];
        self.teleToteMax            = [aDecoder decodeIntForKey:@"teleToteMax"];
        self.teleTotesScored        = [aDecoder decodeIntForKey:@"teleTotesScored"];
        self.teleContainerMax       = [aDecoder decodeIntForKey:@"teleContainerMax"];
        self.teleContainersScored   = [aDecoder decodeIntForKey:@"teleContainersScored"];
        self.teleLitterScored       = [aDecoder decodeIntForKey:@"teleLitterScored"];

    // Final
    
        self.finalScore             = [aDecoder decodeIntForKey:@"finalScore"];
        self.finalPenalty           = [aDecoder decodeIntForKey:@"finalPenalty"];
        self.finalRobot             = [aDecoder decodeIntForKey:@"finalRobot"];
    
    }
    
    return self;
    
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    
    // Match
    
    [aCoder encodeInt:teamNumber            forKey:@"teamNumber"];
    [aCoder encodeInt:matchNumber           forKey:@"matchNumber"];
    [aCoder encodeInt:isCompleted           forKey:@"isCompleted"];
    [aCoder encodeInt:noShow                forKey:@"noShow"];
    
    // Auto
    
    [aCoder encodeInt:autoRobot             forKey:@"autoRobot"];
    [aCoder encodeInt:autoContainers        forKey:@"autoContainers"];
    [aCoder encodeInt:autoTotes             forKey:@"autoTotes"];
    [aCoder encodeInt:autoHandling          forKey:@"autoHandling"];
    [aCoder encodeInt:autoStep              forKey:@"autoStep"];
    
    // Teleop - Scoring
    
    [aCoder encodeInt:teleTotesFrom         forKey:@"teleTotesFrom"];
    [aCoder encodeInt:teleToteMax           forKey:@"teleToteMax"];
    [aCoder encodeInt:teleTotesScored       forKey:@"teleTotesScored"];
    [aCoder encodeInt:teleContainerMax      forKey:@"teleContainerMax"];
    [aCoder encodeInt:teleContainersScored  forKey:@"teleContainersScored"];
    [aCoder encodeInt:teleLitterScored      forKey:@"teleLitterScored"];
    
    // Final
    
    [aCoder encodeInt:finalScore            forKey:@"finalScore"];
    [aCoder encodeInt:finalPenalty          forKey:@"finalPenalty"];
    [aCoder encodeInt:finalRobot            forKey:@"finalRobot"];
}

- (void) setToDefaults {
    
    // Required fields = -1
    // Otherwise = 0
    
    // Match
    
    self.teamNumber             = 0;
    self.matchNumber            = 0;
    self.isCompleted            = 0;
    self.noShow                 = 0;
    
    // Auto
    
    self.autoRobot              = -1;
    self.autoContainers         = 0;
    self.autoTotes              = 0;
    self.autoHandling           = 0;
    self.autoStep               = 0;
    
    // Teleop - Scoring
    
    self.teleTotesFrom          = 0;
    self.teleToteMax            = 0;
    self.teleTotesScored        = 0;
    self.teleContainerMax       = 0;
    self.teleContainersScored   = 0;
    self.teleLitterScored       = 0;
    
    // Final
    
    self.finalScore             = -1;
    self.finalPenalty           = 0;
    self.finalRobot             = 0;
    
}

+ (NSString*) writeHeader {
    return [NSString stringWithFormat:@"Team Number, Match Number, Is Completed, No Show, Auto Robot, Auto Containers, Auto Totes, Auto Handling, Auto Step, Tele Totes From, Tele Totes Max, Tele Totes Scored, Tele Containers Max, Tele Containers Scored, teleLitterScored, Penalties, Robot Issues, Final Score \r\n"];
}

- (NSString*) writeMatch {
    if(self.noShow == 1) {
        return [NSString stringWithFormat:@"  %i, %i, %i, %i, , , , , , , , , , , , ,  \r\n",
        
        self.teamNumber,
        self.matchNumber,
        self.isCompleted,
        self.noShow];
        
    } else {
        // need "%i" for everything that will appear in excel
        return [NSString stringWithFormat:@"  %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i  \r\n",
        
        // Match
                
        self.teamNumber,
        self.matchNumber,
        self.isCompleted,
        self.noShow,
            
        // Auto
                
        self.autoRobot,
        self.autoContainers,
        self.autoTotes,
        self.autoHandling,
        self.autoStep,
         
        // Teleop - Scoring
                
        self.teleTotesFrom,
        self.teleToteMax,
        self.teleTotesScored,
        self.teleContainerMax,
        self.teleContainersScored,
        self.teleLitterScored,
         
        // Final
                
        self.finalPenalty,
        self.finalRobot,
        self.finalScore];
    }
}

@end
