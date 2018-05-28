//
//  ConfirmMobileViewController.m
//  ProcapDriver
//
//  Created by MacBookPro on 3/8/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "ConfirmMobileViewController.h"

@implementation ConfirmMobileViewController
@synthesize delegate, requestParameters;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"here with mobile: %@ ", self.requestParameters);
    if([[HelperClass getDeviceLanguage] isEqualToString:@"ar"]){
        self.rulesLabel.textAlignment = NSTextAlignmentRight;
    }
    
    _firstDigitTF.customTFDelegate = self;
    _firstDigitTF.layer.borderColor = [UIColor whiteColor].CGColor;
    _firstDigitTF.layer.borderWidth = 1.0;
    _firstDigitTF.layer.cornerRadius = 3.0f;
    _secondDigitTF.customTFDelegate = self;
    _secondDigitTF.layer.borderColor = [UIColor whiteColor].CGColor;
    _secondDigitTF.layer.borderWidth = 1.0;
    _secondDigitTF.layer.cornerRadius = 3.0f;
    _thirdDigitTF.customTFDelegate = self;
    _thirdDigitTF.layer.borderColor = [UIColor whiteColor].CGColor;
    _thirdDigitTF.layer.borderWidth = 1.0;
    _thirdDigitTF.layer.cornerRadius = 3.0f;
    _forthDigitTF.customTFDelegate = self;
    _forthDigitTF.layer.borderColor = [UIColor whiteColor].CGColor;
    _forthDigitTF.layer.borderWidth = 1.0;
    _forthDigitTF.layer.cornerRadius = 3.0f;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.phoneNumberLabel.text = [NSString stringWithFormat:@"%@", [self.requestParameters objectForKey:@"phone"]];
    [timer invalidate];
    [self startOTPTimer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /* empty textfields */
    self.firstDigitTF.text = self.secondDigitTF.text = self.thirdDigitTF.text = self.forthDigitTF.text = @"";
    /* Autofocus on First digit textfield */
//    [self.firstDigitTF performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
    userInsertedCode = @"";
    
}

-(void)startOTPTimer{
    _counter = 30;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(countdownTimer)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)countdownTimer
{
    
    if (_counter <= 0) {
        [timer invalidate];
        [self handleCountdownFinished];
    }else{
        _counter--;
        [_resendOTPButton setTitle:[NSString stringWithFormat:@"%@ %lu %@",NSLocalizedString(@"resend_first_part", @"") , (unsigned long)_counter, NSLocalizedString(@"resend_second_part", @"")] forState:UIControlStateNormal];
    }
}
-(void)handleCountdownFinished{
    [self.resendOTPButton setEnabled:YES];
    [_resendOTPButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"resend_btn_final", @"")] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Re-Send OTP Code Back-End


- (IBAction)resendOtpCpde:(UIButton *)sender {
    [self.resendOTPButton setEnabled:NO];
    [_resendOTPButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"resend_btn_initial", @"")] forState:UIControlStateNormal];
    [self startOTPTimer];
    self.resendOTPButton.enabled = NO;
    if([HelperClass checkNetworkReachability]){
        if([HelperClass validateMobileNumber:[self.requestParameters objectForKey:@"phone"]]){
            /* Show loading view */
            [self.delegate showRootLoadingView];
            /* Call background method that will call service manager */
            [self performSelectorInBackground:@selector(requestOTPInBackground:) withObject:self.requestParameters];
        }else{
            /* Invalid data alert */
            [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"enter_mobile_missing_title", @"") andMessage:NSLocalizedString(@"enter_mobile_missing_message", @"")] animated:YES completion:nil];
        }
    }else{
        /* No network connection */
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"network_problem_title", @"") andMessage:NSLocalizedString(@"network_problem_message", @"")] animated:YES completion:nil];
    }
}


-(void)requestOTPInBackground:(NSDictionary *)parameters
{
    @autoreleasepool {
        [ServiceManager requestOTPCode:parameters :^(NSDictionary *response) {
            [self performSelectorOnMainThread:@selector(finishRequestOTPInBackground:) withObject:response waitUntilDone:NO];
        }];
    }
}

-(void)finishRequestOTPInBackground:(NSDictionary *)response
{
    //Server side validation
    
    /* Hide loading view */
    [self.delegate hideRootLoadingView];
    NSLog(@"OTP SENT? %@", response);
    if([[response objectForKey:@"code"] intValue] == 200 )
        NSLog(@"sent again");
    else if([[response objectForKey:@"code"] intValue] == 409)
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"mobilr_exists_title", @"") andMessage:NSLocalizedString(@"mobilr_exists_message", @"")] animated:YES completion:nil];
    else
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_problem_title", @"") andMessage:NSLocalizedString(@"general_problem_message", @"")] animated:YES completion:nil];
}

-(void)verifyOTPCode:(NSDictionary *)parameters{
    @autoreleasepool {
        [ServiceManager confirmOTPCode:parameters :^(NSDictionary *response) {
            [self performSelectorOnMainThread:@selector(finishVerifyOTPCode:) withObject:response waitUntilDone:NO];
        }];
    }
}
-(void)finishVerifyOTPCode:(NSDictionary *)response
{
    
    [self.delegate hideRootLoadingView];
    NSLog(@"done confirming OTP code with response %@", response);
    if(([[response objectForKey:@"code"] intValue] == 200) && ([response objectForKey:@"phoneSession"])){
        [ServiceManager savePhoneSession:[[response objectForKey:@"phoneSession"] objectForKey:@"accessToken"]];
        [self goToRegister];
    }
    else
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"confirm_wrong_code_title", @"") andMessage:NSLocalizedString(@"confirm_wrong_code_message", @"")] animated:YES completion:nil];
    
    [self clearTextFields];
}

- (void)goToRegister {
    NSLog(@"will go %@ - %@", self.requestParameters, userInsertedCode);
    [self.delegate moveToRegisterController:[self.requestParameters objectForKey:@"phone"] andOTPCode:userInsertedCode];
}

-(void)clearTextFields{
    self.firstDigitTF.text = self.secondDigitTF.text = self.thirdDigitTF.text = self.forthDigitTF.text = @"";
}

#pragma mark - TextField Delegate methods
//Custom delete buttton
-(void)handleDelete:(UITextField *)textField{
    NSLog(@"deleeeeet");
    if (textField == self.forthDigitTF) {
        [self.thirdDigitTF becomeFirstResponder];
        self.thirdDigitTF.text = @"";
    }
    /* third digit TextField */
    if (textField == self.thirdDigitTF) {
        [self.secondDigitTF becomeFirstResponder];
        self.secondDigitTF.text = @"";
    }
    /* second digit TextField */
    if (textField == self.secondDigitTF) {
        [self.firstDigitTF becomeFirstResponder];
        self.firstDigitTF.text = @"";
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"new string : %@", string);
    /* If textfield has text */
    if(textField.text.length > 0){
        /* (user deleted existing textfield digit) -- If typed string == 0 */
        if(string.length == 0){
            /* Delete textfield text */
            [textField setText:string];
            
        }else{
            /*
             (User entered new digit -- Not allowed more that one digit)
             Don't update Textfield (length of textfield text will be more than 1)
             */
        }
        return NO; /* We already updated the text */
    }else{
        /* Text field has no text
         If typed text length > 0 */
        if(string.length == 1){
            /* Set new text */
            [textField setText:string];
            /* Check which textfield and set the next one to active
             First digit TextField */
            if (textField == self.firstDigitTF) {
                [self.secondDigitTF becomeFirstResponder];
            }
            /* Second digit TextField */
            if (textField == self.secondDigitTF) {
                [self.thirdDigitTF becomeFirstResponder];
            }
            /* third digit TextField */
            if (textField == self.thirdDigitTF) {
                [self.forthDigitTF becomeFirstResponder];
            }
            /* Forth digit TextField */
            if (textField == self.forthDigitTF) {
                /* concatenate 4 strings from 4 textfields */
                userInsertedCode = [NSString stringWithFormat:@"%@%@%@%@", self.firstDigitTF.text, self.secondDigitTF.text, self.thirdDigitTF.text, self.forthDigitTF.text];
                /* Check network connectevity */
                if([HelperClass checkNetworkReachability]){
                    /* Call the method that deal with back-end */
                    NSDictionary *parameters = @{@"phone" : [self.requestParameters objectForKey:@"phone"], @"dialCode" : [self.requestParameters objectForKey:@"dialCode"], @"otp" : userInsertedCode};
                    [self performSelectorInBackground:@selector(verifyOTPCode:) withObject:parameters];
                    /* Return to first textfield */
                    [self.firstDigitTF becomeFirstResponder];
                    /* Show loading View */
                    [self.delegate showRootLoadingView];
                }else{
                    /* No network connection */
                    [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"network_problem_title", @"") andMessage:NSLocalizedString(@"network_problem_message", @"")] animated:YES completion:nil];
                }
                
            }
        }
        
        return NO; // We already updated the text
    }
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
    return YES;
}

-(void)textDidChange:(id<UITextInput>)textInput{
    
}
-(void)selectionDidChange:(id<UITextInput>)textInput{
    
}
-(void)textWillChange:(id<UITextInput>)textInput{
    
}
-(void)selectionWillChange:(id<UITextInput>)textInput{
    
}

#pragma mark - Hide Keyboard when click anywhere
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
//    [[self view] endEditing:TRUE];
    
}



@end
