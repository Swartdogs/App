//
//  SDMatch.h
//  RecycleScout
//
//  Created by Srinivas Dhanwada on 1/6/14.
//  Made worse by Seth Harwood 1/27/15.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDMatch : NSObject <NSCoding>

// Match

@property (nonatomic) int teamNumber;
@property (nonatomic) int matchNumber;
@property (nonatomic) int isCompleted;
@property (nonatomic) int noShow;

// Auto

@property (nonatomic) int autoRobot;
@property (nonatomic) int autoContainers;
@property (nonatomic) int autoTotes;
@property (nonatomic) int autoHandling;
@property (nonatomic) int autoStep;

// Teleop - Scoring

@property (nonatomic) int teleTotesFrom;
@property (nonatomic) int teleToteMax;
@property (nonatomic) int teleTotesScored;
@property (nonatomic) int teleContainerMax;
@property (nonatomic) int teleContainersScored;
@property (nonatomic) int teleLitterScored;
@property (nonatomic) int teleCoopertition;

// Final

@property (nonatomic) int finalScore;
@property (nonatomic) int finalPenalty;
@property (nonatomic) int finalRobot;
@property (nonatomic) NSString* finalComments;

+ (NSString*) writeHeader;

- (id)        initWithCopy:(SDMatch*)copy;
- (void)      setToDefaults;
- (NSString*) writeMatch;

@end
