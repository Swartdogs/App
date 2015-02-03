//
//  SDFinalView.m
//  RecycleScout/Users/team525students/Documents/SwartdogsScoutingApp/2015/MatchScouting/AerialScout/SDFinalView.m
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Made worse by Seth Harwood 1/27/15.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDFinalView.h"
#import "SDMatch.h"
#import "SDMatchStore.h"
#import "SDViewServer.h"
#import "SDTitleView.h"

@interface SDFinalView ()

- (void) dismissKeypad;

@end

@implementation SDFinalView

@synthesize penaltyButtons, robotButtons;

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1) {
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
    }
}

- (void) cancelMatch:(id)sender {
    [[self view] endEditing:YES];
    [[SDViewServer getInstance] cancelAlertFor:self matchData:match];
}

- (void) dismissKeypad {
    keypadShown = NO;
    [[self view] endEditing:YES];
    [[[self navigationItem] rightBarButtonItem] setEnabled:YES];
}

- (id) init {
    self = [super initWithNibName:@"SDFinalView" bundle:nil];
    if(self) {
        keypadShown = NO;
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
    
    [[SDViewServer getInstance] defineNavButtonsFor:self viewIndex:3 completed:[match isCompleted]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidUnload {
    finalScoreField = nil;
    penaltyButtons = nil;
    robotButtons = nil;
    
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SDTitleView* myTitle = [[SDTitleView alloc] initWithNibName:@"SDTitleView" bundle:nil];
    self.navigationItem.titleView = myTitle.view;
    
    [[myTitle matchLabel] setText:[NSString stringWithFormat:@"Match %d: %d", match.matchNumber, match.teamNumber]];
    
    if(match.finalScore >= 0) {
        [finalScoreField setText:[NSString stringWithFormat:@"%d", match.finalScore]];
    } else {
        [finalScoreField setText:@""];
    }
    
    [scoreFlag setHidden:([[finalScoreField text] length] != 0)];
    
    [(SDGradientButton*)[penaltyButtons objectAtIndex:0] setSelected:(match.finalPenalty & 1) == 1];
    [(SDGradientButton*)[penaltyButtons objectAtIndex:1] setSelected:(match.finalPenalty & 2) == 2];
    [(SDGradientButton*)[penaltyButtons objectAtIndex:2] setSelected:(match.finalPenalty & 4) == 4];
    
    [(SDGradientButton*)[robotButtons objectAtIndex:0] setSelected:(match.finalRobot & 1) == 1];
    [(SDGradientButton*)[robotButtons objectAtIndex:1] setSelected:(match.finalRobot & 2) == 2];
    
    
    self.navigationController.toolbar.translucent = NO;
    [[self navigationController] setToolbarHidden:NO animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[self view] endEditing:YES];
}

- (void) saveMatch:(id)sender {
    if(match.noShow == 1) {
        if([[SDViewServer getInstance] matchEdit]) {
            match.noShow = 0;
        } else {
            match.isCompleted = 31;
        }
    }
    
    [[SDMatchStore sharedStore] saveChanges];
    [[SDViewServer getInstance] finishedEditMatchData:match showSummary:YES];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) backgroundTap:(id)sender {
    [self dismissKeypad];
    keypadShown = NO;
}

- (IBAction) beginScoreEdit:(id)sender {
    keypadShown = YES;
    [[[self navigationItem] rightBarButtonItem] setEnabled:NO];
}

- (IBAction) isDataComplete:(id)sender {
    BOOL completed = ([[finalScoreField text] length] == 0)  ? NO:
                                                              YES;
   
    [scoreFlag setHidden:([[finalScoreField text] length] != 0)];
    
    [[SDViewServer getInstance] setMatchEdit:YES];
    
    if (completed) {
        match.finalScore = [[finalScoreField text] intValue];
        match.isCompleted |= 8;
        UISegmentedControl* segControl = (UISegmentedControl*)[[[self toolbarItems] objectAtIndex:1] customView];
        [segControl setTitle:@"MATCH" forSegmentAtIndex:3];
        
    } else if(match.isCompleted & 8) {
        match.finalScore = -1;
        match.isCompleted ^= 8;
        UISegmentedControl* segControl = (UISegmentedControl*)[[[self toolbarItems] objectAtIndex:1] customView];
        [segControl setTitle:@"Match" forSegmentAtIndex:3];
    }
}

- (IBAction) buttonTap:(id)sender{
    if(keypadShown) {
        [self dismissKeypad];
        keypadShown = NO;
        return;
    }
    
    int  index = [sender tag] % 10;             // 1's digit
    int  bitValue = 1 << index;
    bool selected;

    switch ([sender tag] / 10) {                // 10's digit
        case 0: if((match.finalPenalty & bitValue) == bitValue) {
                    match.finalPenalty ^= bitValue;
                    selected = NO;
            
                } else {
                    match.finalPenalty |= bitValue;
                    selected = YES;
            
                    if(index == 1) {
                        if((match.finalPenalty & 4) == 4) {
                            match.finalPenalty ^= 4;
                            [(SDGradientButton*)[penaltyButtons objectAtIndex:2] setSelected:NO];
                        }
                    } else if(index == 2) {
                        if((match.finalPenalty & 2) == 2) {
                            match.finalPenalty ^= 2;
                            [(SDGradientButton*)[penaltyButtons objectAtIndex:1] setSelected:NO];
                        }
                    }
                }
            
                [[SDViewServer getInstance] setMatchEdit:YES];
                [(SDGradientButton*)[penaltyButtons objectAtIndex:index]
                                                      setSelected:selected];
                break;

        case 1: if((match.finalRobot & bitValue) == bitValue) {
                    match.finalRobot ^= bitValue;
                    selected = NO;
                } else {
                    match.finalRobot |= bitValue;
                    selected = YES;
                }
            
                [[SDViewServer getInstance] setMatchEdit:YES];
                [(SDGradientButton*)[robotButtons objectAtIndex:index] setSelected:selected];
                break;
    }
}

- (IBAction) selectView:(id)sender {
    UISegmentedControl* viewSelectionControl = (UISegmentedControl*)sender;
    [[SDViewServer getInstance] showViewNewIndex:viewSelectionControl.selectedSegmentIndex + 1
                                        oldIndex:4
                                       matchData:match
                                       matchCopy:origMatch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
