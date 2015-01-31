//
//  SDMatchCell.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/10/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDMatchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* matchNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel* teamNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView* checkmarkImage;

@end
