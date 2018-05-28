//
//  EarningSummaryView.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/16/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceManager.h"
#import "HelperClass.h"

@protocol EarningSummaryViewDelegate <NSObject>
@required
-(void)hideEarningSummary;
@end

@interface EarningSummaryView : UIView {
    NSDictionary *driverData;
}
@property (nonatomic, weak) id <EarningSummaryViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *CONTENTVIEW;

@property (weak, nonatomic) IBOutlet UILabel *totalEarningsLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashCollectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTripsLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UIView *questsContainerView;
@property (weak, nonatomic) IBOutlet UIView *questsProgressView;
@property (weak, nonatomic) IBOutlet UILabel *completedTripsLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingTripsLabel;

- (IBAction)doneAction:(UIButton *)sender;

@end
