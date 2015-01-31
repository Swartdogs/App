//
//  SDScheduleCell.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/8/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDScheduleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* matchNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel* matchTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel* red1Label;
@property (weak, nonatomic) IBOutlet UILabel* red2Label;
@property (weak, nonatomic) IBOutlet UILabel* red3Label;
@property (weak, nonatomic) IBOutlet UILabel* blue1Label;
@property (weak, nonatomic) IBOutlet UILabel* blue2Label;
@property (weak, nonatomic) IBOutlet UILabel* blue3Label;

@end
