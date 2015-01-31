//
//  SDSearch.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 3/24/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDSearch.h"

@implementation SDSearch

- (id) init {
    if(self = [super init]) {
        
    }
    
    return self;
}

- (id) initWithName:(NSString*)name andType:(NSString*)type {
    if(self = [super init]) {
        self.name = name;
        self.type = type;
    }
    
    return self;
}

@end
