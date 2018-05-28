//
//  DailySummaryViewController.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/17/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ServiceManager.h"
#import "EarningsServiceManager.h"
#import "ProfitRidesTableViewCell.h"
#import "RideProfitDetailsViewController.h"
#import "FirstTableViewCell.h"
#import "ChooseWeekViewController.h"
#import "UIHelperClass.h"

@interface DailySummaryViewController : UIViewController <ChooseWeekViewControllerDelegate> {
    UIView *loadingView;
    NSArray *weeksArray;
    NSDictionary *currentWeekDictionary;
    NSArray *weekDays;
    NSDictionary *currentDayDataDictionary;
    NSArray *currentRidesArray;
    IBOutlet ProfitRidesTableViewCell *defaultCell;
    IBOutlet FirstTableViewCell *firstCell;
    
    UIColor *darkColor;
    UIColor *whiteColor;
    
    int currentDayIndex;
}
@property (nonatomic, strong) NSDictionary *parametersFromWeekly;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIButton *periodBtn;
- (IBAction)periodBtnAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *satDayBtn;
- (IBAction)satDayBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *satSignalView;
@property (weak, nonatomic) IBOutlet UIButton *sunDayBtn;
- (IBAction)sunDayBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *suSignalView;
@property (weak, nonatomic) IBOutlet UIButton *monDayBtn;
- (IBAction)monDayBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *monSignalView;
@property (weak, nonatomic) IBOutlet UIButton *tuDayBtn;
- (IBAction)tuDayBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *tuSignalView;
@property (weak, nonatomic) IBOutlet UIButton *wedDayBtn;
- (IBAction)wedDayBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *wedSignalView;
@property (weak, nonatomic) IBOutlet UIButton *thurDayBtn;
- (IBAction)thurDayBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *thurSignalView;
@property (weak, nonatomic) IBOutlet UIButton *friDayBtn;
- (IBAction)friDayBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *friSignalView;




@property (weak, nonatomic) IBOutlet UITableView *ridesTableView;
@property (weak, nonatomic) IBOutlet UILabel *noRidesLabel;

- (IBAction)backBtnAction:(UIButton *)sender;

@end
