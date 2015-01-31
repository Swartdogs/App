//
//  SDViewServer.m
//  RecycleScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Made worse by Seth Harwood 1/27/15.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDViewServer.h"
#import "SDMatch.h"
#import "SDMatchStore.h"
#import "SDTeamMatchView.h"
#import "SDAutoView.h"
#import "SDTeleopView.h"
#import "SDFinalView.h"
#import "SDMatchSummaryView.h"

@interface SDViewServer() {
}

@end

@implementation SDViewServer

@synthesize isNewMatch, matchEdit, navControl;

+ (SDViewServer*) getInstance {
    // Get singleton instance of View Server
    
    static SDViewServer* serverInstance = nil;
    
    if(!serverInstance) {
        serverInstance = [[super allocWithZone:nil] init];
    }
    
    return serverInstance;
}

+ (id) allocWithZone:(NSZone *)zone {
    return [self getInstance];
}

- (void) cancelAlertFor:(UIViewController *)viewController matchData:(SDMatch *)match {
    // Common Alert View for canceling a match edit
    
    NSString* myTitle;
    NSString* myMessage;
    
    if(!matchEdit) {
        if(match.noShow == 1) match.isCompleted = 15;
        
        if(isNewMatch) {
            [[SDMatchStore sharedStore] removeMatch:match];
            [self finishedEditMatchData:match showSummary:NO];
        } else {
            [self finishedEditMatchData:match showSummary:YES];
        }
        
        return;
        
    } else if(isNewMatch) {
        myTitle = @"Cancel New";
        myMessage = @"Save the New Match";
        
    } else {
        myTitle = @"Cancel Edit";
        myMessage = @"Save changes to the Match";
    }
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:myTitle
                                                        message:myMessage
                                                       delegate:viewController
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles:@"No", nil];
    
    alertView.tag = 1;
    [alertView show];
}

- (void) defineNavButtonsFor:(UIViewController *)viewController viewIndex:(NSInteger)vIndex completed:(int)isCompleted {
    // Configure navigation buttons for the five match Views
    
    [[viewController navigationItem] setHidesBackButton:YES animated:NO];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:viewController action:@selector(saveMatch:)];
    
    [[viewController navigationItem] setRightBarButtonItem:doneItem animated:NO];
    
    UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:viewController action:@selector(cancelMatch:)];
    
    [[viewController navigationItem] setLeftBarButtonItem:cancelItem animated:NO];
    
    // configure labels for Toolbar buttons.  Use all caps if page is completed
    
    NSMutableArray* labels = [[NSMutableArray alloc] init];
    
    if(isCompleted & 1) [labels addObject:@"ID"];
    else [labels addObject:@"Id"];
    
    if(isCompleted & 2) [labels addObject:@"AUTO"];
    else [labels addObject:@"Auto"];
    
    if(isCompleted & 4) [labels addObject:@"TELEOP"];
    else [labels addObject:@"Teleop"];
    
    if(isCompleted & 8) [labels addObject:@"MATCH"];
    else [labels addObject:@"Match"];
    
    // Create Toolbar segmented control and configure
    
    UISegmentedControl *toolButtons = [[UISegmentedControl alloc] initWithItems:labels];
    
    [toolButtons setSelectedSegmentIndex:vIndex];
    [toolButtons setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [toolButtons setSegmentedControlStyle:UISegmentedControlStyleBar];
    [toolButtons setFrame:CGRectMake(0, 0, 300, 30)];
    [toolButtons addTarget:viewController action:@selector(selectView:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem* viewItem = [[UIBarButtonItem alloc] initWithCustomView:toolButtons];
    [viewController setToolbarItems:[NSArray arrayWithObject:viewItem]];
}

- (void) finishedEditMatchData:(SDMatch*)match showSummary:(BOOL)show {
    if(show) {
        [self showViewNewIndex:0 oldIndex:1 matchData:match matchCopy:match];
    } else {
        [navControl popToRootViewControllerAnimated:YES];
    }
}

- (void) showViewNewIndex:(NSInteger)nIndex oldIndex:(NSInteger)oIndex matchData:(SDMatch *)match matchCopy:(SDMatch *)origMatch {
    UIViewController *newView;
    NSArray* newViewList;
    NSArray* viewList = [navControl viewControllers];
    
    switch (nIndex) {
        case -1: {
            [navControl popToRootViewControllerAnimated:YES];
            return;
        } break;
        
        case 0: {
            SDMatchSummaryView* matchSummaryView = [[SDMatchSummaryView alloc] initWithNibName:@"SDMatchSummaryView" bundle:nil];
            [matchSummaryView setMatch:match];
            newView = matchSummaryView;
        } break;
        
        case 1: {
            SDTeamMatchView* teamMatchView = [[SDTeamMatchView alloc] initWithNibName:@"SDTeamMatchView" bundle:nil];
            [teamMatchView setMatch:match originalMatch:origMatch];
            newView = teamMatchView;
        } break;
            
        case 2: {
            SDAutoView* autoView = [[SDAutoView alloc] initWithNibName:@"SDAutoView" bundle:nil];
            [autoView setMatch:match originalMatch:origMatch];
            newView = autoView;
        } break;
            
        case 3: {
            SDTeleopView* teleopView = [[SDTeleopView alloc] initWithNibName:@"SDTeleopView" bundle:nil];
            [teleopView setMatch:match originalMatch:origMatch];
            newView = teleopView;
        } break;
            
        case 4: {
            SDFinalView* finalView = [[SDFinalView alloc] initWithNibName:@"SDFinalView" bundle:nil];
            [finalView setMatch:match originalMatch:origMatch];
            newView = finalView;
        } break;
            
        default:
            break;
    }
    
    if(oIndex == -1) {
        newViewList = [NSArray arrayWithObjects:[viewList objectAtIndex:0], newView, nil];
        [navControl setViewControllers:newViewList animated:YES];
        
    } else if(nIndex < oIndex) {
        newViewList = [NSArray arrayWithObjects:[viewList objectAtIndex:0],
                       newView, [viewList objectAtIndex:[viewList count] - 1], nil];
        [navControl setViewControllers:newViewList animated:YES];
        [navControl popViewControllerAnimated:YES];
        
    } else {
        newViewList = [NSArray arrayWithObjects:[viewList objectAtIndex:0], newView, nil];
        [navControl setViewControllers:newViewList animated:YES];
    }
}

- (IBAction) selectView:(id)sender {
    
}

- (IBAction) saveMatch:(id)sender {
    
}

- (IBAction) cancelMatch:(id)sender {
    
}

@end
