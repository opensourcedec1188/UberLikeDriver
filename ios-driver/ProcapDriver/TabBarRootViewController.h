//
//  TabBarRootViewController.h
//  ProcapDriver
//
//  Created by MacBookPro on 4/29/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import <NotificationCenter/NotificationCenter.h>

#import "DACircularProgressView.h"
#import "ServiceManager.h"
#import "RidesServiceManager.h"
#import "HelperClass.h"
#import "UIHelperClass.h"

#import "MapViewController.h"
#import "EarningsViewController.h"
#import "NewsViewController.h"
#import "AccountViewController.h"

#import "AppDelegate.h"

#import "RealTimePubnub.h"
#import "OnRideViewController.h"

#import "LocalNotification.h"
#import "RideAcceptCustomView.h"

#import "UIImageView+AFNetworking.h"
#import "RideClass.h"

#import "DailySummaryViewController.h"
#import "WeeklySummaryViewController.h"

#import "BalanceTransactionsViewController.h"
#import "ReferralCodeViewController.h"

#import "DocumentsViewController.h"
#import "SettingsViewController.h"
#import "AccountInfoViewController.h"
#import "RatingSummaryViewController.h"
#import "AccountPaymentViewController.h"
#import "HelpViewController.h"

@interface TabBarRootViewController : UIViewController <GMSMapViewDelegate, AccountViewControllerDelegate, RealTimePubnubDelegate, UNUserNotificationCenterDelegate, RideAcceptCustomViewDelegate, EarningsViewControllerDelegate, SettingsViewControllerDelegate> {
    
    NSDictionary *acceptedRide;
    
    BOOL driverOnline;
    float drawProgrssFloat;
    int drawProgressTimeLimit;
    NSTimer *progressCircleTimer;

    NSDictionary *driverData;
        
    UIView *loadingView;
    
    float tabbarHeight;
    
    MapViewController *mapController;
    
    BOOL newRequestCurrentShowing;
}
@property (strong, nonatomic) NSDictionary *pnRideParams;

@property (strong) RealTimePubnub *waitingRideManager;

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (weak, nonatomic) IBOutlet UIView *fixedHeaderView;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) RideAcceptCustomView *rideRequestVeiw;

@property (weak, nonatomic) IBOutlet UISwitch *stateSwitch;
- (IBAction)changeDriverState:(UISwitch *)sender;

@end
