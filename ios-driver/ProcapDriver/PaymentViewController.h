//
//  PaymentViewController.h
//  ProcapDriver
//
//  Created by MacBookPro on 5/2/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

#import "EndRideViewController.h"

@interface PaymentViewController : UIViewController {    
    UIView *loadingView;
}

@property (strong) NSTimer *rideTrackingTimer;

@property (strong, nonatomic) NSDictionary *rideData;

@property (weak, nonatomic) IBOutlet UITextField *priceTestField;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *fareLabel;
@property (weak, nonatomic) IBOutlet UILabel *outstandingBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;

@property (weak, nonatomic) IBOutlet UIButton *operationsButton;

- (IBAction)collectCashAction:(UIButton *)sender;
@end
