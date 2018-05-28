//
//  LoginPasswordViewController.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/21/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "LoginPasswordViewController.h"

@interface LoginPasswordViewController ()

@end

@implementation LoginPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)goBtnAction:(UIButton *)sender {
    if([HelperClass validateText:_passwordTextField.text]){
        [self showLoadingView:YES];
        
        /* Prepare request parameters */
        NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceTokenString"];
        NSLog(@"device token : %@", deviceToken);
        NSDictionary *loginParams = @{@"deviceId" : (deviceToken && !([deviceToken isKindOfClass:[NSNull class]])) ? deviceToken : @"", @"role": @"driver", @"device" : @"ios", @"email" : _mobileNumber, @"password" : _passwordTextField.text};
        
        [self performSelectorInBackground:@selector(SMLoginInBackground:) withObject:loginParams];
    }else
        [self showError:_passwordSubView andMessage:@"Missing Password"];
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Request Login Back-End

-(void)SMLoginInBackground:(NSDictionary *)driverLoginData
{
    @autoreleasepool {
        [ServiceManager driverLogin:driverLoginData :^(NSDictionary *loginData) {
            [self performSelectorOnMainThread:@selector(finishLoginRequest:) withObject:loginData waitUntilDone:NO];
        }];
    }
}

-(void)finishLoginRequest:(NSDictionary *)driverData
{
    /* Hide loading view */
    [self showLoadingView:NO];
    
    /* If login response data is valid, Call the method that save driver data and access token */
    if(driverData && [driverData objectForKey:@"data"] && [driverData objectForKey:@"user"]){
        NSLog(@"login successful with data %@", [driverData objectForKey:@"user"]);
//        [self performSegueWithIdentifier:@"homeAfterLogin" sender:self];
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *theInitialViewController = [secondStoryBoard instantiateViewControllerWithIdentifier:@"HomeNavController"];
        [self presentViewController:theInitialViewController animated:YES completion:nil];
    }else{
        /* Login failed */
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"login_failed_title", @"") andMessage:NSLocalizedString(@"login_failed_message", @"")] animated:YES completion:nil];
    }
}

#pragma mark - Textfield Delegate
-(void)textFieldDidChange :(UITextField *)textField{
    
    if(textField.text.length > 0){
        _passwordTop.constant = 72;
        [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self.view layoutIfNeeded];
                             _passwordLabel.font = [UIFont fontWithName:FONT_ROBOTO_LIGHT size:12];
                             _passwordLabel.textColor = [UIColor colorWithRed:155.0/255.0f green:155.0/255.0f blue:155.0/255.0f alpha:1.0f];
                         }  completion:^(BOOL finished){}];
    }else{
        _passwordTop.constant = 102;
        [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self.view layoutIfNeeded];
                             _passwordLabel.font = [UIFont fontWithName:FONT_ROBOTO_LIGHT size:16];
                             _passwordLabel.textColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:1.0f];
                         }  completion:^(BOOL finished){}];
    }
    
    [_passwordSubView setBackgroundColor:[UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:0.75f]];
    [_errorLabel setHidden:YES];
}

#pragma mark - Error Validation
-(void)showError:(UIView *)view andMessage:(NSString *)errorMsg{
    [_errorLabel setHidden:NO];
    _errorLabel.text = errorMsg;
    
    [view setBackgroundColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0]];
}

#pragma mark - Draw shadow
-(void)setViewShadow:(UIView *)viewToDraw andSet:(BOOL)show edgeInset:(UIEdgeInsets)insets{
    if(show){
        viewToDraw.layer.masksToBounds = NO;
        viewToDraw.layer.shadowRadius  = 10.0f;
        viewToDraw.layer.shadowColor = [[UIColor colorWithRed:0.0/255.0f green:172.0/255.0f blue:250/255.0f alpha:0.5f] CGColor];
        viewToDraw.layer.shadowOffset  = CGSizeMake(-3, 3);
        viewToDraw.layer.shadowOpacity = 0.5f;
        UIEdgeInsets shadowInsets = insets;
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(viewToDraw.bounds, shadowInsets)];
        viewToDraw.layer.shadowPath    = shadowPath.CGPath;
    }else{
        viewToDraw.layer.masksToBounds = YES;
        viewToDraw.layer.shadowPath = nil;
    }
}

#pragma mark - Loading View
-(void)showLoadingView:(BOOL)show{
    if(show) {
        loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.alpha = 0.7;
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
        indicator.center = loadingView.center;
        indicator.color = [UIColor whiteColor];
        [indicator startAnimating];
        [loadingView addSubview:indicator];
        
        [self.view addSubview:loadingView];
        [self.view bringSubviewToFront:loadingView];
    }else{
        [loadingView removeFromSuperview];
    }
}
@end
