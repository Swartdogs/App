//
//  SDAutoView.m
//  RecycleScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Made worse by Seth Harwood 1/27/15.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDAutoView.h"
#import "SDMatch.h"
#import "SDMatchStore.h"
#import "SDViewServer.h"
#import "SDTitleView.h"

@interface SDAutoView () {
}

- (void) isDataComplete;
- (void) selectIndex:(int)index fromArray:(NSArray*)array;

@end

@implementation SDAutoView

@synthesize autoToteButtons, autoRobotButtons;

- (void) stepView:(SDResizeStepperView *)stepView stepperTag:(int)tag newValue:(int)value {
    switch (tag) {
        case 0: match.autoContainers = value;
                break;
        case 1: match.autoTotes = value;
                break;
        case 2: match.stepContainers = value;
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
        } else
            {
            [self saveMatch:self];
        }
    }
}

- (void) cancelMatch:(id)sender {
    [[self view] endEditing:YES];
    [[SDViewServer getInstance] cancelAlertFor:self matchData:match];
}

- (id) init {
    self = [super initWithNibName:@"SDAutoView" bundle:nil];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void) isDataComplete {
    bool completed = (match.autoRobot >= 0);
    
    [moveFlag setHidden:(match.autoRobot >= 0)];
    [[SDViewServer getInstance] setMatchEdit:YES];
    
    UISegmentedControl* segControl = (UISegmentedControl*)[[[self toolbarItems] objectAtIndex:0] customView];
    
    if(completed) {
        match.isCompleted |= 2;
        [segControl setTitle:@"AUTO" forSegmentAtIndex:1];
    } else if(match.isCompleted & 2) {
        match.isCompleted ^= 2;
        [segControl setTitle:@"Auto" forSegmentAtIndex:1];
    }
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
    
    [[SDViewServer getInstance] defineNavButtonsFor:self viewIndex:1 completed:[match isCompleted]];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    autoContainers.ScoreLabel.layer.cornerRadius    = 5.0f;
    autoTotes.ScoreLabel.layer.cornerRadius         = 5.0f;
    stepContainers.ScoreLabel.layer.cornerRadius    = 5.0f;
    
    autoContainers.delegate = self;
    [autoContainers.minusButton setColor];
    [autoContainers.plusButton setColor];
    
    autoTotes.delegate = self;
    [autoTotes.minusButton setColor];
    [autoTotes.plusButton setColor];
    
    stepContainers.delegate = self;
    [stepContainers.minusButton setColor];
    [stepContainers.plusButton setColor];
}

- (void) viewDidUnload {
    [super viewDidUnload];
}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if((match.hasViewed & 2) == 0) {
        match.autoContainers = 0;
        match.hasViewed |= 2;
    }
    
    SDTitleView* myTitle = [[SDTitleView alloc] initWithNibName:@"SDTitleView" bundle:nil];
    self.navigationItem.titleView = myTitle.view;
    [[myTitle matchLabel] setText:[NSString stringWithFormat:@"Match %d: %d", match.matchNumber, match.teamNumber]];
    
    [self selectIndex:match.autoRobot fromArray:autoRobotButtons];
    
    [autoContainers     initStepperValue:match.autoContainers Minimum:0 Maximum:3];
    [autoTotes          initStepperValue:match.autoTotes Minimum:0 Maximum:3];
    [stepContainers     initStepperValue:match.stepContainers Minimum:0 Maximum:4];
    
    [(SDGradientButton*)[autoToteButtons objectAtIndex:0] setSelected:(match.autoHandling & 1) == 1];
    [(SDGradientButton*)[autoToteButtons objectAtIndex:1] setSelected:(match.autoHandling & 2) == 2];
    [(SDGradientButton*)[autoToteButtons objectAtIndex:2] setSelected:(match.autoHandling & 4) == 4];
    
    [moveFlag setHidden:(match.autoRobot >= 0)];
    
    self.navigationController.toolbar.translucent = NO;
    [[self navigationController] setToolbarHidden:NO animated:NO];


    [[self view] endEditing:YES];
}

- (IBAction) backgroundTap:(id)sender {
    [[self view] endEditing:YES];
}

 // 1s digit
- (IBAction) buttonTap:(id)sender {                             //Binds the buttons in one collection to this event
    SDGradientButton*   button = sender;
    int                 index = [sender tag] % 10;
    int                 bitValue = 1 << index;
 // 10s digit
    switch ([sender tag] / 10) {
        case 0: match.autoRobot = index;
                [self selectIndex:index fromArray:autoRobotButtons];
                [self isDataComplete];
                break;
        case 1: if (match.autoHandling & bitValue) {
                    match.autoHandling ^= bitValue;
                    button.selected = NO;
                } else {
                    match.autoHandling |= bitValue;
                    button.selected = YES;
                }
                break;
        default:;
    }
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
                                        oldIndex:2
                                       matchData:match
                                       matchCopy:origMatch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end