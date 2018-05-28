//
//  EndRideViewController.h
//  ProcapDriver
//
//  Created by MacBookPro on 5/2/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RidesServiceManager.h"
#import "HelperClass.h"
#import "EarningSummaryView.h"

@interface EndRideViewController : UIViewController <EarningSummaryViewDelegate> {
    NSDictionary *driverData;
    int clientRating;
    UIView *loadingView;
    
    //Pickup/DropOff Markers
    GMSMarker *dropOffMarker;
    GMSMarker *pickupMarker;
    GMSMutablePath *tripPath;
    GMSPolyline *tripPolyline;
    
    NSString *emptyStarImage;
    NSString *filledStarImage;
    
    EarningSummaryView *earningView;
}

//@property (strong, nonatomic) NSDictionary *rideParametersDictionary;
@property (strong, nonatomic) NSDictionary *rideData;

@property (weak, nonatomic) IBOutlet UIButton *driverFirstBtn;
- (IBAction)driverFirstBtnAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *driverSecondBtn;
- (IBAction)driverSecondBtnAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *driverThirdBrn;
- (IBAction)driverThirdBrnAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *driverForthBtn;
- (IBAction)driverForthBtnAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *driverFifthBtn;
- (IBAction)driverFifthBtnAction:(UIButton *)sender;

- (IBAction)rateBtnAction:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIButton *operationsButton;


@end
