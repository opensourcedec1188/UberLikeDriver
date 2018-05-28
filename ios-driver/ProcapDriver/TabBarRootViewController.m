//
//  TabBarRootViewController.m
//  ProcapDriver
//
//  Created by MacBookPro on 4/29/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "TabBarRootViewController.h"
#import "AppDelegate.h"

@interface TabBarRootViewController ()
@property (nonatomic, strong) AppDelegate *applicationDelegate;
@end

@implementation TabBarRootViewController


-(void)appBecameActive{
    //If not coming from PushNotification request, Set normal listening
    NSDictionary *params = [[NSUserDefaults standardUserDefaults] objectForKey:@"PNRideParameters"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PNRideParameters"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"appBecameActive _pnRideParams : %@", _pnRideParams);
    if(!params){
        [self setListeningStateForNormalState];
    }else{
        _pnRideParams = nil;
        [self showRideRequestView:[params objectForKey:@"data"]];
    }
}

-(void)enterForeGround{
    [self initiatePubnubClient];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _applicationDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //Add observer for coming from foreground
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecameActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeGround) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //Tabbar Work
    self.tabBarController = [[UITabBarController alloc] init];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    mapController = (MapViewController *)[storyboard instantiateViewControllerWithIdentifier:@"mapController"];
    mapController.tabBarItem.title = NSLocalizedString(@"home", @"");
    mapController.tabBarItem.image = [UIImage imageNamed:@"TabbarHomeIcon"];
    
    EarningsViewController *earningsController = (EarningsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"earningsController"];
    earningsController.tabBarItem.title = NSLocalizedString(@"earnings", @"");
    earningsController.delegate = self;
    earningsController.tabBarItem.image = [UIImage imageNamed:@"TabbarEarningIcon"];
    
    NewsViewController *newsController = (NewsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"newsController"];
    newsController.tabBarItem.title = NSLocalizedString(@"news", @"");
    newsController.tabBarItem.image = [UIImage imageNamed:@"TabbarNewsIcon"];
    
    AccountViewController *accountController = (AccountViewController *)[storyboard instantiateViewControllerWithIdentifier:@"accountController"];
    accountController.tabBarItem.title = NSLocalizedString(@"account", @"");
    accountController.delegate = self;
    accountController.tabBarItem.image = [UIImage imageNamed:@"TabbarAccountIcon"];
    
    NSArray* controllers = [NSArray arrayWithObjects:mapController, earningsController, newsController, accountController, nil];
    self.tabBarController.viewControllers = controllers;
    
    self.tabBarController.selectedIndex = 0;
    [self.view addSubview:self.tabBarController.view];
    
    //Tabbar BG Color
    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithRed:15.0/255.0f green:20.0/255.0f blue:30.0/255.0f alpha:1.0f]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:15.0/255.0f green:20.0/255.0f blue:30.0/255.0f alpha:1.0f]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName:[UIFont fontWithName:FONT_ROBOTO_REGULAR size:11.0f]
                                                        } forState:UIControlStateNormal];
    [UITabBarItem appearance].titlePositionAdjustment = UIOffsetMake(0, -4);
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:1.0f]];
    [[UITabBar appearance] setUnselectedItemTintColor:[UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:0.5f]];

    self.tabBarController.view.clipsToBounds = NO;
    [self setStateSwitch];
    
    /*Top header work*/
    [self.tabBarController.view addSubview:_fixedHeaderView];
    [self.tabBarController.view bringSubviewToFront:_fixedHeaderView];
    _fixedHeaderView.clipsToBounds = NO;

    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_fixedHeaderView edgeInset:UIEdgeInsetsMake(-1.0f, -1.0f, -1.0f, -1.0f) andShadowRadius:5.0f];
    _fixedHeaderView.layer.shadowPath = shadowPath.CGPath;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Controllers Delegates
#pragma mark - Earning
-(void)goToProfitSummary:(int)type{
    if(type == 0){
        DailySummaryViewController *controller = [[DailySummaryViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        WeeklySummaryViewController *controller = [[WeeklySummaryViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }

}

-(void)goToBalance{
    BalanceTransactionsViewController *controller = [[BalanceTransactionsViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)goToInvitation{
    ReferralCodeViewController *controller = [[ReferralCodeViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - Account
-(void)GoToDocuments{
    DocumentsViewController *controller = [[DocumentsViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)goToSettings{
    SettingsViewController *controller = [[SettingsViewController alloc] init];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)goToAccountInfo{
    AccountInfoViewController *controller = [[AccountInfoViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)goToRating{
    RatingSummaryViewController *controller = [[RatingSummaryViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)goToPayment{
    AccountPaymentViewController *controller = [[AccountPaymentViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)goHelp{
    HelpViewController *controller = [[HelpViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Settings Controller
-(void)dismissAfterLogout{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setStateSwitch{
    if([[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"isOnDuty"] intValue] == 1){
        _fixedHeaderView.backgroundColor = [UIColor colorWithRed:0.0/255.0f green:152.0/255.0f blue:135.0/255.0f alpha:1.0f];
        _statusLabel.text = NSLocalizedString(@"status_online", @"");
        [_stateSwitch setOn:YES];
    }else{
        _fixedHeaderView.backgroundColor = [UIColor colorWithRed:26.0/255.0f green:35.0/255.0f blue:52.0/255.0f alpha:1.0f];
        _statusLabel.text = NSLocalizedString(@"status_offline", @"");
        [_stateSwitch setOn:NO];
    }

    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_fixedHeaderView edgeInset:UIEdgeInsetsMake(-1.0f, -1.0f, -1.0f, -1.0f) andShadowRadius:5.0f];
    _fixedHeaderView.layer.shadowPath = shadowPath.CGPath;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedRemoteNotification:)
                                                 name:@"RemoteNotification"
                                               object:nil];
    
    //Driver isOnDuty Status
    NSLog(@"viewWillAppear _pnRideParams : %@", _pnRideParams);
    if(![[_pnRideParams objectForKey:@"event"] isEqualToString:@"ride-initiated"])
        [self performSelectorInBackground:@selector(getDriverDataFromServer) withObject:nil];
    else{
        NSDictionary *params = _pnRideParams;
        _pnRideParams = nil;
        [self showRideRequestView:[params objectForKey:@"data"]];
    }
    [self initiatePubnubClient];
}

-(void)receivedRemoteNotification:(NSDictionary *)userInfo{

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

//-(void)dismissTabBar{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - Listening To Rides Requests
-(void)setListeningStateForNormalState{
    if([[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"isOnDuty"] intValue] == 1){
        [_stateSwitch setOn:YES];
        driverOnline = YES;
        if(([[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"isOnRide"] intValue] == 1))
            [self performSegueWithIdentifier:@"onRideSegue" sender:self];
        
    }else{
        [_stateSwitch setOn:NO];
        driverOnline = NO;
    }
    [_applicationDelegate activateTrackingTimer];
}
-(void)getDriverDataFromServer{
    @autoreleasepool {
        [ServiceManager getDriverData:[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"] :^(NSDictionary *response) {
            [self performSelectorOnMainThread:@selector(finishGetDriverDara:) withObject:response waitUntilDone:NO];
        }];
    }
}
-(void)finishGetDriverDara:(NSDictionary *)response{
    if([response objectForKey:@"data"]){
        [ServiceManager saveLoggedInDriverData:[response objectForKey:@"data"] andAccessToken:nil];
        [self setListeningStateForNormalState];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Driver On Duty Work

- (IBAction)changeDriverState:(UISwitch *)sender {
    [self showLoadingView:YES];
    NSString *isOnDuty = @"";
    if (sender.isOn)
    {
        // for segment index 0, Go online
        isOnDuty = @"true";
    }
    [self performSelectorInBackground:@selector(changeOnDutyStatus:) withObject:isOnDuty];
}

-(void)changeOnDutyStatus:(NSString *)onDuty{
    @autoreleasepool {
        NSArray *locationObject = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", _applicationDelegate.currentLocation.coordinate.latitude], [NSString stringWithFormat:@"%f", _applicationDelegate.currentLocation.coordinate.longitude], nil];
        
        [RidesServiceManager setDriverOnRide:@{@"currentLocation" : locationObject, @"isOnDuty" : onDuty} :^(NSDictionary *driverStateData) {
            [self performSelectorOnMainThread:@selector(finishOnDutyStatusChange:) withObject:driverStateData waitUntilDone:NO];
        }];
    }
}

-(void)finishOnDutyStatusChange:(NSDictionary *)response{
    NSLog(@"finishOnDutyStatusChange : %@", response);
    [self showLoadingView:NO];
    if(response && ([response objectForKey:@"data"])){
        [ServiceManager saveLoggedInDriverData:[response objectForKey:@"data"] andAccessToken:nil];
        if([[[response objectForKey:@"data"] objectForKey:@"isOnDuty"] intValue] == 1){
            driverOnline = YES;
            [_applicationDelegate initiateLocationManager];
            [_applicationDelegate activateTrackingTimer];
            [self initiatePubnubClient];
        }else{
            driverOnline = NO;
            [_applicationDelegate.normalLocationTimer invalidate];
        }
    }else{
        driverOnline = NO;
    }
    [self setStateSwitch];
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"onRideSegue"]) {
        // Destination VC
        OnRideViewController *onRideController = [segue destinationViewController];
        // Pass ride parameters to VC
        onRideController.rideDataDictionary = acceptedRide;
    }
}


#pragma mark - LoadingView
-(void)showLoadingView:(BOOL)show{
    if(show){
        loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        loadingView.backgroundColor = [UIColor whiteColor];
        loadingView.alpha = 0.3;
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

-(void)initiatePubnubClient{
    if(!_waitingRideManager){
        _waitingRideManager = [[RealTimePubnub alloc] initManager:NO];
        [_waitingRideManager listenToChannelName:[NSString stringWithFormat:@"drivers-%@", [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]]];
        _waitingRideManager.listnerDelegate = self;
    }else{
        [_waitingRideManager endListening];
        [_waitingRideManager listenToChannelName:[NSString stringWithFormat:@"drivers-%@", [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]]];
        _waitingRideManager.listnerDelegate = self;
    }
}

#pragma mark - RealTimeManagerDelegate
#pragma mark - Pubnub Messages Receive delegate (Pubnub)
-(void)receivedMessageOnPupnub:(NSDictionary *)message{
    NSLog(@"receivedMessageOnPupnub : %@", message);
    NSString *event = [message objectForKey:@"event"];
    if([event isEqualToString:@"ride-initiated"]){
        if([message objectForKey:@"data"]){
            if([[message objectForKey:@"data"] objectForKey:@"rideId"]){
                
                [self showRideRequestView:[message objectForKey:@"data"]];
            }
        }else{
            [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"TBC_NoAvailableData", @"") andMessage:NSLocalizedString(@"TBC_NoAvailableData", @"")] animated:YES completion:nil];
        }
        
    }else if ([event isEqualToString:@"ride-canceled"]){
        [_rideRequestVeiw stopSound];
        newRequestCurrentShowing = NO;
        [_rideRequestVeiw finishedRequestRideTime];
        [self initiatePubnubClient];
    }
}


#pragma mark - Received ride request
-(void)hideTabbar:(BOOL)show{
    
}
//Show Ride Acceptance View
-(void)showRideRequestView:(NSDictionary *)ride{
    if(!newRequestCurrentShowing){
        _rideRequestVeiw = (RideAcceptCustomView *)[self.view viewWithTag:76];
        if(_rideRequestVeiw){
            NSLog(@"_rideRequestVeiw tag 76 exists, REMOVE");
            [_rideRequestVeiw removeFromSuperview];
            _rideRequestVeiw = nil;
        }
        [self hideTabbar:NO];
        long long now = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
        long long expiry = [[ride objectForKey:@"expiry"] longValue];
        long long differ = expiry - now;
        
        differ = differ/1000.0;
        if(differ > 0){
            
            [_rideRequestVeiw removeFromSuperview];
            _rideRequestVeiw = nil;
            newRequestCurrentShowing = YES;
            _rideRequestVeiw = [[RideAcceptCustomView alloc] initWithFrame:CGRectMake(0, _rideRequestVeiw.containerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) andRideParameters:ride];
            _rideRequestVeiw.tag = 76;
            _rideRequestVeiw.delegate = self;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_rideRequestVeiw];
            [UIView animateWithDuration:0.2
                                  delay: 0.0
                                options: UIViewAnimationOptionLayoutSubviews
                             animations:^{
                                 _rideRequestVeiw.frame = self.view.bounds;
                             }completion:^(BOOL finished){}];
        }
    }else{
        NSLog(@"newRequestCurrentShowing YES");
        [_rideRequestVeiw playSound];
        newRequestCurrentShowing = NO;
    }
}


- (void)acceptRideRequest:(NSString *)rideID
{
    [self showLoadingView:YES];
    
    newRequestCurrentShowing = NO;
    [_rideRequestVeiw finishedRequestRideTime];
    _rideRequestVeiw = nil;
    
    [self performSelectorInBackground:@selector(acceptRideInBackground:) withObject:rideID];
}

-(void)acceptRideInBackground:(NSString *)rideID{
    @autoreleasepool {
        NSDictionary *parameters = @{
                                     @"currentLocation" : [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f",_applicationDelegate.currentLocation.coordinate.latitude], [NSString stringWithFormat:@"%f",_applicationDelegate.currentLocation.coordinate.longitude], nil]
                                     };
        [RidesServiceManager acceptRideRequest:parameters andRideID:rideID :^(NSDictionary *response) {
            [self performSelectorOnMainThread:@selector(finishRideAcceptanceRequest:) withObject:response waitUntilDone:NO];
        }];
    }
}

-(void)finishRideAcceptanceRequest:(NSDictionary *)response{
    
    if([response objectForKey:@"data"]){
        NSLog(@"ride accepted : %@", response);
        //Get Ride Details
        acceptedRide = [response objectForKey:@"data"];
        //Go to StartRide Screen
        [self performSegueWithIdentifier:@"onRideSegue" sender:self];
        
        if([response objectForKey:@"driver"])
            [ServiceManager saveLoggedInDriverData:[response objectForKey:@"driver"] andAccessToken:nil];
    }else{
        
    }
    [self showLoadingView:NO];
}

@end
