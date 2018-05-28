//
//  FirstTableViewCell.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/27/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *profitTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayTimeOnlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectedCashLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTripsLabel;

@end
