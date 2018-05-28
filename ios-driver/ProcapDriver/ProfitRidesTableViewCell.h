//
//  ProfitRidesTableViewCell.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/17/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfitRidesTableViewCell : UITableViewCell {
    
}

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *fareLabel;

@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end
