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

- (void) selectIndex:(int)index fromArray:(NSArray*)array;
@end

@implementation SDTeleopView

@synthesize TotesFromButtons;

- (void) stepView:(SDResizeStepperView *)stepView stepperTag:(int)tag newValue:(int)value {
    switch (tag) {
        case 0: match.StackMax = value;
            break;
        case 1: match.TotesScored = value;
            break;
        case 2: match.ContainersMax = value;
            break;
        case 3: match.ContainersScored = value;
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

- (void) selectIndex:(int)index fromArray:(NSArray *)array {
    bool isSelected;
    
    for(int i = 0; i < [array count]; i++) {
        isSelected = ([(SDGradientButton*)[array objectAtIndex:i] tag] == index);
        [(SDGradientButton*)[array objectAtIndex:i] setSelected:isSelected];
    }
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

    TotesMax.ScoreLabel.layer.cornerRadius          = 5.0f;
    TotesScored.ScoreLabel.layer.cornerRadius       = 5.0f;
    ContainersMax.ScoreLabel.layer.cornerRadius     = 5.0f;
    ContainersScored.ScoreLabel.layer.cornerRadius  = 5.0f;

    TotesMax.delegate = self;
    [TotesMax.minusButton setColor];
    [TotesMax.plusButton setColor];
    
    TotesScored.delegate = self;
    [TotesScored.minusButton setColor];
    [TotesScored.plusButton setColor];

    ContainersMax.delegate = self;
    [ContainersMax.minusButton setColor];
    [ContainersMax.plusButton setColor];

    ContainersScored.delegate = self;
    [ContainersScored.minusButton setColor];
    [ContainersScored.plusButton setColor];
}

- (void) viewDidUnload {
    TotesFromButtons = nil;

    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if((match.isCompleted & 4) == 0) {
        match.isCompleted |= 4;
        UISegmentedControl *segControl = (UISegmentedControl*) [[[self toolbarItems] objectAtIndex:0] customView];
        [segControl setTitle:@"TELEOP" forSegmentAtIndex:2];
    }
    
    SDTitleView* myTitle = [[SDTitleView alloc] initWithNibName:@"SDTitleView" bundle:nil];
    self.navigationItem.titleView = myTitle.view;
    [[myTitle matchLabel] setText:[NSString stringWithFormat:@"Match %d: %d", match.matchNumber, match.teamNumber]];
    
    [(SDGradientButton*)[TotesFromButtons objectAtIndex:0] setSelected:(match.teleTotesFrom & 1) == 1];
    [(SDGradientButton*)[TotesFromButtons objectAtIndex:1] setSelected:(match.teleTotesFrom & 2) == 2];
    [(SDGradientButton*)[TotesFromButtons objectAtIndex:2] setSelected:(match.teleTotesFrom & 4) == 4];
    
    [TotesMax           initStepperValue:match.StackMax Minimum:0 Maximum:6];
    [TotesScored        initStepperValue:match.TotesScored Minimum:0 Maximum:70];
    [ContainersScored   initStepperValue:match.ContainersScored Minimum:0 Maximum:7];
    [ContainersMax      initStepperValue:match.ContainersMax Minimum:0 Maximum:6];
    
    self.navigationController.toolbar.translucent = NO;
    [[self navigationController] setToolbarHidden:NO animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self view] endEditing:YES];
}

// 1s digit
- (IBAction) buttonTap:(id)sender {                             //Binds the buttons in one collection to this event
    SDGradientButton*   button = sender;
    int                 index = [sender tag] % 10;
    int                 bitValue = 1 << index;
    // 10s digit
    switch ([sender tag] / 10) {
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

- (IBAction) leftSwipe:(id)sender {
    UISegmentedControl* viewSelectionControl = (UISegmentedControl*)[[[self toolbarItems] objectAtIndex:0] customView];
    viewSelectionControl.selectedSegmentIndex--;
    [self selectView:viewSelectionControl];
}

- (IBAction) rightSwipe:(id)sender {
    UISegmentedControl* viewSelectionControl = (UISegmentedControl*)[[[self toolbarItems] objectAtIndex:0] customView];
    viewSelectionControl.selectedSegmentIndex++;
    [self selectView:viewSelectionControl];
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
    // Dispose of any resources that can be recreated.
}



@end
