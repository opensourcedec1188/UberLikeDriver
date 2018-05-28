//
//  EndRideViewController.m
//  ProcapDriver
//
//  Created by MacBookPro on 5/2/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "EndRideViewController.h"
#import "AppDelegate.h"

@interface EndRideViewController ()
@property (nonatomic, strong) AppDelegate *applicationDelegate;
@end

@implementation EndRideViewController

#pragma mark - Controller Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    _applicationDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    clientRating = 0;
    [self showLoadingView:YES];
    [self performSelectorInBackground:@selector(getRideInBG) withObject:nil];
    
    filledStarImage = @"FilledStar";
    emptyStarImage = @"EmptyStar";
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - Get Ride Data
-(void)getRideInBG{
    [RidesServiceManager getRide:[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"lastRideId"] :^(NSDictionary *response){
        [self performSelectorOnMainThread:@selector(finishGetRideInBG:) withObject:response waitUntilDone:NO];
    }];
}

-(void)finishGetRideInBG:(NSDictionary *)response{
    [self showLoadingView:NO];

    if([response objectForKey:@"data"]){
        _rideData = [response objectForKey:@"data"];
    }
}

#pragma mark - Driver Rating
- (IBAction)driverFirstBtnAction:(UIButton *)sender {
    clientRating = 1;
    [self setStars];
}

- (IBAction)driverSecondBtnAction:(UIButton *)sender {
    clientRating = 2;
    [self setStars];
}

- (IBAction)driverThirdBrnAction:(UIButton *)sender {
    clientRating = 3;
    [self setStars];
}

- (IBAction)driverForthBtnAction:(UIButton *)sender {
    clientRating = 4;
    [self setStars];
}

- (IBAction)driverFifthBtnAction:(UIButton *)sender {
    clientRating = 5;
    [self setStars];
}

-(void)setStars{
    if(clientRating > 0){
        [_operationsButton setTitle:@"Rate" forState:UIControlStateNormal];
    }
    switch (clientRating) {
        case 0:
            [_driverFirstBtn setBackgroundImage:[UIImage imageNamed:emptyStarImage] forState:UIControlStateNormal];
            [_driverSecondBtn setBackgroundImage:[UIImage imageNamed:emptyStarImage] forState:UIControlStateNormal];
            [_driverThirdBrn setBackgroundImage:[UIImage imageNamed:emptyStarImage] forState:UIControlStateNormal];
            [_driverForthBtn setBackgroundImage:[UIImage imageNamed:emptyStarImage] forState:UIControlStateNormal];
            [_driverFifthBtn setBackgroundImage:[UIImage imageNamed:emptyStarImage] forState:UIControlStateNormal];
            break;
        case 1:
            [_driverFirstBtn setBackgroundImage:[UIImage imageNamed:filledStarImage] forState:UIControlStateNormal];
            [_driverSecondBtn setBackgroundImage:[UIImage imageNamed:emptyStarImage] forState:UIControlStateNormal];
            [_driverThirdBrn setBackgroundImage:[UIImage imageNamed:emptyStarImage] forState:UIControlStateNormal];
            [_driverForthBtn setBackgroundImage:[UIImage imageNamed:emptyStarImage] forState:UIControlStateNormal];
            [_driverFifthBtn setBackgroundImage:[UIImage imageNamed:emptyStarImage] forState:UIControlStateNormal];
            break;
        case 2:
            [_driverFirstBtn setBackgroundImage:[UIImage imageNamed:filledStarImage] forState:UIControlStateNormal];
            [_driverSecondBtn setBackgroundImage:[UIImage imageNamed:filledStarImage] forState:UIControlStateNormal];
            [_driverThirdBrn setBackgroundImage:[UIImage imageNamed:emptyStarImage] forState:UIControlStateNormal];
            [_driverForthBtn setBackgroundImage:[UIImage imageNamed:emptyStarImage] forState:UIControlStateNormal];
            [_driverFifthBtn setBackgroundImage:[UIImage imageNamed:emptyStarImage] forState:UIControlStateNormal];
            break;
        case 3:
            [_driverFirstBtn setBackgroundImage:[UIImage imageNamed:filledStarImage] forState:UIControlStateNormal];
            [_driverSecondBtn setBackgroundImage:[UIImage imageNamed:filledStarImage] forState:UIControlStateNormal];
            [_driverThirdBrn setBackgroundImage:[UIImage imageNamed:filledStarImage] forState:UIControlStateNormal];
            [_driverForthBtn setBackgroundImage:[UIImage imageNamed:emptyStarImage] forState:UIControlStateNormal];
            [_driverFifthBtn setBackgroundImage:[UIImage imageNamed:emptyStarImage] forState:UIControlStateNormal];
            break;
        case 4:
            [_driverFirstBtn setBackgroundImage:[UIImage imageNamed:filledStarImage] forState:UIControlStateNormal];
            [_driverSecondBtn setBackgroundImage:[UIImage imageNamed:filledStarImage] forState:UIControlStateNormal];
            [_driverThirdBrn setBackgroundImage:[UIImage imageNamed:filledStarImage] forState:UIControlStateNormal];
            [_driverForthBtn setBackgroundImage:[UIImage imageNamed:filledStarImage] forState:UIControlStateNormal];
            [_driverFifthBtn setBackgroundImage:[UIImage imageNamed:emptyStarImage] forState:UIControlStateNormal];
            break;
        case 5:
            [_driverFirstBtn setBackgroundImage:[UIImage imageNamed:filledStarImage] forState:UIControlStateNormal];
            [_driverSecondBtn setBackgroundImage:[UIImage imageNamed:filledStarImage] forState:UIControlStateNormal];
            [_driverThirdBrn setBackgroundImage:[UIImage imageNamed:filledStarImage] forState:UIControlStateNormal];
            [_driverForthBtn setBackgroundImage:[UIImage imageNamed:filledStarImage] forState:UIControlStateNormal];
            [_driverFifthBtn setBackgroundImage:[UIImage imageNamed:filledStarImage] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}


- (IBAction)rateBtnAction:(UIButton *)sender {
    [self showLoadingView:YES];
    [self performSelectorInBackground:@selector(rateInBG) withObject:nil];
}

-(void)rateInBG{
    NSString *clientRatingString;
    if(clientRating == 0)
        clientRatingString = @"-1";
    else
        clientRatingString = [NSString stringWithFormat:@"%i", clientRating];
    
    @autoreleasepool {
        NSDictionary *ratingRequestParameters = @{
                                                  @"rating" : clientRatingString
                                                  };
        
        [RidesServiceManager rateClient:ratingRequestParameters AfterRide:[_rideData objectForKey:@"_id"] :^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishRateInBg:) withObject:response waitUntilDone:NO];
        }];
    }
}
-(void)finishRateInBg:(NSDictionary *)response{
    [self showLoadingView:NO];
    NSLog(@"rate response : %@", response);
    if(response && ([response objectForKey:@"data"])){
        if([response objectForKey:@"driver"])
            [ServiceManager saveLoggedInDriverData:[response objectForKey:@"driver"] andAccessToken:nil];
        [self showEarningSummary:YES];
    }else{
        UIAlertController * alert=[UIAlertController
                                   
                                   alertControllerWithTitle:NSLocalizedString(@"general_problem_title", @"") message:NSLocalizedString(@"general_problem_message", @"") preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *okBtn = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"general_ok", @"")
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self showEarningSummary:YES];
                                }];
        [alert addAction:okBtn];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)dismissToRootViewController
{
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)showEarningSummary:(BOOL)show{
    if(show){
        earningView = [[EarningSummaryView alloc] initWithFrame:self.view.bounds];
        earningView.delegate = self;
        earningView.alpha = 0.0f;
        [self.view addSubview:earningView];
        [UIView animateWithDuration:0.4 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             earningView.alpha = 1.0f;
                         } completion:^(BOOL finished){}];
    }else{
        [self dismissToRootViewController];
        [UIView animateWithDuration:0.4 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             earningView.alpha = 0.0f;
                         } completion:^(BOOL finished){
                             [earningView removeFromSuperview];
                         }];
    }
}

-(void)hideEarningSummary{
    [self showEarningSummary:NO];
}

@end
