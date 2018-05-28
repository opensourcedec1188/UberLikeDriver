//
//  PaymentViewController.m
//  ProcapDriver
//
//  Created by MacBookPro on 5/2/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "PaymentViewController.h"
#import "AppDelegate.h"

@interface PaymentViewController ()
@property (nonatomic, strong) AppDelegate *applicationDelegate;
@end

@implementation PaymentViewController

#pragma mark - Controller Methods
- (void)viewDidLoad {
    [super viewDidLoad];

    _applicationDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self showLoadingView:YES];
    [self performSelectorInBackground:@selector(getCurrentRideInBG) withObject:nil];
    
    _priceTestField.layer.borderWidth = 2;
    _priceTestField.layer.borderColor = [UIColor whiteColor].CGColor;
    _priceTestField.layer.cornerRadius = 3;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_rideTrackingTimer invalidate];
    _rideTrackingTimer = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_rideTrackingTimer invalidate];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_priceTestField becomeFirstResponder];
}

#pragma mark - Get Ride Data
-(void)getCurrentRideInBG{
    @autoreleasepool {
        [RidesServiceManager getRide:[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"lastRideId"] :^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishGetCurrentRide:) withObject:response waitUntilDone:NO];
        }];
    }
}
-(void)finishGetCurrentRide:(NSDictionary *)response{
    NSLog(@"response : %@", response);
    [self showLoadingView:NO];
    if(response && ([response objectForKey:@"data"])){
        _rideData = [response objectForKey:@"data"];
        _priceLabel.text = [NSString stringWithFormat:@"%@", [[_rideData objectForKey:@"totalFare"] stringValue]];
        _fareLabel.text = [NSString stringWithFormat:@"%@", [[_rideData objectForKey:@"fare"] stringValue]];
        _discountLabel.text = [NSString stringWithFormat:@"%@", [[_rideData objectForKey:@"discount"] stringValue]];
        _outstandingBalanceLabel.text = [NSString stringWithFormat:@"%@", [[_rideData objectForKey:@"outstandingFees"] stringValue]];
    }else{
        //Couldn't get ride, Dismiss controller
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Hide Keyboard when click anywhere
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (IBAction)collectCashAction:(UIButton *)sender {
    if(_priceTestField.text.length > 0){
        [self showLoadingView:YES];
        [self performSelectorInBackground:@selector(finishRideInBackground:) withObject:[_rideData objectForKey:@"_id"]];
    }else
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"PC_missing_payment_title", @"") andMessage:NSLocalizedString(@"PC_missing_payment_message", @"")] animated:YES completion:nil];
}

#pragma mark - Finish All Ride Request
-(void)finishRideInBackground:(NSString *)rideID{
    @autoreleasepool {
        NSArray *coordinatesArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", _applicationDelegate.currentLocation.coordinate.latitude], [NSString stringWithFormat:@"%f", _applicationDelegate.currentLocation.coordinate.longitude], nil];

        [RidesServiceManager finishRide:@{@"currentLocation" : coordinatesArray, @"cash" : _priceTestField.text} andRideID:rideID :^(NSDictionary * response){

            [self performSelectorOnMainThread:@selector(finishFinishRideInBackground:) withObject:response waitUntilDone:NO];
        }];
    }
}

-(void)finishFinishRideInBackground:(NSDictionary *)response{
    [self showLoadingView:NO];

    if([[response objectForKey:@"code"] intValue] == 200){
        _rideData = [response objectForKey:@"data"];
        [ServiceManager saveLoggedInDriverData:[response objectForKey:@"driver"] andAccessToken:nil];
        [self performSegueWithIdentifier:@"EndRideAfterPayment" sender:self];
    }else if([[response objectForKey:@"code"] intValue] == 402){
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"PC_less_cash_title", @"") andMessage:NSLocalizedString(@"PC_less_cash_message", @"")] animated:YES completion:nil];
    }else{

        [self createRideServerValidation:response];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"EndRideAfterPayment"]) {
        // Destination VC
        EndRideViewController *endRideController = [segue destinationViewController];
        // Pass ride parameters to VC
        endRideController.rideData = _rideData;
    }
}

#pragma mark - Server Side Validation
-(void)createRideServerValidation:(NSDictionary *)response{
    if([[response objectForKey:@"code"] intValue] == 400){
        NSDictionary *errors = [response objectForKey:@"errors"];
        if(errors){
            if([[errors objectForKey:@"cash"] intValue] == 1){
                [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"PC_wrongCashTitle", @"") andMessage:NSLocalizedString(@"PC_wrongCashMessage", @"")] animated:YES completion:nil];
            }
        }else
            [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_problem_title", @"") andMessage:NSLocalizedString(@"general_problem_message", @"")] animated:YES completion:nil];
        
    }else{
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_problem_title", @"") andMessage:NSLocalizedString(@"general_problem_message", @"")] animated:YES completion:nil];
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
@end
