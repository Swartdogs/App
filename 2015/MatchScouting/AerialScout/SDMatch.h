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
@property (nonatomic) int hasViewed;
@property (nonatomic) int noShow;

// Auto

@property (nonatomic) int autoRobot;
@property (nonatomic) int autoContainers;
@property (nonatomic) int autoTotes;
@property (nonatomic) int autoHandling;
@property (nonatomic) int stepContainers;

// Teleop - Scoring

@property (nonatomic) int StackMax;
@property (nonatomic) int TotesScored;
@property (nonatomic) int ContainersScored;
@property (nonatomic) int ContainersMax;
@property (nonatomic) int teleTotesFrom;
@property (nonatomic) int teleNoodles;

// Final

@property (nonatomic) int finalScore;
@property (nonatomic) int finalPenalty;
@property (nonatomic) int finalRobot;

+ (NSString*) writeHeader;

- (id)        initWithCopy:(SDMatch*)copy;
- (void)      setToDefaults;
- (NSString*) writeMatch;

@end
