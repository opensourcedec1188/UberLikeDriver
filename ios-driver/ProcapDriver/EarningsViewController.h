//
//  EarningsViewController.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/15/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ServiceManager.h"
#import "DailySummaryViewController.h"
#import "HelperClass.h"

@protocol EarningsViewControllerDelegate <NSObject>
@required
-(void)goToProfitSummary:(int)type;
-(void)goToBalance;
-(void)goToInvitation;
@end

@interface EarningsViewController : UIViewController {
    NSDictionary *driverData;
    int selectedProfitType;
}
@property (nonatomic, weak) id <EarningsViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UILabel *cashCollectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTripsLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitValueLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *mainSegment;
- (IBAction)ToggleMainSegment:(UISegmentedControl *)sender;

@property (weak, nonatomic) IBOutlet UIView *questsContainerView;
@property (weak, nonatomic) IBOutlet UIView *questsProgressView;
@property (weak, nonatomic) IBOutlet UILabel *completedTripsLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingTripsLabel;

- (IBAction)invitationsBtnAction:(UIButton *)sender;

- (IBAction)openProfitDetailsAction:(UIButton *)sender;
- (IBAction)openBalanceDetailsAction:(UIButton *)sender;

@end
