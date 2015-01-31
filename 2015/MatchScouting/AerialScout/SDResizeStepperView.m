//
//  SDResizeStepperView.m
//  RecycleScout
//
//  Created by Srinivas Dhanwada on 1/12/14.
//  Made worse by Seth Harwood 1/27/15.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDResizeStepperView.h"
#import "SDViewServer.h"

@implementation SDResizeStepperView

@synthesize NameLabel;
@synthesize ScoreLabel;
@synthesize minusButton, plusButton;
@synthesize countValue, maximumValue, minimumValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        minimumValue = 0;
        maximumValue = 0;
        countValue = 0;
    }
    return self;
}

- (void) initStepperValue:(int)value Minimum:(int)min Maximum:(int)max {
    countValue = value;
    minimumValue = min;
    maximumValue = max;
    
    if (countValue > maximumValue) countValue = maximumValue;
    if (countValue < minimumValue) countValue = minimumValue;
    
    [minusButton setEnabled:(countValue > minimumValue)];
    [plusButton setEnabled:(countValue < maximumValue)];
    
    [ScoreLabel setText:[NSString stringWithFormat:@"%d", countValue]];

    if (countValue > minimumValue) {
        [ScoreLabel setTextColor:[UIColor orangeColor]];
        [ScoreLabel setBackgroundColor:[UIColor blackColor]];
    } else {
        [ScoreLabel setTextColor:[UIColor whiteColor]];
        [ScoreLabel setBackgroundColor:[UIColor lightGrayColor]];
    }
}

- (void) setCountValue:(int)value {
    if (value > maximumValue) value = maximumValue;
    if (value < minimumValue) value = minimumValue;
    
    countValue = value;
    
    [ScoreLabel setText:[NSString stringWithFormat:@"%d", countValue]];

    [minusButton setEnabled:(countValue > minimumValue)];
    [plusButton setEnabled:(countValue < maximumValue)];
    
    if (countValue > minimumValue) {
        [ScoreLabel setTextColor:[UIColor orangeColor]];
        [ScoreLabel setBackgroundColor:[UIColor blackColor]];
    } else {
        [ScoreLabel setTextColor:[UIColor whiteColor]];
        [ScoreLabel setBackgroundColor:[UIColor lightGrayColor]];
    }
}

- (void) setEnabled:(bool)enable {
    if (enable) {
        [minusButton setEnabled:(countValue > minimumValue)];
        [plusButton setEnabled:(countValue < maximumValue)];
    } else {
        [minusButton setEnabled:NO];
        [plusButton setEnabled:NO];
    }
}

- (void) setMaximumValue:(int)value {
    maximumValue = value;
    if (countValue > maximumValue)  {
        countValue = maximumValue;
    
    } else {
        [minusButton setEnabled:(countValue > minimumValue)];
        [plusButton setEnabled:(countValue < maximumValue)];

        if (countValue > minimumValue) {
            [ScoreLabel setBackgroundColor:[UIColor blackColor]];
        } else {
            [ScoreLabel setBackgroundColor:[UIColor lightGrayColor]];
        }
    }
}

- (IBAction) minusButtonTap:(id)sender {
    SDGradientButton* button = sender;
    [self setCountValue: --countValue];
    [self.delegate stepView:self stepperTag:(int)button.tag newValue:countValue];
}

- (IBAction) plusButtonTap:(id)sender {
    SDGradientButton* button = sender;
    [self setCountValue: ++countValue];
    [self.delegate stepView:self stepperTag:(int)button.tag newValue:countValue];
}

@end
