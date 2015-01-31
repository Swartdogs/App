//
//  SDMatchSummaryView.m
//  RecycleScout
//
//  Created by Srinivas Dhanwada on 1/6/14.
//  Made worse by Seth Harwood 1/27/15.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDMatchSummaryView.h"
#import "SDMatch.h"
#import "SDTeamMatchView.h"
#import "SDViewServer.h"
#import "SDTitleView.h"

@interface SDMatchSummaryView ()

@end

@implementation SDMatchSummaryView

@synthesize match;

- (void) dismissSummary:(id)sender {
    [[SDViewServer getInstance] showViewNewIndex:-1 oldIndex:0 matchData:match matchCopy:match];
}

- (void) editMatch:(id)sender {
    SDMatch* matchCopy = [[SDMatch alloc] initWithCopy:[self match]];
    if(match.noShow == 1) match.isCompleted = 15;
    
    int newIndex = !(match.isCompleted & 2)  ? 1:
                   !(match.isCompleted & 4)  ? 2:
                   !(match.isCompleted & 8)  ? 3:
                                               0;
    
    [[SDViewServer getInstance] setIsNewMatch:NO];
    [[SDViewServer getInstance] setMatchEdit:NO];
    
    [[SDViewServer getInstance] showViewNewIndex:newIndex + 1
                                        oldIndex:0
                                       matchData:match
                                       matchCopy:matchCopy];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UIBarButtonItem* doneItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(dismissSummary:)];
        
        [[self navigationItem] setRightBarButtonItem:doneItem];
        
        UIBarButtonItem* editItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                     target:self
                                     action:@selector(editMatch:)];
        
        [[self navigationItem] setLeftBarButtonItem:editItem];
    }
    return self;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIScrollView* scrollView = (UIScrollView*)self.view;
    scrollView.contentSize = CGSizeMake(320, 648);
}

- (void) viewDidUnload {
    
    // Match
    
    finalPenaltyLabel      = nil;
    finalPenaltyCardLabel  = nil;
    finalRobotLabel        = nil;
    
    // Auto
    
    autoMoveLabel          = nil;
    autoContainersLabel    = nil;
    autoTotesLabel         = nil;
    
    // Teleop
    
    stackMaxLabel          = nil;
    totesScoredLabel       = nil;
    containersScoredLabel  = nil;
    teleTotesFromLabel     = nil;
    teleNoodlesLabel       = nil;
    
    
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self navigationController] setToolbarHidden:YES animated:YES];
    
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    SDTitleView* myTitle = [[SDTitleView alloc] initWithNibName:@"SDTitleView" bundle:nil];
    self.navigationItem.titleView = myTitle.view;
    
    if (match.matchNumber == 0) {
        [[myTitle matchLabel] setText:@"New Match"];
    } else {
        [[myTitle matchLabel] setText:[NSString stringWithFormat:@"Match: %d: %d", match.matchNumber, match.teamNumber]];
    }
   
    // if the team is a no show then the final result page will be blank
    
    if(match.noShow == 1) {
        [checkmarkImage setHidden:NO];
        
        // Match
        
        finalPenaltyLabel.text      = @"";
        finalPenaltyCardLabel.text  = @"";
        finalRobotLabel.text        = @"";

        // Auto
        
        autoMoveLabel.text          = @"";
        autoContainersLabel.text    = @"";
        autoTotesLabel.text         = @"";
        
        // Teleop
        
        stackMaxLabel.text          = @"";
        totesScoredLabel.text       = @"";
        containersScoredLabel.text  = @"";
        teleTotesFromLabel.text     = @"";
        teleNoodlesLabel.text       = @"";
        
        return;
    }
    
    [checkmarkImage setHidden:(match.isCompleted != 15)];
    
    finalRobotLabel.text = [NSString stringWithFormat:@"%@", match.finalRobot == 0 ? @"Stalled" :
                                                             match.finalRobot == 1 ? @"Tipped Over" :
                                                                                     @""];
    
//    autoMoveLabel.text = [NSString stringWithFormat:@"%@", match.autoMoved == 0 ? @"Stayed" :
//                                                           match.autoMoved == 1 ? @"Moved" :
//                                                                                  @""];
    
    teleTotesFromLabel.text = [NSString stringWithFormat:@"%@", match.teleTotesFrom == 0 ? @"Feeder" :
                                                                match.teleTotesFrom == 1 ? @"Landfill" :
                                                                match.teleTotesFrom == 2 ? @"Step" :
                                                                                           @""];
    
    teleNoodlesLabel.text = [NSString stringWithFormat:@"%@", match.teleNoodles == 0 ? @"R.C.s" :
                                                              match.teleNoodles == 1 ? @"Ground" :
                                                                                       @""];
    // Counters!!!
    
    if((match.isCompleted & 4) == 0) {
        stackMaxLabel.text = @"";
        totesScoredLabel.text = @"";
        containersScoredLabel.text = @"";
   } else {
    
       stackMaxLabel.text = [NSString stringWithFormat:@"%d", match.StackMax];
       totesScoredLabel.text = [NSString stringWithFormat:@"%d", match.TotesScored];
       containersScoredLabel.text = [NSString stringWithFormat:@"%d", match.ContainersScored];
       
       //Examples of things with multiple things;
       // scoreTrussPassLabel.text = [NSString stringWithFormat:@"%d / %d", match.scoreTrussPass, (match.scoreTrussPass + match.scoreMissedTruss)];
       // scoreAssistContributionsLabel.text = [NSString stringWithFormat:@"%d / %d", (match.scoreTeamAssist1+match.scoreTeamAssist2+match.scoreTeamAssist3), match.scoreCycles];
    }
    
    autoTotesLabel.text = [NSString stringWithFormat:@"%@", (match.autoTotes == 0) ? @"None" :
                                                            (match.autoTotes == 1) ? @"One Tote" :
                                                            (match.autoTotes == 2) ? @"Two Totes" :
                                                            (match.autoTotes == 3) ? @"Three Totes" : @""];
    
    autoContainersLabel.text = [NSString stringWithFormat:@"%@", (match.autoContainers == 0) ? @"None" :
                                                                 (match.autoContainers == 1) ? @"One R.C." :
                                                                 (match.autoContainers == 2) ? @"Two R.C.s" :
                                                                 (match.autoContainers == 3) ? @"Three R.Cs" : @""];
    
    if(match.finalPenalty == -1 && (match.isCompleted & 16) == 0) {
        finalPenaltyLabel.text = @"";
        finalPenaltyCardLabel.text = @"";
    } else {
        switch (match.finalPenalty & 1) {
            case -1:finalPenaltyLabel.text = @"";          break;
            case 0: finalPenaltyLabel.text = @"None";      break;
            case 1: finalPenaltyLabel.text = @"Foul";      break;
        }
        
        switch (match.finalPenalty & 12) {
            case -1: finalPenaltyCardLabel.text = @"";           break;
            case 0:  finalPenaltyCardLabel.text = @"None";       break;
            case 4:  finalPenaltyCardLabel.text = @"Yellow";     break;
            case 8:  finalPenaltyCardLabel.text = @"Red";        break;
            case 12: finalPenaltyCardLabel.text = @"Yellow+Red"; break;
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end