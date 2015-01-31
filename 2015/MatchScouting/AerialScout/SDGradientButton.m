//
//  SDGradientButton.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDGradientButton.h"

@interface SDGradientButton()
- (void) addHighlightLayer;
- (void) addShineLayer;
- (void) initBorder;
- (void) initLayers;
@end

@implementation SDGradientButton

- (void) addHighlightLayer {
    highlightLayer = [CALayer layer];
    highlightLayer.backgroundColor = [UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:0.75].CGColor;
    highlightLayer.frame = self.layer.bounds;
    highlightLayer.hidden = YES;
    [self.layer insertSublayer:highlightLayer below:shineLayer];
}

- (void) addShineLayer {
    shineLayer = [CAGradientLayer layer];
    shineLayer.frame = self.layer.bounds;
    
    shineLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:1.0f alpha:0.5f].CGColor, (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor, (id)[UIColor colorWithWhite:1.0f alpha:0.3f].CGColor, (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor, (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor, (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor, nil];
    
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.2f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.7f],
                            [NSNumber numberWithFloat:0.9f],
                            [NSNumber numberWithFloat:1.0f], nil];
    
    [self.layer addSublayer:shineLayer];
}

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
//    [self addShineLayer];
//    [self addHighlightLayer];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
