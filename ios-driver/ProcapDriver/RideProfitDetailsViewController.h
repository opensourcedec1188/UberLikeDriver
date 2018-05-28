//
//  RideProfitDetailsViewController.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/19/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

#import "EarningsServiceManager.h"
#import "UIImageView+AFNetworking.h"
#import "UIHelperClass.h"


@interface RideProfitDetailsViewController : UIViewController {
    NSDictionary *rideDetails;
}

@property (nonatomic, strong) NSString *RideID;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *timeDateLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIImageView *tripImageView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *pickupLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropOffLabel;


@property (weak, nonatomic) IBOutlet UILabel *fareLabel;
@property (weak, nonatomic) IBOutlet UILabel *smallProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectedCashLabel;
@property (weak, nonatomic) IBOutlet UILabel *outstandingLabels;
@property (weak, nonatomic) IBOutlet UILabel *settlmentLabel;

- (IBAction)backBtnAction:(UIButton *)sender;

@end
