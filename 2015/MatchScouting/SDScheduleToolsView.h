//
//  SDScheduleToolsView.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/8/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDGradientButton.h"

@class SDSchedule;

@interface SDScheduleToolsView : UIViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    int buildGroup;
    NSString* htmlSchedule;
    SDSchedule* scheduleItem;
    NSString* bufferSelectEvent;
    
    __weak IBOutlet UIButton*    buildButton;
    __weak IBOutlet UIButton*    getStartButton;
    __weak IBOutlet UILabel*     getStatusLabel;
    __weak IBOutlet UIActivityIndicatorView* showActivity;
    __weak IBOutlet UITableView* eventTable;
}

@property (nonatomic, retain) IBOutletCollection(SDGradientButton)NSArray* buildListButtons;

- (IBAction) backgroundTap:(id)sender;
- (IBAction) buildList:(id)sender;
- (IBAction) buildListButtonTap:(id)sender;
- (IBAction) startGetSchedule:(id)sender;
- (IBAction) quitEdit:(id)sender;

@end
