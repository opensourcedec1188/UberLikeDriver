
//
//  StartRideViewController.m
//  ProcapDriver
//
//  Created by MacBookPro on 5/1/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "OnRideViewController.h"
#import "AppDelegate.h"

@interface OnRideViewController ()
@property (nonatomic, strong) AppDelegate *applicationDelegate;
@end

@implementation OnRideViewController

#pragma mark - Controller Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    _applicationDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [_applicationDelegate initiateLocationManager];
    
    _placesClient = [GMSPlacesClient sharedClient];
    
    //Add observer for coming from background
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    nearByRideRequestSent = NO;
    
    [self initiateLocationManager];
    
    [self.view bringSubviewToFront:_headerView];
    
    originalArrowX = CGRectGetMaxX(_footerArrowImgView.frame);
    
    _callClientBtn.layer.cornerRadius = _callClientBtn.frame.size.height/2;
    _callClientBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    initialFooterBtmConstraint = _footerViewBtmConstraints.constant;
    cashWarningFinished = NO;
    
    [self prepareMapView];
    [self performSelectorInBackground:@selector(getCancelationReasonsBG) withObject:nil];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_rideDestinationButton setHidden:YES];
    [_destinationTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self preparePreRequests];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    UIBezierPath *actionsShadowPath = [UIHelperClass setViewShadow:_actionsContainerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _actionsContainerView.layer.shadowPath = actionsShadowPath.CGPath;
    
    UIBezierPath *luggageShadowPath = [UIHelperClass setViewShadow:_luggageContainerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _luggageContainerView.layer.shadowPath = luggageShadowPath.CGPath;
    
    UIBezierPath *quietRideShadowPath = [UIHelperClass setViewShadow:_quietRideContainerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _quietRideContainerView.layer.shadowPath = quietRideShadowPath.CGPath;
    
    [_applicationDelegate activateTrackingTimer];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

#pragma mark - UIApplicationWillEnterForegroundNotification Handler
- (void)enterForeground {
    [self preparePreRequests];
}

#pragma mark - Location Manager Work
-(void)initiateLocationManager{
    //Get location work
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 15;
    _locationManager.allowsBackgroundLocationUpdates = YES;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    
    //We must insure that appDelegate locationManager is currently wokring and updating locations
    //AppDelegate location work
    if(!_applicationDelegate.locationManager){
        _applicationDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        _applicationDelegate.locationManager = [[CLLocationManager alloc] init];
        _applicationDelegate.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_applicationDelegate.locationManager requestWhenInUseAuthorization];
        _applicationDelegate.locationManager.allowsBackgroundLocationUpdates = YES;
        _applicationDelegate.locationManager.delegate = self;
        [_applicationDelegate.locationManager startUpdatingLocation];
    }else{
        [_applicationDelegate.locationManager startUpdatingLocation];
    }
    
}

#pragma mark - MapView
-(void)prepareMapView{
    _myLocBtn.layer.cornerRadius = _myLocBtn.frame.size.width/2;
    GMSCameraPosition *mapCamera;
    if(_applicationDelegate.currentLocation)
        mapCamera = [GMSCameraPosition cameraWithLatitude:_applicationDelegate.currentLocation.coordinate.latitude
                                                longitude:_applicationDelegate.currentLocation.coordinate.longitude
                                                     zoom:16];
    else
        mapCamera = [GMSCameraPosition cameraWithLatitude:RIYADH_LATITUDE
                                                longitude:RIYADH_LONGITUDE
                                                     zoom:16];
    
    _mapView.myLocationEnabled = YES;
    _mapView.delegate = self;
    [_mapView setCamera:mapCamera];
    //Map Style
    GMSMapStyle *style = [RidesServiceManager setMapStyleFromFileName:@"style"];
    if(style)
        [_mapView setMapStyle:style];
}

- (IBAction)myLocBtnAction:(UIButton *)sender {
    CLLocation *location = _mapView.myLocation;
    if (location) {
        [_mapView animateToLocation:location.coordinate];
    }
}

#pragma mark - Ride Prerequests
-(void)preparePreRequests{
    [self performSelectorInBackground:@selector(getCurrentRideInBG) withObject:nil];
}

-(void)getCurrentRideInBG{
    @autoreleasepool {
        [RidesServiceManager getRide:[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"lastRideId"] :^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishGetCurrentRide:) withObject:response waitUntilDone:NO];
        }];
    }
}
-(void)finishGetCurrentRide:(NSDictionary *)response{
    if(response && ([response objectForKey:@"data"])){
        _rideDataDictionary = [response objectForKey:@"data"];
        [ServiceManager saveLoggedInDriverData:[response objectForKey:@"driver"] andAccessToken:nil];
        _client = [response objectForKey:@"client"];
        //Call the method that adjust view with current ride status
        [self refreshView];
        
    }else{
        //Couldn't get ride, Dismiss controller
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)getCancelationReasonsBG{
    @autoreleasepool {
        [RidesServiceManager getCancelationReasons:^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishCancelationReasons:) withObject:response waitUntilDone:NO];
        }];
    }
}
-(void)finishCancelationReasons:(NSDictionary *)response{
    if(response){
        if([response objectForKey:@"data"]){
            cancelationReasonsArray = [response objectForKey:@"data"];
        }
    }
}

#pragma mark - Central function that detect currentRideStatus and based on it, refresh view
-(void)refreshView{
    
    //Ride Options
    [self displayRideOptions];
    //Prepare location manager
    [self initiateLocationManager];
    //Create footer button gestures
    [self createSwipeGestures];
    //Tracking (Pubnub)
    
    if([[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"isOnRide"] intValue] == 1){
        NSString *status = [_rideDataDictionary objectForKey:@"status"];
        if(!(([status isEqualToString:RIDE_STATUS_ACCEPTED]) || ([status isEqualToString:RIDE_STATUS_NEARBY]))){
            _footerViewBtmConstraints.constant = -_operationsButton.frame.size.height;
            [UIView animateWithDuration:0.3 delay: 0.0 options: UIViewAnimationOptionLayoutSubviews
                             animations:^{
                                 [self.view layoutIfNeeded];
                             } completion:^(BOOL finished){}];
        }
        
        if(status.length > 0){
            [self prepareCurrentRoute];
            if (([status isEqualToString:RIDE_STATUS_ACCEPTED]) || ([status isEqualToString:RIDE_STATUS_NEARBY])){
                [_operationsButton setTitle:NSLocalizedString(@"OR_footerbtn_confirm_arrival", @"") forState:UIControlStateNormal];
                [_operationsButton addGestureRecognizer:swipeArrival];
                [_cancelRideButton setEnabled:YES];
            }else if(([status isEqualToString:RIDE_STATUS_ARRIVED])){
                
                [self prepareAfterArrivalFooterView];
                [_operationsButton removeGestureRecognizer:swipeArrival];
                [_operationsButton addGestureRecognizer:swipeStart];
                [_cancelRideButton setEnabled:YES];
                
                [_navigationButton setEnabled:NO];
                [_operationsButton setTitle:NSLocalizedString(@"OR_footerBtn_startRide", @"") forState:UIControlStateNormal];
                
            }else if([status isEqualToString:RIDE_STATUS_STARTED]){
                if(!cashWarningFinished)
                    [self showCashWarning:YES];
                cashWarningFinished = YES;
                [self prepareAfterArrivalFooterView];
                //Navigation Button
                [_navigationButton setEnabled:YES];
                [_navigationButton removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
                [_navigationButton addTarget:self action:@selector(navigateToRideDestination) forControlEvents:UIControlEventTouchUpInside];
                
                [_operationsButton removeGestureRecognizer:swipeStart];
                [_operationsButton addGestureRecognizer:swipeStop];
                [_operationsButton setTitle:NSLocalizedString(@"OR_footerBtn_stopRide", @"") forState:UIControlStateNormal];
                
                [_cancelRideButton setEnabled:NO];
                _cancelRideButton.alpha = 0.5;
                
            }else if([status isEqualToString:RIDE_STATUS_ENDED]){
                [self showCashWarning:YES];
            }else if([status isEqualToString:RIDE_STATUS_FINISHED]){
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }else{
                [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"OR_unknownRideStatusTitle", @"") andMessage:NSLocalizedString(@"OR_unknownRideStatusMessage", @"")] animated:YES completion:nil];
                [self preparePreRequests];
            }
            [self listClientData];
            
        }else{
            [self preparePreRequests];
            [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"OR_unknownRideStatusTitle", @"") andMessage:NSLocalizedString(@"OR_unknownRideStatusMessage", @"")] animated:YES completion:nil];
        }
        
        [self initiateRealTimeManager];
    }else{
        [self performSelectorInBackground:@selector(dismissLastRideMessageInBG) withObject:nil];
        UIAlertController * alert=[UIAlertController
                                   
                                   alertControllerWithTitle:NSLocalizedString(@"OR_rideCanceledAlertTitle", @"") message:NSLocalizedString(@"OR_rideCanceledAlertMessage", @"") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesBtn = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"general_ok", @"")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [alert addAction:yesBtn];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)prepareAfterArrivalFooterView{
    arrivedFooterPanGesture = [[UIPanGestureRecognizer alloc]  initWithTarget:self action:@selector(panInitialFooterView:)];
    [_footerView removeGestureRecognizer:arrivedFooterPanGesture];
    [_footerView addGestureRecognizer:arrivedFooterPanGesture];
}
#pragma mark - Initiation Cancel Gesture
-(void)panInitialFooterView:(UIPanGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateBegan){
        initialFooterYAfterPan = _footerView.frame.origin.y;
    }
    CGPoint translatedPoint = [gesture translationInView:gesture.view.superview];
    
    float newFooterY = (_footerView.center.y + translatedPoint.y - (_footerView.frame.size.height/2));

    if((newFooterY >= (self.view.frame.size.height - _footerView.frame.size.height)) && (newFooterY <= (self.view.frame.size.height - _footerView.frame.size.height + _operationsButton.frame.size.height ))){
        
        _footerView.center = CGPointMake(_footerView.center.x, _footerView.center.y + translatedPoint.y);
    }else{
        [arrivedFooterPanGesture setEnabled:NO];
        [self setFinalFooterFrame];
    }
    [gesture setTranslation:CGPointZero inView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self setFinalFooterFrame];
    }
}

-(void)setFinalFooterFrame{
    [arrivedFooterPanGesture setEnabled:YES];
    if(_footerView.frame.origin.y > initialFooterYAfterPan){
        _footerViewBtmConstraints.constant = -_operationsButton.frame.size.height;
        [UIView animateWithDuration:0.2 delay: 0.0 options: UIViewAnimationOptionLayoutSubviews
                         animations:^{
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished){}];
    }else{
        _footerViewBtmConstraints.constant = initialFooterBtmConstraint;
        [UIView animateWithDuration:0.2 delay: 0.0 options: UIViewAnimationOptionLayoutSubviews
                         animations:^{
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished){}];
    }
}

-(void)showCashWarning:(BOOL)show{
    if(show){
        [cashWarning removeFromSuperview];
        cashWarning = [[CashWarningView alloc] initWithFrame:self.view.bounds];
        cashWarning.delegate = self;
        cashWarning.alpha = 0.0f;
        [self.view addSubview:cashWarning];
        [UIView animateWithDuration:0.4 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             cashWarning.alpha = 1.0f;
                         } completion:^(BOOL finished){}];
    }else{
        [UIView animateWithDuration:0.4 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             cashWarning.alpha = 0.0f;
                         } completion:^(BOOL finished){
                             [cashWarning removeFromSuperview];
                         }];
    }
}

-(void)hideWarningView{
    [self showCashWarning:NO];
    if([[_rideDataDictionary objectForKey:@"status"] isEqualToString:RIDE_STATUS_ENDED])
        [self performSegueWithIdentifier:@"goPaymentSegue" sender:self];
}

#pragma mark - Initiate RealTime Object
-(void)initiateRealTimeManager{
    if(_cancelManager){
        [_cancelManager endListening];
        _cancelManager = nil;
    }
    _cancelManager = [[RealTimePubnub alloc] initManager:NO];
    [_cancelManager listenToChannelName:[NSString stringWithFormat:@"drivers-%@", [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]]];
    _cancelManager.listnerDelegate = self;
}

#pragma mark - Display Ride Options
-(void)displayRideOptions{
    if((!([[_rideDataDictionary objectForKey:@"isQuiet"] intValue] == 1)) && ([[_rideDataDictionary objectForKey:@"isLuggage"] intValue] == 1)){
        
        _luggageRightConstraint.constant = (self.view.frame.size.width/2) - (_luggageContainerView.frame.size.width/2);
        [_luggageContainerView setHidden:NO];
        [_quietRideContainerView setHidden:YES];
        
    }else if(([[_rideDataDictionary objectForKey:@"isQuiet"] intValue] == 1) && (!([[_rideDataDictionary objectForKey:@"isLuggage"] intValue] == 1))){
        
        _quietLeftConstraint.constant = (self.view.frame.size.width/2) - (_quietRideContainerView.frame.size.width/2);
        [_luggageContainerView setHidden:YES];
        [_quietRideContainerView setHidden:NO];
        
    }else if(!([[_rideDataDictionary objectForKey:@"isQuiet"] intValue] == 1) && !([[_rideDataDictionary objectForKey:@"isLuggage"] intValue] == 1)){
        
        [_luggageContainerView setHidden:YES];
        [_quietRideContainerView setHidden:YES];
        
    }else if(([[_rideDataDictionary objectForKey:@"isQuiet"] intValue] == 1) && ([[_rideDataDictionary objectForKey:@"isLuggage"] intValue] == 1)){
        
        [_luggageContainerView setHidden:NO];
        [_quietRideContainerView setHidden:NO];
        
    }
}

#pragma mark - LocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *newLocation = [locations lastObject];
    
    //If distance less than 400M, Set ride to enarby
    if(_rideDataDictionary && [_rideDataDictionary objectForKey:@"_id"]){
        
        //Check if driver is nearby
        if([_rideDataDictionary objectForKey:@"pickupLocation"]){
            CLLocationCoordinate2D firstCoordinates= CLLocationCoordinate2DMake([[[[_rideDataDictionary objectForKey:@"pickupLocation"] objectForKey:@"coordinates"] objectAtIndex:0] floatValue], [[[[_rideDataDictionary objectForKey:@"pickupLocation"] objectForKey:@"coordinates"] objectAtIndex:1] floatValue]);
            CLLocationCoordinate2D secondCoordinates= CLLocationCoordinate2DMake(_applicationDelegate.currentLocation.coordinate.latitude, _applicationDelegate.currentLocation.coordinate.longitude);
            CLLocationDistance distanceToDestination = GMSGeometryDistance(firstCoordinates, secondCoordinates);
            
            if(distanceToDestination < 400){
                if([[_rideDataDictionary objectForKey:@"status"] isEqualToString:RIDE_STATUS_ACCEPTED]){
                    if(!nearByRideRequestSent){
                        NSLog(@"should setRideNearbyInBG");
                        [self performSelectorInBackground:@selector(setRideNearbyInBG) withObject:nil];
                    }
                }
            }
        }
    }
    
    NSString *status = [_rideDataDictionary objectForKey:@"status"];
    //Updates here occurred in 3 cases ride-(accepted/nearby/on-ride)
    [_mapView animateToLocation:newLocation.coordinate];
    
    if(([status isEqualToString:RIDE_STATUS_ACCEPTED]) || ([status isEqualToString:RIDE_STATUS_NEARBY])){
        if([HelperClass checkCoordinates:[_rideDataDictionary objectForKey:@"pickupLocation"]]){
            
            NSArray *pickupArray = [[_rideDataDictionary objectForKey:@"pickupLocation"] objectForKey:@"coordinates"];

            CLLocation *pickupLocation = [[CLLocation alloc] initWithLatitude:[[pickupArray objectAtIndex:0] floatValue] longitude:[[pickupArray objectAtIndex:1] floatValue]];
            CLLocationDistance distanceToClient = [pickupLocation distanceFromLocation:newLocation];
            
            if(distanceToClient < 200){
                goClientRoute.map = nil;
                goClientRoute = nil;
            }else{
                if(goClientPath != nil){
                    if(!GMSGeometryIsLocationOnPathTolerance(newLocation.coordinate, goClientPath, NO, 40)){
                        [self prepareCurrentRoute];
                        [self presentViewController:[HelperClass showAlert:@"Update Route" andMessage:@"Update Route"] animated:YES completion:nil];
                    }
                }
            }
            
        }
    }else if([status isEqualToString:RIDE_STATUS_STARTED]){
        if([HelperClass checkCoordinates:[_rideDataDictionary objectForKey:@"dropoffLocation"]]){

            NSArray *dropOffArray = [[_rideDataDictionary objectForKey:@"dropoffLocation"] objectForKey:@"coordinates"];
            CLLocation *dropOffLocation = [[CLLocation alloc] initWithLatitude:[[dropOffArray objectAtIndex:0] floatValue] longitude:[[dropOffArray objectAtIndex:1] floatValue]];
            CLLocationDistance distanceToClient = [dropOffLocation distanceFromLocation:newLocation];
            
            if(distanceToClient < 100){
                goClientRoute.map = nil;
                goClientRoute = nil;
            }else{
                if(goClientPath != nil){
                    if(!GMSGeometryIsLocationOnPathTolerance(newLocation.coordinate, goClientPath, NO, 80)){
                        [self prepareCurrentRoute];
                        [self presentViewController:[HelperClass showAlert:@"Update Route" andMessage:@"Update Route"] animated:YES completion:nil];
                    }
                }
            }
        }
    }
}

#pragma mark - Footer Data Filling
-(void)listClientData{
    self.footerClientNameLabel.text = [NSString stringWithFormat:@"%@ %@", [_client objectForKey:@"firstName"], [_client objectForKey:@"lastName"]];
}

#pragma mark - Set ride status to nearby when distance to pickup location becomes 300M
-(void)setRideNearbyInBG{
    NSLog(@"setRideNearbyInBG");
    @autoreleasepool {
        [RidesServiceManager
         driverBecameNearby:@{@"currentLocation" : [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", _applicationDelegate.currentLocation.coordinate.latitude], [NSString stringWithFormat:@"%f", _applicationDelegate.currentLocation.coordinate.longitude], nil]}
                                     andRideID:[_rideDataDictionary objectForKey:@"_id"] :^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishSetRideNearbyInBG:) withObject:response waitUntilDone:NO];
        }];
    }
}
-(void)finishSetRideNearbyInBG:(NSDictionary *)response{
    if([response objectForKey:@"data"]){
        nearByRideRequestSent = YES;
        NSLog(@"finishSetRideNearbyInBG rideData %@", [response objectForKey:@"data"]);
        _rideDataDictionary = [response objectForKey:@"data"];
    }
}

#pragma mark - RealTimeManagerDelegate
#pragma mark - Pubnub Messages Receive delegate
-(void)receivedMessageOnPupnub:(NSDictionary *)message{
    NSLog(@"onRide receivedMessageOnPupnub %@", message);
    NSString *event = [message objectForKey:@"event"];
    if([event isEqualToString:@"ride-canceled"]){
        
        [self performSelectorInBackground:@selector(dismissLastRideMessageInBG) withObject:nil];
        NSString *alertMessage = NSLocalizedString(@"OR_rideCanceledAlertMessage", @"");
        if([[[message objectForKey:@"data"] objectForKey:@"canceledBy"] isEqualToString:@"client"])
            alertMessage = NSLocalizedString(@"OR_rideCanceledByClientAlertMessage", @"");
        
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedString(@"OR_rideCanceledAlertTitle", @"") message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesBtn = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"general_ok", @"")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [alert addAction:yesBtn];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if([event isEqualToString:@"ride-cleared"]){
        
        [self preparePreRequests];
        
    }else if([event isEqualToString:@"ride-fee-applied"]){

    }
}
#pragma mark - dismiss driver last ride status
-(void)dismissLastRideMessageInBG{
    @autoreleasepool {
        [RidesServiceManager dismissLastRideCancelation:^(NSDictionary *completion){
            [self performSelectorOnMainThread:@selector(finishDismissLastRideMessageInBG:) withObject:completion waitUntilDone:NO];
        }];
    }
}

-(void)finishDismissLastRideMessageInBG:(NSDictionary *)response{
    if([response objectForKey:@"data"])
        [ServiceManager saveLoggedInDriverData:[response objectForKey:@"data"] andAccessToken:nil];
}

-(void)createSwipeGestures{
    swipeArrival = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleOperationButtonSwipe:)];
    swipeStart = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleOperationButtonSwipe:)];
    swipeStop = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleOperationButtonSwipe:)];
}

-(void)handleOperationButtonSwipe:(UIPanGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer locationInView:_footerView];
    _footerArrowImgView.frame = CGRectMake(translation.x, _footerArrowImgView.frame.origin.y, _footerArrowImgView.frame.size.width, _footerArrowImgView.frame.size.height);
    
    float alpha = ((_operationsButton.frame.size.width/2) - translation.x)/100;
    if((alpha < 0) || (alpha == 0)){
        alpha = 0.1;
        _operationsButton.titleLabel.alpha = alpha;
    }else{
        _operationsButton.titleLabel.alpha = alpha;
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        _operationsButton.titleLabel.alpha = 1.0;
        [UIView animateWithDuration:0.3
                              delay: 0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             _footerArrowImgView.frame = CGRectMake(originalArrowX, _footerArrowImgView.frame.origin.y, _footerArrowImgView.frame.size.width, _footerArrowImgView.frame.size.height);
                         }
                         completion:^(BOOL finished){}];
        NSLog(@"translation.x : %f", translation.x);
        if(translation.x > (_operationsButton.frame.size.width*3/4)){
            if(recognizer == swipeArrival)
                [self confirmArrived];
            else if(recognizer == swipeStart)
                [self beginRideAction];
            else if(recognizer == swipeStop)
                [self stopRideAction];
            
        }
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
}

#pragma mark - Confirm arrived to client
-(void)confirmArrived{
    if(([[_rideDataDictionary objectForKey:@"status"] isEqualToString:RIDE_STATUS_ACCEPTED]) || ([[_rideDataDictionary objectForKey:@"status"] isEqualToString:RIDE_STATUS_NEARBY])){
        
        CLLocationCoordinate2D firstCoordinates= CLLocationCoordinate2DMake([[[[_rideDataDictionary objectForKey:@"pickupLocation"] objectForKey:@"coordinates"] objectAtIndex:0] floatValue], [[[[_rideDataDictionary objectForKey:@"pickupLocation"] objectForKey:@"coordinates"] objectAtIndex:1] floatValue]);
        CLLocationCoordinate2D secondCoordinates= CLLocationCoordinate2DMake(_applicationDelegate.currentLocation.coordinate.latitude, _applicationDelegate.currentLocation.coordinate.longitude);
        CLLocationDistance distanceToDestination = GMSGeometryDistance(firstCoordinates, secondCoordinates);
        
        if(distanceToDestination < 300){
            
            [self showLoadingView:YES];
            [self performSelectorInBackground:@selector(arriveToClient:) withObject:[_rideDataDictionary objectForKey:@"_id"]];
        }else{
            [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"OR_arrivalStillFarTitle", @"") andMessage:NSLocalizedString(@"OR_arrivalStillFarMessage", @"")] animated:YES completion:nil];
        }
    }else{
        [self preparePreRequests];
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"OR_unexpectedActionTitle", @"") andMessage:NSLocalizedString(@"OR_unexpectedActionMessage", @"")] animated:YES completion:nil];
    }
}

-(void)arriveToClient:(NSString *)rideID{
    @autoreleasepool {
        NSArray *coordinatesArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", _applicationDelegate.currentLocation.coordinate.latitude], [NSString stringWithFormat:@"%f", _applicationDelegate.currentLocation.coordinate.longitude], nil];
        [RidesServiceManager driverConfirmArrivalToClient:@{@"currentLocation" : coordinatesArray} andRideID:rideID :^(NSDictionary * response){
            [self performSelectorOnMainThread:@selector(finishArrivalRequest:) withObject:response waitUntilDone:NO];
        }];
    }
}

-(void)finishArrivalRequest:(NSDictionary *)response{
    [self showLoadingView:NO];
    
    if(([[response objectForKey:@"code"] intValue] == 200) && ([response objectForKey:@"data"])){
        NSLog(@"finishArrivalRequest rideData %@", [response objectForKey:@"data"]);
        _rideDataDictionary = [response objectForKey:@"data"];
        [self refreshView];
    }else{
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_problem_title", @"") andMessage:NSLocalizedString(@"general_problem_message", @"")] animated:YES completion:nil];
    }
}

#pragma mark - Start ride
-(void)beginRideAction{
    if([[_rideDataDictionary objectForKey:@"status"] isEqualToString:RIDE_STATUS_ARRIVED]){

        [_cancelRideButton setEnabled:NO];
        [self showLoadingView:YES];
        [self performSelectorInBackground:@selector(beginRideInBackground:) withObject:[_rideDataDictionary objectForKey:@"_id"]];
    }else{
        [self preparePreRequests];
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"OR_unexpectedActionTitle", @"") andMessage:NSLocalizedString(@"OR_unexpectedActionMessage", @"")] animated:YES completion:nil];
    }
}

-(void)beginRideInBackground:(NSString *)rideID{
    @autoreleasepool {
        NSArray *coordinatesArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", _applicationDelegate.currentLocation.coordinate.latitude], [NSString stringWithFormat:@"%f", _applicationDelegate.currentLocation.coordinate.longitude], nil];
        [RidesServiceManager beginRide:@{@"currentLocation" : coordinatesArray} andRideID:rideID :^(NSDictionary * response){
            [self performSelectorOnMainThread:@selector(finishBeginRideInBackground:) withObject:response waitUntilDone:NO];
        }];
    }
}

-(void)finishBeginRideInBackground:(NSDictionary *)response{
    [self showLoadingView:NO];

    if(([[response objectForKey:@"code"] intValue] == 200) && ([response objectForKey:@"data"])){
        NSLog(@"finishBeginRideInBackground rideData %@", [response objectForKey:@"data"]);
        _rideDataDictionary = [response objectForKey:@"data"];
        [self refreshView];
    }else{
        [self preparePreRequests];
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_problem_title", @"") andMessage:NSLocalizedString(@"general_problem_message", @"")] animated:YES completion:nil];
    }
}

#pragma mark - Stop ride (arrived)
-(void)stopRideAction{
    if([[_rideDataDictionary objectForKey:@"status"] isEqualToString:RIDE_STATUS_STARTED]){
        [self showLoadingView:YES];
        [self performSelectorInBackground:@selector(stopRideInBackground:) withObject:[_rideDataDictionary objectForKey:@"_id"]];
    }else{
        [self preparePreRequests];
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"OR_unexpectedActionTitle", @"") andMessage:NSLocalizedString(@"OR_unexpectedActionMessage", @"")] animated:YES completion:nil];
    }
}

-(void)stopRideInBackground:(NSString *)rideID{
    @autoreleasepool {
        NSArray *coordinatesArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", _applicationDelegate.currentLocation.coordinate.latitude], [NSString stringWithFormat:@"%f", _applicationDelegate.currentLocation.coordinate.longitude], nil];
        [RidesServiceManager stopRide:@{@"currentLocation" : coordinatesArray} andRideID:rideID :^(NSDictionary * response){
            [self performSelectorOnMainThread:@selector(finishStopRideInBackground:) withObject:response waitUntilDone:NO];
        }];
    }
}

-(void)finishStopRideInBackground:(NSDictionary *)response{
    [self showLoadingView:NO];
    if(([[response objectForKey:@"code"] intValue] == 200) && ([response objectForKey:@"data"])){
        NSLog(@"finishStopRideInBackground rideData %@", [response objectForKey:@"data"]);
        _rideDataDictionary = [response objectForKey:@"data"];
        [self refreshView];
    }else{
        [self preparePreRequests];
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_problem_title", @"") andMessage:NSLocalizedString(@"general_problem_message", @"")] animated:YES completion:nil];
    }
}

#pragma mark - Change Ride Destination

-(void)showDestinationContainer:(BOOL)show{
    if(show){
        _destinationContainerView.frame = CGRectMake(0, _headerView.frame.origin.y + _headerView.frame.size.height, _destinationContainerView.frame.size.width, _destinationContainerView.frame.size.height);
        [_destinationContainerView setHidden:NO];
        [self.view bringSubviewToFront:_destinationContainerView];
    }else{
        _destinationContainerView.frame = CGRectMake(0, self.view.frame.size.height, _destinationContainerView.frame.size.width, _destinationContainerView.frame.size.height);
        [_destinationContainerView setHidden:YES];
    }
    
}

- (IBAction)rideDestinationAction:(UIButton *)sender {
    [_destinationTextField becomeFirstResponder];
    [self showDestinationContainer:YES];
}
#pragma mark - Google Maps Autocomplete
- (void)placeAutocomplete:(NSString *)searchString {
    
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
    filter.country = @"sa";
    
    CLLocationCoordinate2D neBoundsCorner = CLLocationCoordinate2DMake(RIYADH_NE_CORNER_LATITUDE, RIYADH_NE_CORNER_LONGITUDE);
    CLLocationCoordinate2D swBoundsCorner = CLLocationCoordinate2DMake(RIYADH_SW_CORNER_LATITUDE, RIYADH_SW_CORNER_LONGITUDE);
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:neBoundsCorner
                                                                       coordinate:swBoundsCorner];

    [_placesClient autocompleteQuery:searchString
                              bounds:bounds
                              filter:filter
                            callback:^(NSArray *results, NSError *error) {
                                if (error != nil) {
                                    NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                    return;
                                }
                                NSLog(@"Search Results %@", results);
                                [destinationResultsArray removeAllObjects];
                                destinationResultsArray = [[NSMutableArray alloc] init];
                                
                                for (GMSAutocompletePrediction* result in results) {

                                    [destinationResultsArray addObject:result];
                                }
                                [_destinationTableView reloadData];
                                [_destinationContainerView setHidden:NO];
                            }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [destinationResultsArray count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if([destinationResultsArray count] > 0){
        GMSAutocompletePrediction* result = [destinationResultsArray objectAtIndex:indexPath.row];
        //Get selected address details
        [_placesClient lookUpPlaceID:result.placeID callback:^(GMSPlace *place, NSError *error) {
            if (error != nil) {
                NSLog(@"Place Details error %@", [error localizedDescription]);
                return;
            }
            
            if (place != nil) {

                NSArray *destinationArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", place.coordinate.latitude], [NSString stringWithFormat:@"%f", place.coordinate.longitude], nil];
                _headerPickupLabel.text = place.formattedAddress;
                [self showLoadingView:YES];
                [self performSelectorInBackground:@selector(updateRideDestinationInBackground:) withObject:@{@"coordinates" : destinationArray, @"rideID" : [_rideDataDictionary objectForKey:@"_id"]}];
                
            } else {

            }
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    GMSAutocompletePrediction* result = [destinationResultsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = result.attributedFullText.string;
    
    cell.textLabel.font = [UIFont fontWithName:@"Lato-Light" size:12];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void)updateRideDestinationInBackground:(NSDictionary *)data{
    @autoreleasepool {
        
        [RidesServiceManager updateRideDestination:@{@"dropoffLocation" : [data objectForKey:@"coordinates"]} andRideID:[data objectForKey:@"rideID"] :^(NSDictionary * response){
            [self performSelectorOnMainThread:@selector(finishUpdateRideDestinationInBackground:) withObject:response waitUntilDone:NO];
        }];
        
    }
}

-(void)finishUpdateRideDestinationInBackground:(NSDictionary *)response{
    [self showLoadingView:NO];
    [self showDestinationContainer:NO];
    if([[response objectForKey:@"code"] intValue] == 200){
        if([response objectForKey:@"data"]){
            NSLog(@"finishUpdateRideDestinationInBackground rideData %@", [response objectForKey:@"data"]);
            _rideDataDictionary = [response objectForKey:@"data"];
            [self preparePreRequests];
        }
        
    }else{
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_problem_title", @"") andMessage:NSLocalizedString(@"general_problem_message", @"")] animated:YES completion:nil];
    }
}
#pragma mark - textfield delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self showDestinationContainer:NO];
    return YES;
}

-(void)textFieldDidChange :(UITextField *)textField{
    [self placeAutocomplete:textField.text];
}

#pragma mark - Draw Routes
-(void)prepareCurrentRoute{
    NSString *rideStatus = [_rideDataDictionary objectForKey:@"status"];
    if(([rideStatus isEqualToString:RIDE_STATUS_ACCEPTED]) || ([rideStatus isEqualToString:RIDE_STATUS_NEARBY])){
        [_rideDestinationButton setHidden:YES];
        
        CLLocation *pickup = [[CLLocation alloc] initWithLatitude:[[[[_rideDataDictionary objectForKey:@"pickupLocation"] objectForKey:@"coordinates"] objectAtIndex:0] floatValue] longitude:[[[[_rideDataDictionary objectForKey:@"pickupLocation"] objectForKey:@"coordinates"] objectAtIndex:1] floatValue]];
        
        if(([_rideDataDictionary objectForKey:@"englishPickupAddress"]) && !([[_rideDataDictionary objectForKey:@"englishPickupAddress"] isKindOfClass:[NSNull class]]))
            _headerPickupLabel.text = [_rideDataDictionary objectForKey:@"englishPickupAddress"];
        
        [self drawMarkerAndRoute:pickup];
        
    }else if(([rideStatus isEqualToString:RIDE_STATUS_STARTED]) || ([rideStatus isEqualToString:RIDE_STATUS_ENDED]) || ([rideStatus isEqualToString:RIDE_STATUS_FINISHED])){
        [_rideDestinationButton setHidden:NO];
        if([HelperClass checkCoordinates:[_rideDataDictionary objectForKey:@"dropoffLocation"]]){
            
            if(([_rideDataDictionary objectForKey:@"englishDropoffAddress"]) && !([[_rideDataDictionary objectForKey:@"englishDropoffAddress"] isKindOfClass:[NSNull class]]))
                _headerPickupLabel.text = [_rideDataDictionary objectForKey:@"englishDropoffAddress"];
            else{
                [GoogleServicesManager getAddressFromCoordinates:[[[[_rideDataDictionary objectForKey:@"dropoffLocation"] objectForKey:@"coordinates"] objectAtIndex:0] floatValue] andLong:[[[[_rideDataDictionary objectForKey:@"dropoffLocation"] objectForKey:@"coordinates"] objectAtIndex:1] floatValue] :^(NSDictionary *response){
                    if(response){
                        if([response objectForKey:@"address"])
                            _headerPickupLabel.text = [response objectForKey:@"address"];
                    }
                }];
            }
            
            CLLocation *dropOff = [[CLLocation alloc] initWithLatitude:[[[[_rideDataDictionary objectForKey:@"dropoffLocation"] objectForKey:@"coordinates"] objectAtIndex:0] floatValue] longitude:[[[[_rideDataDictionary objectForKey:@"dropoffLocation"] objectForKey:@"coordinates"] objectAtIndex:1] floatValue]];
            [self drawMarkerAndRoute:dropOff];
        }
    }else{
        goClientRoute.map = nil;
        goClientRoute = nil;
        goClientPath = nil;
    }
}

#pragma mark - Get Client Address
-(void)drawMarkerAndRoute:(CLLocation *)loc{

    //Draw marker
    clientLocationMarker.map = nil;
    clientLocationMarker = nil;
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(loc.coordinate.latitude, loc.coordinate.longitude);
    clientLocationMarker = [[GMSMarker alloc] init];
    clientLocationMarker.position = coordinates;
    clientLocationMarker.tracksViewChanges = NO;
    
    clientLocationMarker.snippet = @"Client";
    clientLocationMarker.map = _mapView;
    
    [self drawGoRoute:loc];
}

-(void)drawGoRoute:(CLLocation *)location{
    //If ride status is accepted/nearby , Check distance first
    BOOL drawRoute = YES;
    if(([[_rideDataDictionary objectForKey:@"status"] isEqualToString:RIDE_STATUS_ACCEPTED]) || ([[_rideDataDictionary objectForKey:@"status"] isEqualToString:RIDE_STATUS_NEARBY])){
        if([HelperClass checkCoordinates:[_rideDataDictionary objectForKey:@"pickupLocation"]]){
            NSArray *pickupArray = [[_rideDataDictionary objectForKey:@"pickupLocation"] objectForKey:@"coordinates"];
            CLLocation *pickupLocation = [[CLLocation alloc] initWithLatitude:[[pickupArray objectAtIndex:0] floatValue] longitude:[[pickupArray objectAtIndex:1] floatValue]];
            CLLocationDistance distance = [_applicationDelegate.currentLocation distanceFromLocation:pickupLocation];
            if(distance < 300)
                drawRoute = NO;
        }
    }
    if(drawRoute){
        //Call GoogleMaps API to get route to pickup location
        [self performSelectorInBackground:@selector(getGoogleAPIPath:) withObject:location];
    }
}

-(void)getGoogleAPIPath:(CLLocation *)location{
    @autoreleasepool {
        [GoogleServicesManager getRouteFrom:_applicationDelegate.currentLocation.coordinate to:location.coordinate :^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishGetRouteToClient:) withObject:response waitUntilDone:NO];
        }];
    }
}
-(void)finishGetRouteToClient:(NSDictionary *)response{
    if([response objectForKey:@"status"]){
        if([[response objectForKey:@"status"] isEqualToString:@"OK"]){
            
            if([[response objectForKey:@"routes"] isKindOfClass:[NSArray class]]){
                if([[response objectForKey:@"routes"] objectAtIndex:0]){
                    if([[[response objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"overview_polyline"]){
                        NSDictionary *pathsV = [[[response objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"overview_polyline"];
                        
                        goClientRoute.map = nil;
                        goClientRoute = nil;
                        goClientPath = nil;
                        
                        goClientPath = [GMSMutablePath pathFromEncodedPath:[pathsV objectForKey:@"points"]];
                        goClientRoute = [GMSPolyline polylineWithPath:goClientPath];
                        goClientRoute.strokeWidth = 5;
                        goClientRoute.strokeColor = [UIColor grayColor];
                        GMSStrokeStyle *redBlue = [GMSStrokeStyle gradientFromColor:[UIColor colorWithRed:0.0/255.0f green:172.0/255.0f blue:250.0/255.0f alpha:1.0f] toColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f]];
                        goClientRoute.spans = @[[GMSStyleSpan spanWithStyle:redBlue]];
                        goClientRoute.map = _mapView;
                    }
                }
            }
        }
    }
}

#pragma mark - Button Actions
- (IBAction)callClientAction:(UIButton *)sender {

    NSString *phNo = [_client objectForKey:@"phone"];
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    [[UIApplication sharedApplication] openURL:phoneUrl options:@{} completionHandler:^(BOOL success) {
        if (success) {

        }
    }];
}

#pragma mark - Navigate To Client
- (IBAction)startNavigationAction:(UIButton *)sender {
    //Create ride URL
    NSURL *directionsURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
    
    //Should start navigation here (Google Maps)
    if([[UIApplication sharedApplication] canOpenURL:directionsURL]){
        NSURL *goClientURL = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps-x-callback://?daddr=%@&x-success=sourceapp://?resume=true&x-source=Procab&directionsmode=driving", [[[_rideDataDictionary objectForKey:@"pickupLocation"] objectForKey:@"coordinates"] componentsJoinedByString:@","]]];
        [[UIApplication sharedApplication] openURL:goClientURL options:@{} completionHandler:
         ^(BOOL success){}];
    }
}

#pragma mark - Driver Cancel Ride Work
- (IBAction)cancelRideAction:(UIButton *)sender {
    if([[_rideDataDictionary objectForKey:@"status"] isEqualToString:RIDE_STATUS_INITIATED]){
        [self cancelRideWithFees:NO];
    }else if([[_rideDataDictionary objectForKey:@"status"] isEqualToString:RIDE_STATUS_ARRIVED] || [[_rideDataDictionary objectForKey:@"status"] isEqualToString:RIDE_STATUS_ACCEPTED] || [[_rideDataDictionary objectForKey:@"status"] isEqualToString:RIDE_STATUS_NEARBY]){
//        [self cancelRideWithFees:[self checkIfFeesShouldBeApplied]];
        [self showCancelView:YES];
    }else{
        [self preparePreRequests];
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_problem_title", @"") andMessage:NSLocalizedString(@"general_problem_message", @"")] animated:YES completion:nil];
    }
}

-(BOOL)checkIfFeesShouldBeApplied{
    BOOL apply = NO;
    long long acceptedTime = [[_rideDataDictionary objectForKey:@"acceptedTime"] longValue];
    long long penaltyTime = acceptedTime + (60000 * 5);
    long long now = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    if((now - penaltyTime) > 0){
        apply = YES;
    }
    return apply;
}

-(void)showCancelView:(BOOL)show{
    if(show){
        [cancel removeFromSuperview];
        cancel = [[CancelView alloc] initWithFrame:self.view.bounds andArray:cancelationReasonsArray];
        cancel.delegate = self;
        cancel.alpha = 0.0f;
        [self.view addSubview:cancel];
        [UIView animateWithDuration:0.4 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             cancel.alpha = 1.0f;
                         } completion:^(BOOL finished){}];
    }else{
        [UIView animateWithDuration:0.4 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             cancel.alpha = 0.0f;
                         } completion:^(BOOL finished){
                             [cancel removeFromSuperview];
                         }];
    }
}

-(void)cancelWithReason:(NSString *)reason{
    NSDictionary *parameters = @{
                                 @"currentLocation" : [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f",_applicationDelegate.currentLocation.coordinate.latitude], [NSString stringWithFormat:@"%f",_applicationDelegate.currentLocation.coordinate.longitude], nil],
                                 @"reason" : reason
                                 };
    [self performSelectorInBackground:@selector(cancelRideInBackground:) withObject:parameters];
}

-(void)hideCancelView{
    [self showCancelView:NO];
}

-(void)cancelRideWithFees:(BOOL)feesShouldApplied{
    NSString *title = NSLocalizedString(@"OR_beforeCancelWarningTitle", @"");
    NSString *message = NSLocalizedString(@"OR_beforeCancelWarningNoFeeMessage", @"");
    
    if(feesShouldApplied)
        message = NSLocalizedString(@"OR_beforeCancelWarningWithFeeMessage", @"");
    
    
    UIAlertController * alert=[UIAlertController
                               
                               alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesBtn = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"general_yes", @"")
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self showLoadingView:YES];
                                 [self performSelectorInBackground:@selector(cancelRideInBackground:) withObject:[_rideDataDictionary objectForKey:@"_id"]];
                             }];
    UIAlertAction *noBtn = [UIAlertAction
                            actionWithTitle:NSLocalizedString(@"general_no", @"")
                            style:UIAlertActionStyleDefault
                            handler:nil];
    [alert addAction:noBtn];
    [alert addAction:yesBtn];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)cancelRideInBackground:(NSDictionary *)parameters{
    @autoreleasepool {
        
        [RidesServiceManager cancelRideRequest:parameters andRideID:[_rideDataDictionary objectForKey:@"_id"] :^(NSDictionary *response) {
            [self performSelectorOnMainThread:@selector(finishCancelRide:) withObject:response waitUntilDone:NO];
        }];
    }
}
-(void)finishCancelRide:(NSDictionary *)response{
    [self showLoadingView:NO];
    [self hideCancelView];
    if([response objectForKey:@"driver"]){
        [ServiceManager saveLoggedInDriverData:[response objectForKey:@"driver"] andAccessToken:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation to Ride DropOff Location
-(void)navigateToRideDestination{
    //Create ride URL
    NSURL *directionsURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
    
    //Should start navigation here (Google Maps)
    if([[UIApplication sharedApplication] canOpenURL:directionsURL]){
        NSURL *goClientURL = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps-x-callback://?daddr=%@&x-success=sourceapp://?resume=true&x-source=Procab&directionsmode=driving", [[[_rideDataDictionary objectForKey:@"dropoffLocation"] objectForKey:@"coordinates"] componentsJoinedByString:@","]]];
        [[UIApplication sharedApplication] openURL:goClientURL options:@{} completionHandler:
         ^(BOOL success){

         }];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goPaymentSegue"]) {
    }
}

#pragma mark - LoadingView
-(void)showLoadingView:(BOOL)show{
    if(show){
        loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        loadingView.backgroundColor = [UIColor darkGrayColor];
        loadingView.alpha = 0.9;
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
        indicator.center = loadingView.center;
        [indicator startAnimating];
        indicator.color = [UIColor blackColor];
        [loadingView addSubview:indicator];
        
        [self.view addSubview:loadingView];
        [self.view bringSubviewToFront:loadingView];
    }else{
        [loadingView removeFromSuperview];
    }
}

#pragma mark - Memory Warnings
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
