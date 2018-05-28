//
//  AppDelegate.m
//  ProcapDriver
//
//  Created by MacBookPro on 3/8/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "AppDelegate.h"
@import GoogleMaps;
@import GooglePlaces;

@import UserNotifications;

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize appRules, idImage, drivingLicenseImage, vehicleRegImage;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    firstLocationSent = NO;
    
    [self initiateLocationManager];
    
    if(launchOptions){
        [[NSUserDefaults standardUserDefaults] setObject:(NSDictionary *)[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] forKey:@"PNRideParameters"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //Clear Old Notifications
    [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
        
    [GMSServices provideAPIKey:GMS_SERVICE_KEY];
    [GMSPlacesClient provideAPIKey:GMS_SERVICE_KEY];
    //Show top bar network indicator for all requests
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    //App version
    _appVersion = @"dev1.2";
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    [NewRelicAgent startWithApplicationToken:NEWRELIC_APP_TOKEN];
    
    /*Pubnub Push Notifications*/
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 10) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            switch (settings.authorizationStatus) {
                    // This means we have not yet asked for notification permissions
                case UNAuthorizationStatusNotDetermined:
                {
                    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                        // You might want to remove this, or handle errors differently in production
                        NSAssert(error == nil, @"There should be no error");
                        if (granted) {
                            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                            center.delegate = self;
                            [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
                                if(!error){
                                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                                }
                            }];
                        }
                    }];
                }
                    break;
                    // We are already authorized, so no need to ask
                case UNAuthorizationStatusAuthorized:
                {
                    // Just try and register for remote notifications
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                }
                    break;
                    // We are denied User Notifications
                case UNAuthorizationStatusDenied:
                {
                    // Possibly display something to the user
                    UIAlertController *useNotificationsController = [UIAlertController alertControllerWithTitle:@"Turn on notifications" message:@"This app needs notifications turned on for the best user experience" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *goToSettingsAction = [UIAlertAction actionWithTitle:@"Go to settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
                    [useNotificationsController addAction:goToSettingsAction];
                    [useNotificationsController addAction:cancelAction];
                    [self.window.rootViewController presentViewController:useNotificationsController animated:true completion:nil];
                    NSLog(@"We cannot use notifications because the user has denied permissions");
                }
                    break;
            }
            
        }];
    } else if ((systemVersion < 10) || (systemVersion >= 8)) {
        UIUserNotificationType types = (UIUserNotificationTypeBadge | UIUserNotificationTypeSound |
                                        UIUserNotificationTypeAlert);
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    } else {
        NSLog(@"We cannot handle iOS 7 or lower in this example. Contact support@pubnub.com");
    }
    
    //Timer for HTTP sending location
    [_normalHTTPLocationTimer invalidate];
    _normalHTTPLocationTimer = nil;
    _normalHTTPLocationTimer = [NSTimer scheduledTimerWithTimeInterval:30
                                                                target:self
                                                              selector:@selector(timerfiredForNormalHTTPTracking)
                                                              userInfo:nil
                                                               repeats:YES];
    _locationsArray = [[NSMutableArray alloc] init];
    _locationsToBeSnapped = [[NSMutableArray alloc] init];
    _snappedLocationsArray = [[NSMutableArray alloc] init];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10
                                                                target:self
                                                              selector:@selector(sendFirstDriverLocation)
                                                              userInfo:nil
                                                               repeats:NO];
    
    if([[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"isOnDuty"] intValue] == 1){
        [self activateTrackingTimer];
    }
    
    NSLog(@" systemVersion : %f", systemVersion);
    if(systemVersion < 9.0f){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    return YES;
}

-(void)sendFirstDriverLocation{
    if([[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"isOnDuty"] intValue] == 1)
        [self performSelectorInBackground:@selector(sendDriverLocation) withObject:nil];
}

-(void)initiateLocationManager{
    
    //Get location work
    if(_locationManager)
        _locationManager = nil;
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager requestWhenInUseAuthorization];
    _locationManager.distanceFilter = 5;
    if([[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"isOnDuty"] intValue] == 1)
        _locationManager.allowsBackgroundLocationUpdates = YES;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *hexToken = [HelperClass HEXFromDevicePushToken:deviceToken];
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"DeviceToken"];
    [[NSUserDefaults standardUserDefaults] setObject:hexToken forKey:@"DeviceTokenString"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%s with error: %@", __PRETTY_FUNCTION__, error);
}
-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if ([UIApplication sharedApplication].applicationState==UIApplicationStateActive) {
        NSLog(@"App already open");
    } else {
        NSLog(@"App opened from Notification : %@", userInfo);
        if([[userInfo objectForKey:@"event"] isEqualToString:@"ride-initiated"]){
            [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"PNRideParameters"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    if([[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"isActive"] intValue] == 1){
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:options
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (!granted) {
                                      NSLog(@"Something went wrong");
                                  }
                              }];
        
        //If driver on-duty, create background task
        if([[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"isOnDuty"] intValue] == 1){
            
            if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)])
                self.locationManager.allowsBackgroundLocationUpdates =YES;
            [self activateTrackingTimer];
            //Create the task object
            bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler: ^ {
                [[UIApplication sharedApplication] endBackgroundTask: bgTask]; //Tell the system that we are done with the tasks
                bgTask = UIBackgroundTaskInvalid; //Set the task to be invalid
            }];
            
            //Background tasks require you to use asyncrous tasks
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //Update normal location pubnub
                [self activateTrackingTimer];
                [[NSRunLoop currentRunLoop] run];
                
            });
        }else{
            //Not on-duty, Clear timers and end locations update in background
            [_locationManager stopUpdatingLocation];
            [_normalLocationTimer invalidate];
            _normalLocationTimer = nil;
        }
    }
    
}
       
-(void)activateTrackingTimer{
    if([[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"isOnDuty"] intValue] == 1){
        //Update normal location pubnub
        [_normalLocationTimer invalidate];
        _normalLocationTimer = nil;
        _normalLocationTimer = [NSTimer scheduledTimerWithTimeInterval:6
                                                                target:self
                                                              selector:@selector(timerfiredForNormalTracking)
                                                              userInfo:nil
                                                               repeats:YES];
    }
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application endBackgroundTask: bgTask]; //Tell the system that we are done with the tasks
    bgTask = UIBackgroundTaskInvalid; //Set the task to be invalid
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"applicationWillTerminate");
    if([[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"isOnDuty"] intValue] == 1){
        [RidesServiceManager setDriverOnRide:@{@"isOnDuty" : @""} :^(NSDictionary *driverStateData) {}];
    }
}


#pragma mark - RealTimeManagerDelegate
#pragma mark - Pubnub Messages Receive delegate
-(void)receivedMessageOnPupnub:(NSDictionary *)message{
    NSString *event = [message objectForKey:@"event"];
    NSLog(@"Finally, received in background");
    //Local notification
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    
    content.sound = [UNNotificationSound defaultSound];
    content.badge = @-1;
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1
                                                                                                    repeats:NO];
    // Create the request object.
    UNNotificationRequest* request = [UNNotificationRequest
                                      requestWithIdentifier:@"Rides" content:content trigger:trigger];
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    if([event isEqualToString:@"ride-initiated"]){
        content.title = [NSString localizedUserNotificationStringForKey:@"New Ride Request" arguments:nil];
        content.body = [NSString localizedUserNotificationStringForKey:@"You have a new ride request"
                                                             arguments:nil];
    }else if ([event isEqualToString:@"ride-canceled"]){
        content.title = [NSString localizedUserNotificationStringForKey:@"Ride Canceled" arguments:nil];
        content.body = [NSString localizedUserNotificationStringForKey:@"Client has canceled the ride"
                                                             arguments:nil];
        //Must get new driver data from server, On-Ride should be changed to 0
        [self performSelectorInBackground:@selector(getDriverNewDataAfterRideCanceled) withObject:nil];
    }
    //Local Notification
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"errr %@", error.localizedDescription);
        }
    }];
}


//Timer for normal tracking
-(void)timerfiredForNormalTracking{
    if(_locationsArray.count > 10){
        if([ServiceManager getDriverDataFromUserDefaults]){
            NSString *driverID = [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"];
            NSString *channelName = [NSString stringWithFormat:@"driver-tracking-%@", driverID];
            if([[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"isOnRide"] intValue] == 1){
                NSString *rideID = [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"lastRideId"];
                channelName = [NSString stringWithFormat:@"ride-tracking-%@", rideID];
            }
            //If pubnub manager not initialized
            if(!_pubnubManager)
                _pubnubManager = [[RealTimePubnub alloc] initManager:YES];
            
            NSLog(@"AppDelegate timerfiredForNormalTracking Pubnub channel name %@ with params : %@", channelName, _locationsArray);
            
            if(_locationsArray && ([_locationsArray count] > 0)){
                NSMutableArray *locationsToSnap = [[NSMutableArray alloc] initWithArray:[_locationsArray copy]];
                [GoogleServicesManager snapCoordinates:locationsToSnap :^(NSDictionary *response){
                    NSLog(@"AppDelegate snap Coordinates Response : %@", response);
                    
                    if(response){
                        [_pubnubManager publishLocation:@{@"locationInfo" : response, @"channel" : channelName} andChannelName:channelName];
                    }else{
                        NSArray *testArray = [[NSArray alloc] initWithArray:_locationsArray];
                        [_pubnubManager publishLocation:@{@"locationInfo" : @{@"locations" : testArray}, @"channel" : channelName} andChannelName:channelName];
                    }
                    [_locationsArray removeAllObjects];
                    if([response objectForKey:@"heading"]){
                        NSString *lastUpdatedHeadin = [response objectForKey:@"heading"];
                        if(lastUpdatedHeadin.length > 0){
                            if([lastUpdatedHeadin floatValue] > 0)
                                _lastHeading = [response objectForKey:@"heading"];
                        }else{
                            _lastHeading = [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"lastLocationHeading"];
                        }
                    }
                }];
            }
            //////////////////////////////////////////
            
            /*NEW TRACKING (MOVIEONE)*/
            //    if(_snappedLocationsArray.count > 10){
            //        NSMutableArray *punbunLocationsArray = [[NSMutableArray alloc] init];
            //        NSMutableArray *newSnappedArray = [[NSMutableArray alloc] init];
            //
            //        for (int i = 0 ; i < [_snappedLocationsArray count] ; i++){
            //            if(i < 5)
            //                [punbunLocationsArray addObject:[_snappedLocationsArray objectAtIndex:i]];
            //            else
            //                [newSnappedArray addObject:[_snappedLocationsArray objectAtIndex:i]];
            //        }
            //        NSLog(@"will publish message %@", punbunLocationsArray);
            //        [_pubnubManager publishLocation:@{@"locationInfo" : @{@"locations" : punbunLocationsArray}, @"channel" : channelName} andChannelName:channelName];
            //        _snappedLocationsArray = newSnappedArray;
            //
            //    }
        }
    }
}


#pragma mark - Get driver data
-(void)getDriverNewDataAfterRideCanceled{
    @autoreleasepool {
        [ServiceManager getDriverData:[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"] :^(NSDictionary *response) {
            [self performSelectorOnMainThread:@selector(finishGetDriverData:) withObject:response waitUntilDone:NO];
        }];
    }
}
-(void)finishGetDriverData:(NSDictionary *)response{
    if([response objectForKey:@"data"])
        [ServiceManager saveLoggedInDriverData:[response objectForKey:@"data"] andAccessToken:nil];
}

#pragma mark - Send Driver Location every 2 minutes

-(void)timerfiredForNormalHTTPTracking{
    if([[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"isOnDuty"] intValue] == 1)
        [self performSelectorInBackground:@selector(sendDriverLocation) withObject:nil];
}

-(void)sendDriverLocation{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/drivers/%@/current-location", BASE_URL, [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]];
    if([[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"isOnRide"] intValue] == 1){
        NSString *rideID = [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"lastRideId"];
        urlString = [NSString stringWithFormat:@"%@/rides/%@/current-location", BASE_URL, rideID];
    }
    
    @autoreleasepool {
        NSDictionary *parameters = @{
                                     @"currentLocation" : [NSArray arrayWithObjects:[NSNumber numberWithFloat:_currentLocation.coordinate.latitude], [NSNumber numberWithFloat:_currentLocation.coordinate.longitude], nil],
                                     @"heading": _lastHeading ? _lastHeading : @""
                                     };
        [RidesServiceManager sendDriverLocation:urlString params:parameters :^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishSendDriverLocation:) withObject:response waitUntilDone:NO];
        }];
    }
}
-(void)finishSendDriverLocation:(NSDictionary *)response{
    NSLog(@"finishSendDriverLocation : %@", response);
    if([response objectForKey:@"data"]){
        [ServiceManager saveLoggedInDriverData:[response objectForKey:@"data"] andAccessToken:nil];
    }
}

-(void)timerFiredForSnapToRoad{
    NSLog(@"timerFiredForSnapToRoad : %@", _locationsToBeSnapped);
    if(!_snappedLocationsArray)
        _snappedLocationsArray = [[NSMutableArray alloc] init];
    if(_locationsToBeSnapped && ([_locationsToBeSnapped count] > 0)){
        
        [GoogleServicesManager snapCoordinates:_locationsToBeSnapped :^(NSDictionary *response){
            if(response){
                if([response objectForKey:@"locations"]){
                    NSArray *locations = [response objectForKey:@"locations"];
                    for(NSDictionary *dict in locations)
                        [_snappedLocationsArray addObject:dict];
                }
            }
        }];
        [_locationsToBeSnapped removeAllObjects];
        _locationsToBeSnapped = nil;
    }
}

#pragma mark - LocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    self.currentLocation = [locations lastObject];
    if(!_locationsArray)
        _locationsArray = [[NSMutableArray alloc] init];
    
    NSDictionary *locObject = @{@"latitude" : [[NSNumber numberWithDouble:self.currentLocation.coordinate.latitude] stringValue], @"longitude" : [[NSNumber numberWithDouble:self.currentLocation.coordinate.longitude] stringValue]};
    
    [_locationsArray addObject:locObject];
    
//    if(!_locationsToBeSnapped)
//        _locationsToBeSnapped = [[NSMutableArray alloc] init];
//
//    if(_locationsToBeSnapped.count < 40)
//        [_locationsToBeSnapped addObject:@{@"latitude" : [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.latitude], @"longitude" : [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.longitude]}];
//    else
//        [self timerFiredForSnapToRoad];
    
    if(!firstLocationSent){
        firstLocationSent = YES;
        [self performSelectorInBackground:@selector(sendDriverLocation) withObject:nil];
    }
    
    

}

@end
