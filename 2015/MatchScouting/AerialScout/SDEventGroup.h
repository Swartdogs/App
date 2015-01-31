//
//  SDEventGroup.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/20/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDEventGroup : NSObject

@property int       groupID;
@property NSString* groupName;
@property int       groupStartIndex;
@property int       groupCount;

@end
