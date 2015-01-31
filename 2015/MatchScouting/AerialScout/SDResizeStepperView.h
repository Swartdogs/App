//
//  SDResizeStepperView.h
//  RecycleScout
//
//  Created by Srinivas Dhanwada on 1/12/14.
//  Made worse by Seth Harwood 1/27/15.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDGradientButton.h"

@class SDResizeStepperView;

@protocol SDResizeStepperViewDelegate

- (void)stepView:(SDResizeStepperView*)stepView stepperTag:(int)tag newValue:(int)value;

@end

@interface SDResizeStepperView : UIView

@property IBOutlet UILabel*          NameLabel;
@property IBOutlet UILabel*          ScoreLabel;
@property IBOutlet SDGradientButton* minusButton;
@property IBOutlet SDGradientButton* plusButton;


@property (nonatomic) int countValue;
@property (nonatomic) int maximumValue;
@property (nonatomic) int minimumValue;

@property (weak) id <SDResizeStepperViewDelegate> delegate;

- (IBAction)minusButtonTap:(id)sender;
- (IBAction)plusButtonTap:(id)sender;

- (void) initStepperValue:(int) value Minimum:(int)min Maximum:(int)max;
- (void) setEnabled:(bool) enable;


@end
