//
//  SDMatchSummaryView.m
//  RecycleScout
//
//  Created by Srinivas Dhanwada on 1/6/14.
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

    finalPointsLabel            = nil;
    finalPenaltyLabel           = nil;
    finalRobotIssuesLabel       = nil;
    
    // Auto
    
    autoRobotLabel              = nil;
    autoContainersLabel         = nil;
    autoTotesLabel              = nil;
    autoToteHandlingLabel       = nil;
    autoStepContainersLabel     = nil;
    
    // Teleop
    
    teleTotesFromLabel          = nil;
    teleToteLevelLabel          = nil;
    teleTotesScoredLabel        = nil;
    teleContainerLevelLabel     = nil;
    teleContainersScoredLabel   = nil;
    teleLitterScoredLabel       = nil;
    teleCoopertitionLabel       = nil;
    
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
        
        finalPointsLabel.text           = @"No Show";
        finalPenaltyLabel.text          = @"";
        finalRobotIssuesLabel.text      = @"";

        // Auto
        
        autoRobotLabel.text             = @"";
        autoContainersLabel.text        = @"";
        autoTotesLabel.text             = @"";
        autoToteHandlingLabel.text      = @"";
        autoStepContainersLabel.text    = @"";
        
        // Teleop
        
        teleTotesFromLabel.text         = @"";
        teleToteLevelLabel.text         = @"";
        teleTotesScoredLabel.text       = @"";
        teleContainerLevelLabel.text    = @"";
        teleContainersScoredLabel.text  = @"";
        teleLitterScoredLabel.text      = @"";
        teleCoopertitionLabel.text      = @"";
        
        return;
    }
    
    [checkmarkImage setHidden:(match.isCompleted != 15)];
    
    finalPointsLabel.text = match.finalScore < 0 ? @"" : [NSString stringWithFormat:@"%i", match.finalScore];
    
    NSMutableString* label = [[NSMutableString alloc] init];
    
    [label setString:@""];
    if ((match.finalPenalty & 1) == 1) [label appendString:@"-Foul"];
    if ((match.finalPenalty & 2) == 2) [label appendString:@"-Yellow"];
    if ((match.finalPenalty & 4) == 4) [label appendString:@"-Red"];
    finalPenaltyLabel.text = match.finalPenalty == 0 ? @"" : [label substringFromIndex:1];

    [label setString:@""];
    if ((match.finalRobot & 1) == 1) [label appendString:@"-Stalled"];
    if ((match.finalRobot & 2) == 2) [label appendString:@"-Tipped"];
    finalRobotIssuesLabel.text = match.finalRobot == 0 ? @"" : [label substringFromIndex:1];
    
    autoRobotLabel.text = [NSString stringWithFormat:@"%@", match.autoRobot == 0 ? @"No" :
                                                            match.autoRobot == 1 ? @"Yes" :
                                                                                   @""];
    
    autoContainersLabel.text = [NSString stringWithFormat:@"%i", match.autoContainers];
    
    autoTotesLabel.text = [NSString stringWithFormat:@"%i", match.autoTotes];
    
    [label setString:@""];
    if ((match.autoHandling & 1) == 1) [label appendString:@"-Single"];
    if ((match.autoHandling & 2) == 2) [label appendString:@"-Stack"];
    if ((match.autoHandling & 4) == 4) [label appendString:@"-Added"];
    autoToteHandlingLabel.text = match.autoHandling == 0 ? @"" : [label substringFromIndex:1];
    
    autoStepContainersLabel.text = [NSString stringWithFormat:@"%i", match.autoStep];
    
    [label setString:@""];
    if ((match.teleTotesFrom & 1) == 1) [label appendString:@"-Feeder"];
    if ((match.teleTotesFrom & 2) == 2) [label appendString:@"-Landfill"];
    if ((match.teleTotesFrom & 4) == 4) [label appendString:@"-Step"];
    teleTotesFromLabel.text = match.teleTotesFrom == 0 ? @"" : [label substringFromIndex:1];
    
    teleToteLevelLabel.text         = [NSString stringWithFormat:@"%i", match.teleToteMax];
    teleTotesScoredLabel.text       = [NSString stringWithFormat:@"%i", match.teleTotesScored];
    teleContainerLevelLabel.text    = [NSString stringWithFormat:@"%i", match.teleContainerMax];
    teleContainersScoredLabel.text  = [NSString stringWithFormat:@"%i", match.teleContainersScored];
    teleLitterScoredLabel.text      = [NSString stringWithFormat:@"%i", match.teleLitterScored];
    teleCoopertitionLabel.text      = [NSString stringWithFormat:@"%i", match.teleCoopertition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end