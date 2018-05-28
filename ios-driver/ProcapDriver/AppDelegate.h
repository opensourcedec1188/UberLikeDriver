//
//  AppDelegate.h
//  ProcapDriver
//
//  Created by MacBookPro on 3/8/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworkActivityIndicatorManager.h>
#import <NotificationCenter/NotificationCenter.h>

#import "ServiceManager.h"
#import "RidesServiceManager.h"
#import "GoogleServicesManager.h"
#import "HelperClass.h"
#import "SplashViewController.h"
#import "LocalNotification.h"
#import "RealTimePubnub.h"

#import "RideAcceptCustomView.h"

//Constants Keys

#define NEWRELIC_APP_TOKEN @"AAa04117583d7752e60eb800735b3b84c1a77ea02b"



@interface AppDelegate : UIResponder <RealTimePubnubDelegate, UIApplicationDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate> {
    UIBackgroundTaskIdentifier bgTask;
    BOOL firstLocationSent;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSDictionary *appRules;
@property (strong, nonatomic) NSString *appVersion;

#pragma mark - Registration Global Objects
@property (strong, nonatomic) UIImage *idImage;
@property (strong, nonatomic) UIImage *drivingLicenseImage;

@property (strong, nonatomic) UIImage *vehicleRegImage;

@property (strong, nonatomic) UIImage *insuranceImg;
@property (strong, nonatomic) UIImage *delegationImg;
@property (strong, nonatomic) UIImage *carImg;

@property (strong, nonatomic) UIImageView *splashView;


@property (strong) NSTimer *normalLocationTimer;
@property (strong) NSTimer *normalHTTPLocationTimer;
@property (strong) NSMutableArray *locationsArray;

//@property (strong) NSTimer *snapToRoadTimer;
@property (strong) NSMutableArray *locationsToBeSnapped;
@property (strong) NSMutableArray *snappedLocationsArray;

@property (strong) CLLocationManager *locationManager;
@property (strong) CLLocation *currentLocation;
@property (strong, nonatomic) NSString *lastHeading;

@property (strong) RealTimePubnub *pubnubManager;


@property (strong) RideAcceptCustomView *rideRequestVeiw;


-(void)initiateLocationManager;

-(void)activateTrackingTimer;
@end

