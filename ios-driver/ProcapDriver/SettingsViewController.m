//
//  SettingsViewController.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/20/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_headerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _headerView.layer.shadowPath = shadowPath.CGPath;
    driverData = [ServiceManager getDriverDataFromUserDefaults];
    if([[driverData objectForKey:@"receiveAllTrips"] intValue] == 1)
        [_receiveAllTripsSwitch setOn:YES];
    else
        [_receiveAllTripsSwitch setOn:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Logout Work
- (IBAction)receiveAllTripsAction:(UISwitch *)sender {
    [self showLoadingView:YES];
    NSString *receive = @"";
    if(sender.isOn)
        receive = @"true";
    [self performSelectorInBackground:@selector(toggleReceiveAllTrips:) withObject:receive];
}

-(void)toggleReceiveAllTrips:(NSString *)receive{
    @autoreleasepool {
        NSDictionary *parameters = @{@"receiveAllTrips" : (receive.length > 0) ? receive : @""};
        [ProfileServiceManager toggleReceiveAllTrips:parameters :^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishToggleReceiveTrips:) withObject:response waitUntilDone:NO];
        }];
    }
}
-(void)finishToggleReceiveTrips:(NSDictionary *)response{
    [self showLoadingView:NO];
    if(response){
        if([[response objectForKey:@"code"] intValue] == 200){
            NSMutableDictionary *newDriver = [driverData mutableCopy];
            if(_receiveAllTripsSwitch.isOn)
                [newDriver setObject:[NSNumber numberWithInt:1] forKey:@"receiveAllTrips"];
            else
                [newDriver setObject:[NSNumber numberWithInt:0] forKey:@"receiveAllTrips"];
            NSLog(@"new driver data : %@", newDriver);
            driverData = [newDriver copy];
            [ServiceManager saveLoggedInDriverData:driverData andAccessToken:nil];
        }else
            [_receiveAllTripsSwitch setOn:!(_receiveAllTripsSwitch.isOn)];
    }else
        [_receiveAllTripsSwitch setOn:!(_receiveAllTripsSwitch.isOn)];
}

- (IBAction)logoutAction:(UIButton *)sender {
    [self showLoadingView:YES];
    [self performSelectorInBackground:@selector(SMLogout) withObject:nil];
}
#pragma mark - Logout
-(void)SMLogout
{
    @autoreleasepool {
        [ServiceManager driverLogout :^(NSDictionary *logoutData) {
            [self performSelectorOnMainThread:@selector(finishLogoutRequest:) withObject:logoutData waitUntilDone:NO];
        }];
    }
}

-(void)finishLogoutRequest:(NSDictionary *)response
{
    /* Hide loading view */
    [self showLoadingView:NO];
    
    if(([[response objectForKey:@"code"] intValue] == 200)){
        NSLog(@"logout successful with data %@", self.parentViewController.parentViewController);
        [[self delegate] dismissAfterLogout];
    }else{
        [[self delegate] dismissAfterLogout];
    }
}

#pragma mark - LoadingView
-(void)showLoadingView:(BOOL)show{
    if(show){
        loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        loadingView.backgroundColor = [UIColor whiteColor];
        loadingView.alpha = 0.2;
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

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
