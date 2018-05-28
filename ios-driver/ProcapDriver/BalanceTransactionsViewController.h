//
//  BalanceTransactionsViewController.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/20/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EarningsServiceManager.h"
#import "BalanceCustomTableViewCell.h"
#import "RideProfitDetailsViewController.h"
#import "HelperClass.h"

@interface BalanceTransactionsViewController : UIViewController {
    UIView *loadingView;
    
    IBOutlet BalanceCustomTableViewCell *defaultCell;
    NSString *balanceNumber;
    NSArray *transactionsArray;
}
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UITableView *balanceTableView;

- (IBAction)backAction:(UIButton *)sender;
@end
