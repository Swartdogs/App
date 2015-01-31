//
//  SDSchedule.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/8/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDSchedule : NSObject <NSCoding>

@property (nonatomic) int       matchNumber;
@property (nonatomic) NSString* matchTime;
@property (nonatomic) int       teamRed1;
@property (nonatomic) int       teamRed2;
@property (nonatomic) int       teamRed3;
@property (nonatomic) int       teamBlue1;
@property (nonatomic) int       teamBlue2;
@property (nonatomic) int       teamBlue3;

- (void) setToDefaults;

@end
