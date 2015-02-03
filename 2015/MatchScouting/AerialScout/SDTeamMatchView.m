//
//  SDTeamMatchView.m
//  RecycleScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Made worse by Seth Harwood 1/27/15.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDTeamMatchView.h"
#import "SDMatchStore.h"
#import "SDMatch.h"
#import "SDViewServer.h"
#import "SDTitleView.h"

@interface SDTeamMatchView ()

@end

@implementation SDTeamMatchView

@synthesize allianceButtons;

- (id) init {
    self = [super initWithNibName:@"SDTeamMatchView" bundle:nil];
    
    if(self) {
        dataComplete = false;
        myTitle = [[SDTitleView alloc] initWithNibName:@"SDTitleView" bundle:nil];
        self.navigationItem.titleView = myTitle.view;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void) setMatch:(SDMatch *)editMatch originalMatch:(SDMatch *)unedittedMatch {
    match = editMatch;
    origMatch = unedittedMatch;
    
    [[SDViewServer getInstance] defineNavButtonsFor:self viewIndex:0 completed:match.isCompleted];
}

- (IBAction) beginEdit:(id)sender {
    [[[self navigationItem] rightBarButtonItem] setEnabled:NO];
    [noShowButton setEnabled:NO];
    [teamFlag setHidden:([[teamNumberField text] intValue] > 0)];
    [matchFlag setHidden:([[matchNumberField text] intValue] > 0)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [noShowButton setTitleColor:[UIColor lightGrayColor] forState:2];
}

- (void) viewDidUnload {
    teamNumberField = nil;
    matchNumberField = nil;
    noShowButton = nil;
    teamFlag = nil;
    matchFlag = nil;
    allianceButtons = nil;

    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(match.teamNumber > 0) {
        [teamNumberField setText:[NSString stringWithFormat:@"%d", match.teamNumber]];
        [matchNumberField setText:[NSString stringWithFormat:@"%d", match.matchNumber]];
        [[myTitle matchLabel] setText:[NSString stringWithFormat:@"Match %d: %d", match.matchNumber, match.teamNumber]];
    } else {
        [teamNumberField setText:@""];
        [matchNumberField setText:@""];
        [[myTitle matchLabel] setText:@"New Match"];
    }
    
    [matchFlag setHidden:(match.matchNumber > 0)];
    [teamFlag setHidden:(match.teamNumber > 0)];
    
    dataComplete = (match.matchNumber > 0 && match.teamNumber > 0);
    
    [[[self navigationItem] rightBarButtonItem] setEnabled:dataComplete];
    
    noShowButton.layer.cornerRadius = 5.0f;
    [noShowButton setSelected:(match.noShow == 1)];
    [noShowButton setEnabled:dataComplete];
    
    self.navigationController.toolbar.translucent = NO;
    [[self navigationController] setToolbarHidden:NO animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[self view] endEditing:YES];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backgroundTap:(id)sender {
    [[self view] endEditing:YES];
    [[[self navigationItem] rightBarButtonItem] setEnabled:dataComplete];
    
    [noShowButton setEnabled:dataComplete];
    [teamFlag setHidden:([[teamNumberField text] intValue] > 0)];
    [matchFlag setHidden:([[matchNumberField text] intValue] > 0)];
}

- (IBAction)isDataComplete:(id)sender {
    [[SDViewServer getInstance] setMatchEdit:YES];
    
    match.teamNumber = [[teamNumberField text] intValue];
    match.matchNumber = [[matchNumberField text] intValue];

    if(match.teamNumber == 0) {
        dataComplete = NO;
    } else if(match.matchNumber == 0) {
        dataComplete = NO;
    } else {
        dataComplete = YES;
    }
    
    if (dataComplete) {
        [[myTitle matchLabel] setText:[NSString stringWithFormat:@"Match %d:%d", match.matchNumber, match.teamNumber]];
        
        match.isCompleted |= 1;
        UISegmentedControl *segControl = (UISegmentedControl*)[[[self toolbarItems] objectAtIndex:1] customView];
        [segControl setTitle:@"ID" forSegmentAtIndex:0];
        
    } else if(match.isCompleted & 1) {
        match.isCompleted ^= 1;
        UISegmentedControl* segControl = (UISegmentedControl*)[[[self toolbarItems] objectAtIndex:1] customView];
        [segControl setTitle:@"Id" forSegmentAtIndex:0];
    }
}

- (IBAction) noShowButtonTap:(id)sender {
    if (match.noShow == 1) {
        match.noShow = 0;
        match.isCompleted = 1;
        
        [noShowButton setSelected:NO];
        [[SDViewServer getInstance] setMatchEdit:YES];
        
        UISegmentedControl* segControl = (UISegmentedControl*)[[[self toolbarItems] objectAtIndex:1] customView];
        if (match.autoRobot < 0) [segControl setTitle:@"Auto" forSegmentAtIndex:1];
        [segControl setTitle:@"Teleop" forSegmentAtIndex:2];
        if (match.finalScore < 0) [segControl setTitle:@"Match" forSegmentAtIndex:3];

    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Recycle Rush" message:@"Are you sure you want to record this match as a No Show?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
        alertView.tag = 2;
        [alertView setDelegate:self];
        [alertView show];
    }
}

- (IBAction)selectView:(id)sender {
    UISegmentedControl* viewSelectionControl = (UISegmentedControl*)sender;
    
    if(!dataComplete) {
        [viewSelectionControl setSelectedSegmentIndex:0];
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Recycle Rush" message:@"Team and Match Numbers are required before continuing." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        
        [alertView show];
        return;
    }
    
    [[SDViewServer getInstance] showViewNewIndex:viewSelectionControl.selectedSegmentIndex + 1
                                        oldIndex:1
                                       matchData:match
                                       matchCopy:origMatch];
}

- (void) saveMatch:(id)sender {
    if(match.teamNumber == 0 || match.matchNumber == 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Recycle Rush" message:@"Team and Match Numbers are required before saving the Match." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        
        [alertView show];
        return;
    }
    
    if(match.noShow == 1) match.isCompleted = 15;
    
    [[SDMatchStore sharedStore] saveChanges];
    [[SDViewServer getInstance] finishedEditMatchData:match showSummary:YES];
}

- (void) cancelMatch:(id)sender {
    [[self view] endEditing:YES];
    
    if(!dataComplete) {
        if([[SDViewServer getInstance] isNewMatch]) {
            [[SDMatchStore sharedStore] removeMatch:match];
            [[SDViewServer getInstance] finishedEditMatchData:nil showSummary:NO];
        } else {
            [[SDMatchStore sharedStore] replaceMatch:match withMatch:origMatch];
            [[SDViewServer getInstance] finishedEditMatchData:origMatch showSummary:YES];
        }
    } else {
        [[SDViewServer getInstance] cancelAlertFor:self matchData:match];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        
        if(buttonIndex == 1) {
            if([[SDViewServer getInstance] isNewMatch]) {
                [[SDMatchStore sharedStore] removeMatch:match];
                [[SDViewServer getInstance] finishedEditMatchData:nil showSummary:NO];
            } else {
                [[SDMatchStore sharedStore] replaceMatch:match withMatch:origMatch];
                [[SDViewServer getInstance] finishedEditMatchData:origMatch showSummary:YES];
            }
        } else {
            [self saveMatch:self];
        }
        
    } else if(alertView.tag == 2) {
        if(buttonIndex == 1) {
            [match setToDefaults];
            
            match.teamNumber = [[teamNumberField text] intValue];
            match.matchNumber = [[matchNumberField text] intValue];
            match.noShow = 1;
            match.isCompleted = 15;
            [noShowButton setSelected:YES];
            
            [[SDMatchStore sharedStore] saveChanges];
            [[SDViewServer getInstance] finishedEditMatchData:match showSummary:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
