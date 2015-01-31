//
//  SDViewServer.h
//  RecycleScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Made worse by Seth Harwood 1/27/15.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDMatch;

@interface SDViewServer : NSObject {
}

@property (nonatomic) BOOL isNewMatch;
@property (nonatomic) BOOL matchEdit;
@property (nonatomic) UINavigationController* navControl;

+ (SDViewServer*) getInstance;

- (void) cancelAlertFor:(UIViewController*)viewController
              matchData:(SDMatch*)match;

- (void) defineNavButtonsFor:(UIViewController*)viewController
                   viewIndex:(NSInteger)vIndex
                   completed:(int)isCompleted;

- (void) finishedEditMatchData:(SDMatch*)match
                   showSummary:(BOOL)show;

- (void) showViewNewIndex:(NSInteger)nIndex
                 oldIndex:(NSInteger)oIndex
                matchData:(SDMatch*)match
                matchCopy:(SDMatch*)origMatch;

@end
