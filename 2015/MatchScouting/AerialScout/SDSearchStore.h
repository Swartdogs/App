//
//  SDSearchStore.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 3/24/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDSearchStore : NSObject {
    NSMutableArray* order;
    NSMutableArray* sectionNames;
}

@property (nonatomic, strong) NSMutableArray* all;
@property (nonatomic, strong) NSMutableArray* robots;
@property (nonatomic, strong) NSMutableArray* matches;
@property (nonatomic, strong) NSMutableArray* times;

+ (SDSearchStore*) sharedStore;
- (void) filterArray:(NSArray*)array;
- (NSArray*) order;
- (NSArray*) sectionNames;
- (void) importSearchItems;


@end
