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
    __weak IBOutlet SDResizeStepperView* TotesMax;
    __weak IBOutlet SDResizeStepperView* TotesScored;
    __weak IBOutlet SDResizeStepperView* ContainersScored;
    __weak IBOutlet SDResizeStepperView* ContainersMax;
}
    
@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* TotesFromButtons;

- (IBAction)buttonTap:(id)sender;
- (IBAction) backgroundTap:(id)sender;
- (IBAction) leftSwipe:(id)sender;
- (IBAction) rightSwipe:(id)sender;

- (void) setMatch:(SDMatch*)editMatch originalMatch:(SDMatch*)unedittedMatch;

@end
