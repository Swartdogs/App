//
//  SDTeleopView.m
//  RecycleScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Made worse by Seth Harwood 1/27/15.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDTeleopView.h"
#import "SDMatchStore.h"
#import "SDMatch.h"
#import "SDViewServer.h"
#import "SDTitleView.h"

@interface SDTeleopView ()

@end

@implementation SDTeleopView

@synthesize TotesFromButtons;

- (void) stepView:(SDResizeStepperView *)stepView stepperTag:(int)tag newValue:(int)value {
    switch (tag) {
        case 0: match.teleToteMax = value;
                break;
        case 1: match.teleTotesScored = value;
                break;
        case 2: match.teleContainerMax = value;
                break;
        case 3: match.teleContainersScored = value;
                break;
        case 4: match.teleLitterScored = value;
                break;
        default:;
    }
}

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

- (id) init {
    self = [super initWithNibName:@"SDTeleopView" bundle:nil];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void) saveMatch:(id)sender {
    if(match.noShow == 1) {
        if([[SDViewServer getInstance] matchEdit]) {
            match.noShow = 0;
        } else {
            match.isCompleted = 15;
        }
    }
    
    [[SDMatchStore sharedStore] saveChanges];
    [[SDViewServer getInstance] finishedEditMatchData:match showSummary:YES];
}

- (void) setMatch:(SDMatch *)editMatch originalMatch:(SDMatch *)unedittedMatch {
    match = editMatch;
    origMatch = unedittedMatch;
    
    [[SDViewServer getInstance] defineNavButtonsFor:self viewIndex:2 completed:[match isCompleted]];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    teleToteMax.ScoreLabel.layer.cornerRadius           = 5.0f;
    teleTotesScored.ScoreLabel.layer.cornerRadius       = 5.0f;
    teleContainerMax.ScoreLabel.layer.cornerRadius      = 5.0f;
    teleContainersScored.ScoreLabel.layer.cornerRadius  = 5.0f;
    teleLitterScored.ScoreLabel.layer.cornerRadius      = 5.0f;

    teleToteMax.delegate = self;
    [teleToteMax.minusButton setColor];
    [teleToteMax.plusButton setColor];
    
    teleTotesScored.delegate = self;
    [teleTotesScored.minusButton setColor];
    [teleTotesScored.plusButton setColor];

    teleContainerMax.delegate = self;
    [teleContainerMax.minusButton setColor];
    [teleContainerMax.plusButton setColor];

    teleContainersScored.delegate = self;
    [teleContainersScored.minusButton setColor];
    [teleContainersScored.plusButton setColor];
    
    teleLitterScored.delegate = self;
    [teleLitterScored.minusButton setColor];
    [teleLitterScored.plusButton setColor];
}

- (void) viewDidUnload {
    TotesFromButtons = nil;

    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if((match.isCompleted & 4) == 0) {
        match.isCompleted |= 4;
        UISegmentedControl *segControl = (UISegmentedControl*) [[[self toolbarItems] objectAtIndex:1] customView];
        [segControl setTitle:@"TELEOP" forSegmentAtIndex:2];
    }
    
    SDTitleView* myTitle = [[SDTitleView alloc] initWithNibName:@"SDTitleView" bundle:nil];
    self.navigationItem.titleView = myTitle.view;
    [[myTitle matchLabel] setText:[NSString stringWithFormat:@"Match %d: %d", match.matchNumber, match.teamNumber]];
    
    [(SDGradientButton*)[TotesFromButtons objectAtIndex:0] setSelected:(match.teleTotesFrom & 1) == 1];
    [(SDGradientButton*)[TotesFromButtons objectAtIndex:1] setSelected:(match.teleTotesFrom & 2) == 2];
    [(SDGradientButton*)[TotesFromButtons objectAtIndex:2] setSelected:(match.teleTotesFrom & 4) == 4];
    
    [teleToteMax            initStepperValue:match.teleToteMax Minimum:0 Maximum:6];
    [teleTotesScored        initStepperValue:match.teleTotesScored Minimum:0 Maximum:70];
    [teleContainerMax       initStepperValue:match.teleContainerMax Minimum:0 Maximum:6];
    [teleContainersScored   initStepperValue:match.teleContainersScored Minimum:0 Maximum:7];
    [teleLitterScored       initStepperValue:match.teleLitterScored Minimum:0 Maximum:7];
    
    self.navigationController.toolbar.translucent = NO;
    [[self navigationController] setToolbarHidden:NO animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self view] endEditing:YES];
}

- (IBAction) buttonTap:(id)sender {                         // Button Tap event for all button collections
    SDGradientButton*   button = sender;
    int                 index = [sender tag] % 10;          // 1's Digit
    int                 bitValue = 1 << index;

    switch ([sender tag] / 10) {                            // 10's Digit
        case 0: if (match.teleTotesFrom & bitValue) {
                    match.teleTotesFrom ^= bitValue;
                    button.selected = NO;
                } else {
                    match.teleTotesFrom |= bitValue;
                    button.selected = YES;
                }
                break;
        default:;
    }
}

- (IBAction) backgroundTap:(id)sender {
    [[self view] endEditing:YES];
}

- (IBAction) selectView:(id)sender {
    UISegmentedControl* viewSelectionControl = (UISegmentedControl*)sender;
    [[SDViewServer getInstance] showViewNewIndex:viewSelectionControl.selectedSegmentIndex + 1
                                        oldIndex:3
                                       matchData:match
                                       matchCopy:origMatch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
