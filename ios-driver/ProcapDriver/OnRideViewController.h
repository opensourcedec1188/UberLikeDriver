//
//  OnRideViewController.h
//  ProcapDriver
//
//  Created by MacBookPro on 5/1/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GMSGeocoder.h>
#import <CoreLocation/CoreLocation.h>
#import <CallKit/CallKit.h>

#import "RidesServiceManager.h"
#import "ServiceManager.h"
#import "GoogleServicesManager.h"
#import "EndRideViewController.h"
#import "PaymentViewController.h"
#import "RealTimePubnub.h"
#import "UIHelperClass.h"

#import "CashWarningView.h"
#import "CancelView.h"

@interface OnRideViewController : UIViewController <GMSMapViewDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, RealTimePubnubDelegate, CashWarningViewDelegate, CancelViewDelegate> {
    
    
    
    NSMutableArray *destinationResultsArray;
    
    UIPanGestureRecognizer *swipeArrival;
    UIPanGestureRecognizer *swipeStart;
    UIPanGestureRecognizer *swipeStop;
    
    UIView *loadingView;
    BOOL nearByRideRequestSent;
    
    GMSMarker *clientLocationMarker;
    GMSMutablePath *goClientPath;
    GMSPolyline *goClientRoute;
    
    float originalArrowX;
    UIPanGestureRecognizer *arrivedFooterPanGesture;
    float initialFooterBtmConstraint;
    float initialFooterYAfterPan;
    
    CashWarningView *cashWarning;
    BOOL cashWarningFinished;
    CancelView *cancel;
    NSArray *cancelationReasonsArray;
    
}
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
- (IBAction)myLocBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *myLocBtn;

#pragma mark - Header
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerPickupLabel;
@property (weak, nonatomic) IBOutlet UIButton *rideDestinationButton;
- (IBAction)rideDestinationAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *destinationContainerView;
@property (weak, nonatomic) IBOutlet UITextField *destinationTextField;
@property (weak, nonatomic) IBOutlet UITableView *destinationTableView;

#pragma mark - Footer
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerViewBtmConstraints;
@property (weak, nonatomic) IBOutlet UILabel *footerClientNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *footerArrowImgView;

@property (weak, nonatomic) IBOutlet UIView *luggageContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *luggageRightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *luggageIconImageView;
@property (weak, nonatomic) IBOutlet UIView *quietRideContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quietLeftConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *quietRideIconImageView;

@property (weak, nonatomic) IBOutlet UIView *actionsContainerView;
@property (weak, nonatomic) IBOutlet UIButton *callClientBtn;
- (IBAction)callClientAction:(UIButton *)sender;
- (IBAction)startNavigationAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *cancelRideButton;
- (IBAction)cancelRideAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *navigationButton;
@property (weak, nonatomic) IBOutlet UIButton *operationsButton;

#pragma mark - Data
//@property (strong, nonatomic) RideClass *rideData;
@property (strong, nonatomic) NSDictionary *rideDataDictionary;
@property (strong, nonatomic) NSDictionary *client;

@property (strong) CLLocationManager *locationManager;

@property (strong) RealTimePubnub *cancelManager;

@property (strong, nonatomic) GMSPlacesClient *placesClient;
@end
