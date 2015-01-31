//
//  SDGradientButton.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SDGradientButton : UIButton {
    CAGradientLayer *shineLayer;
    CALayer         *highlightLayer;
}

- (void) setSelected:(BOOL)selected;
- (void) setColor;

@end
