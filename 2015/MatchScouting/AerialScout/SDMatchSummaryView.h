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
    
    __weak IBOutlet UILabel* finalPenaltyLabel;
    __weak IBOutlet UILabel* finalPenaltyCardLabel;
    __weak IBOutlet UILabel* finalRobotLabel;

    // Auto
    
    __weak IBOutlet UILabel* autoMoveLabel;
    __weak IBOutlet UILabel* autoContainersLabel;
    __weak IBOutlet UILabel* autoTotesLabel;
    
    // Teleop
    
    __weak IBOutlet UILabel* stackMaxLabel;
    __weak IBOutlet UILabel* totesScoredLabel;
    __weak IBOutlet UILabel* containersScoredLabel;
    __weak IBOutlet UILabel* teleTotesFromLabel;
    __weak IBOutlet UILabel* teleNoodlesLabel;

}

@property (nonatomic, strong) SDMatch* match;

@end