//
//  SDMatchSummaryView.h
//  RecycleScout
//
//  Created by Srinivas Dhanwada on 1/6/14.
//  Made worse by Seth Harwood 1/27/15.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDMatch;

@interface SDMatchSummaryView : UIViewController {
    
    // Check
    
    __weak IBOutlet UIImageView* checkmarkImage;
    
    // Match
    
    __weak IBOutlet UILabel* finalPointsLabel;
    __weak IBOutlet UILabel* finalPenaltyLabel;
    __weak IBOutlet UILabel* finalRobotIssuesLabel;

    // Auto
    
    __weak IBOutlet UILabel* autoRobotLabel;
    __weak IBOutlet UILabel* autoContainersLabel;
    __weak IBOutlet UILabel* autoTotesLabel;
    __weak IBOutlet UILabel* autoToteHandlingLabel;
    __weak IBOutlet UILabel* autoStepContainersLabel;
    
    // Teleop
    
    __weak IBOutlet UILabel* teleTotesFromLabel;
    __weak IBOutlet UILabel* teleToteLevelLabel;
    __weak IBOutlet UILabel* teleTotesScoredLabel;
    __weak IBOutlet UILabel* teleContainerLevelLabel;
    __weak IBOutlet UILabel* teleContainersScoredLabel;
    __weak IBOutlet UILabel* teleLitterScoredLabel;

}

@property (nonatomic, strong) SDMatch* match;

@end