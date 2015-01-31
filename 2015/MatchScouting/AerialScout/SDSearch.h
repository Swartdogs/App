//
//  SDSearch.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 3/24/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDSearch : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* type;

- (id) initWithName:(NSString*)name andType:(NSString*)type;

@end
