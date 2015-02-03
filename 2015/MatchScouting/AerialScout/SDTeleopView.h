//
//  SDTeleopView.h
//  RecycleScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Made worse by Seth Harwood 1/27/15.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDGradientButton.h"
#import "SDResizeStepperView.h"

@class SDMatch;

@interface SDTeleopView : UIViewController <UIAlertViewDelegate, SDResizeStepperViewDelegate> {
    SDMatch* match;
    SDMatch* origMatch;
    
    __weak IBOutlet SDResizeStepperView* teleContainerMax;
    __weak IBOutlet SDResizeStepperView* teleContainersScored;
    __weak IBOutlet SDResizeStepperView* teleToteMax;
    __weak IBOutlet SDResizeStepperView* teleTotesScored;
}
    
@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* TotesFromButtons;

- (IBAction) buttonTap:(id)sender;
- (IBAction) backgroundTap:(id)sender;

- (void) setMatch:(SDMatch*)editMatch originalMatch:(SDMatch*)unedittedMatch;

@end
