//
//  BalanceCustomTableViewCell.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/20/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BalanceCustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tripDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripFareLabel;
@property (weak, nonatomic) IBOutlet UILabel *settlmentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImageView;
@property (weak, nonatomic) IBOutlet UIView *separatorView;


@end
