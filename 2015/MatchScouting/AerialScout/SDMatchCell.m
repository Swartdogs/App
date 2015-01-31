//
//  SDMatchCell.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/10/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDMatchCell.h"

@implementation SDMatchCell

@synthesize matchNumberLabel;
@synthesize teamNumberLabel;
@synthesize checkmarkImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
