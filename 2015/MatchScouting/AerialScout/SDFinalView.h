//
//  SDFinalView.h
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

@interface SDFinalView : UIViewController <UIAlertViewDelegate, UITextViewDelegate, SDResizeStepperViewDelegate> {
    SDMatch* match;
    SDMatch* origMatch;
    
    bool keypadShown;
    
    __weak IBOutlet UITextView*          commentsField;
    __weak IBOutlet UITextField*         finalScoreField;
    __weak IBOutlet UILabel*             scoreFlag;
    __weak IBOutlet SDResizeStepperView* teleCoopertition;
}

@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* penaltyButtons;
@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* robotButtons;


- (IBAction) backgroundTap:(id)sender;
- (IBAction) isDataComplete:(id)sender;
- (IBAction) beginScoreEdit:(id)sender;
- (IBAction) buttonTap:(id)sender;

- (void) setMatch:(SDMatch*)editMatch originalMatch:(SDMatch *)unedittedMatch;

@end
