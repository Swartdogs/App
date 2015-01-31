//
//  SDMatchScheduleView.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 3/23/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDMatchScheduleView : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic) NSArray* schedule;

@end
