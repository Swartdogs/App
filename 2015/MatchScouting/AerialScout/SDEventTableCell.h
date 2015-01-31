//
//  SDEventTableCell.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/20/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDEventTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* eventName;
@property (weak, nonatomic) IBOutlet UILabel* eventDate;
@property (weak, nonatomic) IBOutlet UILabel* eventVenue;
@property (weak, nonatomic) IBOutlet UILabel* eventLocation;

@end
