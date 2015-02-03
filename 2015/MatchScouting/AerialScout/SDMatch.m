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

@synthesize teamNumber, matchNumber, hasViewed, isCompleted, autoRobot, autoContainers, autoTotes, autoHandling, stepContainers, StackMax, TotesScored, ContainersScored, teleTotesFrom, teleNoodles, finalPenalty, finalRobot, finalScore;

- (id) init {
    if (self = [super init]) {
        [self setToDefaults];
    }
    
    return self;
}

- (id) initWithCopy:(SDMatch *)copy {
    if (self = [super init]) {
       
        // Match
        
        self.teamNumber            = copy.teamNumber;
        self.matchNumber           = copy.matchNumber;
        self.isCompleted           = copy.isCompleted;
        self.hasViewed             = copy.hasViewed;
        
        // Auto
        
        self.autoRobot             = copy.autoRobot;
        self.autoContainers        = copy.autoContainers;
        self.autoTotes             = copy.autoTotes;
        self.autoHandling          = copy.autoHandling;
        self.stepContainers        = copy.stepContainers;
        
        // Teleop - Scoring
        
        self.StackMax              = copy.StackMax;
        self.TotesScored           = copy.TotesScored;
        self.ContainersScored      = copy.ContainersScored;
        self.teleTotesFrom         = copy.teleTotesFrom;
        self.teleNoodles           = copy.teleNoodles;

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
        
        self.teamNumber         = [aDecoder decodeIntForKey:@"teamNumber"];
        self.matchNumber        = [aDecoder decodeIntForKey:@"matchNumber"];
        self.isCompleted        = [aDecoder decodeIntForKey:@"isCompleted"];
        self.hasViewed          = [aDecoder decodeIntForKey:@"hasViewed"];
    
    // Auto
    
        self.autoRobot          = [aDecoder decodeIntForKey:@"autoRobot"];
        self.autoContainers     = [aDecoder decodeIntForKey:@"autoContainers"];
        self.autoTotes          = [aDecoder decodeIntForKey:@"autoTotes"];
        self.autoHandling       = [aDecoder decodeIntForKey:@"autoHandling"];
        self.stepContainers     = [aDecoder decodeIntForKey:@"stepContainers"];
    
    // Teleop - Scoring
        
        self.StackMax           = [aDecoder decodeIntForKey:@"StackMax"];
        self.TotesScored        = [aDecoder decodeIntForKey:@"TotesScored"];
        self.ContainersScored   = [aDecoder decodeIntForKey:@"ContainersScored"];
        self.teleTotesFrom      = [aDecoder decodeIntForKey:@"teleTotesFrom"];
        self.teleNoodles        = [aDecoder decodeIntForKey:@"teleNoodles"];

    // Final
    
        self.finalScore         = [aDecoder decodeIntForKey:@"finalScore"];
        self.finalPenalty       = [aDecoder decodeIntForKey:@"finalPenalty"];
        self.finalRobot         = [aDecoder decodeIntForKey:@"finalRobot"];
    
    }
    
    return self;
    
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    
    // Match
    
    [aCoder encodeInt:teamNumber       forKey:@"teamNumber"];
    [aCoder encodeInt:matchNumber      forKey:@"matchNumber"];
    [aCoder encodeInt:isCompleted      forKey:@"isCompleted"];
    [aCoder encodeInt:hasViewed        forKey:@"hasViewed"];
    
    // Auto
    
    [aCoder encodeInt:autoRobot        forKey:@"autoRobot"];
    [aCoder encodeInt:autoContainers   forKey:@"autoContainers"];
    [aCoder encodeInt:autoTotes        forKey:@"autoTotes"];
    [aCoder encodeInt:autoHandling     forKey:@"autoHandling"];
    [aCoder encodeInt:stepContainers   forKey:@"stepContainers"];
    
    // Teleop - Scoring
    
    [aCoder encodeInt:StackMax         forKey:@"StackMax"];
    [aCoder encodeInt:TotesScored      forKey:@"TotesScored"];
    [aCoder encodeInt:ContainersScored forKey:@"ContainersScored"];
    [aCoder encodeInt:teleTotesFrom    forKey:@"teleTotesFrom"];
    [aCoder encodeInt:teleNoodles      forKey:@"teleNoodles"];
    
    // Final
    
    [aCoder encodeInt:finalScore            forKey:@"finalScore"];
    [aCoder encodeInt:finalPenalty          forKey:@"finalPenalty"];
    [aCoder encodeInt:finalRobot            forKey:@"finalRobot"];
}

- (void) setToDefaults {
    
    // single feild selection = -1
    // keyboard feild = -1
    // all else = 0
    
    // Match
    
    self.teamNumber       = 0;
    self.matchNumber      = 0;
    self.isCompleted      = 0;
    self.hasViewed        = 0;
    
    // Auto
    
    self.autoRobot          = -1;
    self.autoContainers     = 0;
    self.autoTotes          = 0;
    self.autoHandling       = 0;
    self.stepContainers     = 0;
    
    // Teleop - Scoring
    
    self.StackMax           = 0;
    self.TotesScored        = 0;
    self.ContainersScored   = 0;
    self.teleTotesFrom      = 0;
    self.teleNoodles        = 0;
    
    // Final
    
    self.finalScore       = -1;
    self.finalPenalty     = 0;
    self.finalRobot       = 0;
    
}
    // Headers that will appear when exported to excel
+ (NSString*) writeHeader {
    return [NSString stringWithFormat:@"Team Number, Match Number, Is Completed, Auto Robot Moved, Auto Containers Moved, Yellow Totes Moved, Max Stack Height, Totes Scored, Containers Scored, Totes Collected from, Litter From Where, Penalties, Stalled/Tipped, Final Score \r\n"];
}

- (NSString*) writeMatch {
    if(self.noShow == 1) {
        return [NSString stringWithFormat:@"  %i, %i, %i, , , , , , , , , , , , , , , , , , , , , , , , , , %i,   \r\n",
                self.teamNumber,
                self.matchNumber,
                self.isCompleted,
                self.noShow];
    } else {
        // need "%i" for everything that will appear in excel
        return [NSString stringWithFormat:@"  %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i  \r\n",
        // all of the things that need the "%i" above
        
        // Match
                
         self.teamNumber,
         self.matchNumber,
         self.isCompleted,
         
        // Auto
                
         self.autoRobot,
         self.autoContainers,
         self.autoTotes,
         self.autoHandling,
         self.stepContainers,
         
        // Teleop - Scoring
                
         self.StackMax,
         self.TotesScored,
         self.ContainersScored,
         self.teleTotesFrom,
         self.teleNoodles,
         
        // Final
                
         self.finalPenalty,
         self.finalRobot,
         self.finalScore];
    }
}

@end
