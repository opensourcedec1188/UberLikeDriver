//
//  WeeklySummaryViewController.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/19/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceManager.h"
#import "ProfitRidesTableViewCell.h"
#import "ChooseWeekViewController.h"
#import "EarningsServiceManager.h"
#import "FirstTableViewCell.h"
#import "DailySummaryViewController.h"
#import "HelperClass.h"

@interface WeeklySummaryViewController : UIViewController <ChooseWeekViewControllerDelegate> {
    UIView *loadingView;
    NSArray *monthsArray;
    NSArray *weeksArray;
    NSDictionary *currentWeekDictionary;
    NSDictionary *currentMonthDictionary;
    NSArray *currentRidesArray;
    IBOutlet ProfitRidesTableViewCell *defaultCell;
    IBOutlet FirstTableViewCell *firstCell;
    
    UIColor *darkColor;
    UIColor *whiteColor;
    
    int currentWeekIndex;
}

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIButton *periodBtn;
- (IBAction)periodBtnAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *firstWeekDayBtn;
- (IBAction)firstWeekBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *firstWeekLabel;
@property (weak, nonatomic) IBOutlet UIView *firstWeekSignalView;

@property (weak, nonatomic) IBOutlet UIButton *secondWeekBtn;
- (IBAction)secondWeekBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *secondWeekLabel;
@property (weak, nonatomic) IBOutlet UIView *secondWeekSignalView;

@property (weak, nonatomic) IBOutlet UIButton *thirdWeekBtn;
- (IBAction)thirdWeekBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *thirdWeekLabel;
@property (weak, nonatomic) IBOutlet UIView *thirdWeekSignalView;

@property (weak, nonatomic) IBOutlet UIButton *forthWeekBtn;
- (IBAction)forthWeekBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *forthWeekLabel;
@property (weak, nonatomic) IBOutlet UIView *forthWeekSignalView;


@property (weak, nonatomic) IBOutlet UITableView *ridesTableView;
@property (weak, nonatomic) IBOutlet UILabel *noRidesLabel;

- (IBAction)backBtnAction:(UIButton *)sender;

@end
