//
//  SplashViewController.m
//  ProcapDriver
//
//  Created by MacBookPro on 4/19/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "SplashViewController.h"
#import "AppDelegate.h"
#import "Reachability.h"

@interface SplashViewController ()
@property (nonatomic, strong) AppDelegate *applicationDelegate;
@property (nonatomic) Reachability *internetReachability;
@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.applicationDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([HelperClass checkNetworkReachability]){
        [self performSelectorInBackground:@selector(fetchAppRules) withObject:nil];
        if([ServiceManager getDriverDataFromUserDefaults]){
            [self performSelectorInBackground:@selector(getDriverImage) withObject:nil];
            
            [self performSelectorInBackground:@selector(getVehicleImage) withObject:nil];
        }
    }else
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"network_problem_title", @"") andMessage:NSLocalizedString(@"network_problem_message", @"")] animated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NSLog(@"notification : %@", curReach);
    NSLog(@"Reachable %ld", (long)[curReach currentReachabilityStatus]);
    if(!((long)curReach.currentReachabilityStatus == 0)){
        [self performSelectorInBackground:@selector(fetchAppRules) withObject:nil];
    }else{
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"network_problem_title", @"") andMessage:NSLocalizedString(@"network_problem_message", @"")] animated:YES completion:nil];
    }
}

-(void)fetchAppRules{
    @autoreleasepool {
        if([HelperClass checkNetworkReachability]){
            [ServiceManager getAppRules: ^(NSDictionary *data) {
                NSLog(@"no app rules, will get");
                self.applicationDelegate.appRules = [data objectForKey:@"data"];
                
                [ServiceManager setDriverState:^(NSDictionary *state) {
                    NSLog(@"here with state : %@", [state objectForKey:@"segue"]);
                    NSDictionary *dataToPass = @{
                                                 @"state" : state,
                                                 @"rules" : [data objectForKey:@"data"] ? [data objectForKey:@"data"] : @"emptyRules"
                                                 };
                    [self performSelectorOnMainThread:@selector(finishAppRulesRequest:) withObject:dataToPass waitUntilDone:NO];
                }];
            }];
        }
    }
}

-(void)finishAppRulesRequest:(NSDictionary *)data{
    
    [self.applicationDelegate initiateLocationManager];
    
    NSString *segue = [[data objectForKey:@"state"] objectForKey:@"segue"];
    if(([segue isEqualToString:@"splashGoOnRide"]) || ([segue isEqualToString:@"splashGoPayment"])){
        currentRideData = [[data objectForKey:@"state"] objectForKey:@"currentRide"];
        NSLog(@"currentRide : %@", currentRideData);
        [self performSegueWithIdentifier:segue sender:self];
    }else if([segue isEqualToString:@"goLoginSegue"]){
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"PreLogin" bundle:nil];
        UIViewController *theInitialViewController = [secondStoryBoard instantiateInitialViewController];
        [self presentViewController:theInitialViewController animated:YES completion:nil];
    }else if([segue isEqualToString:@"goInspection"]){
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"PreLogin" bundle:nil];
        UIViewController *theInitialViewController = [secondStoryBoard instantiateViewControllerWithIdentifier:@"GoInspectionController"];
        [self presentViewController:theInitialViewController animated:YES completion:nil];
    }else if([segue isEqualToString:@"goSignUp"]){
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"PreLogin" bundle:nil];
        UIViewController *theInitialViewController = [secondStoryBoard instantiateViewControllerWithIdentifier:@"RegisterRootController"];
        [self presentViewController:theInitialViewController animated:YES completion:nil];
    }else{
        [self performSegueWithIdentifier:segue sender:self];
    }
}

-(void)getDriverImage{
    @autoreleasepool {
        [ProfileServiceManager getDriverImage:[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"photoUrl"] :^(NSData *response){
            [self performSelectorOnMainThread:@selector(finishGetDriverImage:) withObject:response waitUntilDone:NO];
        }];
    }
}
-(void)finishGetDriverImage:(NSData *)response{
    
}

-(void)getVehicleImage{
    [ProfileServiceManager getVehicleImage:[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"currentVehiclePhotoUrl"] :^(NSData *response){
        [self performSelectorOnMainThread:@selector(finishGetVehicleImage:) withObject:response waitUntilDone:NO];
    }];
}

-(void)finishGetVehicleImage:(NSDictionary *)response{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"splashGoOnRide"]) {
        // Destination VC
        OnRideViewController *onRideController = [segue destinationViewController];
        // Pass ride parameters to VC
        onRideController.rideDataDictionary = currentRideData;
    }else if([[segue identifier] isEqualToString:@"splashGoPayment"]){
        // Destination VC
        PaymentViewController *paymentController = [segue destinationViewController];
        // Pass ride parameters to VC
        paymentController.rideData = currentRideData;
    }else if([[segue identifier] isEqualToString:@"goHomeSegue"]){

        NSDictionary *PNrideRequestParameters = [[NSUserDefaults standardUserDefaults] objectForKey:@"PNRideParameters"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PNRideParameters"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if(PNrideRequestParameters){
            if([PNrideRequestParameters objectForKey:@"aps"]){
                if([[PNrideRequestParameters objectForKey:@"event"] isEqualToString:@"ride-initiated"]){
                    NSLog(@"splashScreen : %@", PNrideRequestParameters);
                    // Destination VC
                    UINavigationController *tabbar = (UINavigationController *)[segue destinationViewController];
                    // Pass ride parameters to VC
                    TabBarRootViewController *controller = (TabBarRootViewController *)[tabbar.viewControllers objectAtIndex:0];
                    controller.pnRideParams = PNrideRequestParameters;
                }
            }
        }
    }
}

@end
