//
//  SDGradientButton.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDGradientButton.h"

@interface SDGradientButton()
- (void) initBorder;
- (void) initLayers;
@end

@implementation SDGradientButton

- (void) awakeFromNib {
    [self initLayers];
}

- (void) initBorder {
    CALayer* layer = self.layer;
    layer.cornerRadius = 5.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;
}

- (void) initLayers {
    [self initBorder];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initLayers];
    }
    return self;
}

- (void) setHighlighted:(BOOL)highlighted {
    highlightLayer.hidden = !highlighted;
    [super setHighlighted:highlighted];
}

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if(selected) {
        [self setBackgroundColor:[UIColor blackColor]];
        [[self titleLabel] setFont:[UIFont boldSystemFontOfSize:16.0]];
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    } else {
        [self setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]];
        [[self titleLabel] setFont:[UIFont systemFontOfSize:14.0]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    }
}

- (void) setColor {
    [self setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
}

@end
