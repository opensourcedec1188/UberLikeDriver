//
//  RatingSummaryViewController.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/20/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ServiceManager.h"
#import "UIHelperClass.h"

@interface RatingSummaryViewController : UIViewController {
    NSDictionary *driverData;
    
    double onseStarRated;
    double twoStarRated;
    double threeStarRated;
    double fourStarRated;
    double fiveStarRated;
}

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *totalTripsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripsRatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *canceledTripLabel;
@property (weak, nonatomic) IBOutlet UILabel *acceptedTripsLabel;

@property (weak, nonatomic) IBOutlet UIView *fiveStarContainerView;
@property (weak, nonatomic) IBOutlet UIView *fiveStarView;
@property (weak, nonatomic) IBOutlet UILabel *fiveStarPercentageLabel;

@property (weak, nonatomic) IBOutlet UIView *fourStarContainerView;
@property (weak, nonatomic) IBOutlet UIView *fourStarView;
@property (weak, nonatomic) IBOutlet UILabel *fourStarPercentageLabel;

@property (weak, nonatomic) IBOutlet UIView *threeStarContainerView;
@property (weak, nonatomic) IBOutlet UIView *threeStarView;
@property (weak, nonatomic) IBOutlet UILabel *threeStarPercentageLabel;

@property (weak, nonatomic) IBOutlet UIView *twoStarContainerView;
@property (weak, nonatomic) IBOutlet UIView *twoStarView;
@property (weak, nonatomic) IBOutlet UILabel *twoStarPercentageLabel;

@property (weak, nonatomic) IBOutlet UIView *oneStarContainerView;
@property (weak, nonatomic) IBOutlet UIView *oneStarView;
@property (weak, nonatomic) IBOutlet UILabel *onseStarPercentageLabel;

@end
