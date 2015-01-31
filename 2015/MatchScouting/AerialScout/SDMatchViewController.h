//
//  SDMatchViewController.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/6/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDMatchSummaryView.h"
#import "SDTitleView.h"

@interface SDMatchViewController : UITableViewController <UIActionSheetDelegate> {
    SDTitleView* myTitle;
    bool         toolsShown;
    NSString*    eventTitle;
    NSString*    buildListTitle;
}

- (IBAction)addNewMatch:(id)sender;
- (IBAction)doneWithEdit:(id)sender;
- (IBAction)editMatchList:(id)sender;

@end
