//
//  SDAutoView.h
//  RecycleScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SDGradientButton.h"
#import "SDResizeStepperView.h"

@class SDMatch;

@interface SDAutoView : UIViewController <UIAlertViewDelegate, SDResizeStepperViewDelegate> {
    SDMatch* match;
    SDMatch* origMatch;

    __weak IBOutlet SDResizeStepperView* autoContainers;
    __weak IBOutlet SDResizeStepperView* autoTotes;
    __weak IBOutlet SDResizeStepperView* autoStep;
    
    __weak IBOutlet UILabel* moveFlag;
  
}
@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* autoRobotButtons;
@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* autoToteButtons;


- (IBAction) backgroundTap:(id)sender;
- (IBAction) buttonTap:(id)sender;

- (void) setMatch:(SDMatch*)editMatch originalMatch:(SDMatch*)unedittedMatch;

@end
