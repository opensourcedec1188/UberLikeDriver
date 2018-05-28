//
//  EnterMobileViewController.m
//  ProcapDriver
//
//  Created by MacBookPro on 3/8/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "EnterMobileViewController.h"


@implementation EnterMobileViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentKeyboardHeight = 0.0f;
    
    self.termsButton.layer.cornerRadius = 7.0f;
    
    if([[HelperClass getDeviceLanguage] isEqualToString:@"ar"]){
        self.rulesTitleLabel.textAlignment = NSTextAlignmentRight;
        self.rulesLabel.textAlignment = NSTextAlignmentRight;
        
        self.dialCodeLabel.text = @"+٩٦٦";
        self.dialCodeLabel.textAlignment = NSTextAlignmentRight;
        self.phoneTextField.textAlignment = NSTextAlignmentLeft;
        self.byContinueLabel.textAlignment = NSTextAlignmentRight;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [self deregisterForKeyboardNotifications];
}
- (void)deregisterForKeyboardNotifications {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [center removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)processPhoneRequest
{
    /* Hide keyboard */
    [self.phoneTextField resignFirstResponder];
    /* request SMS message code (ServiceManager) */
    if([HelperClass checkNetworkReachability]){
        
        if(self.phoneTextField.text.length > 0){
            //Detect language
            NSArray *tagschemes = [NSArray arrayWithObjects:NSLinguisticTagSchemeLanguage, nil];
            NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:tagschemes options:0];
            [tagger setString:self.phoneTextField.text];
            NSString *language = [tagger tagAtIndex:0 scheme:NSLinguisticTagSchemeLanguage tokenRange:NULL sentenceRange:NULL];
            
            int phoneNumb = 0;
            
            mobileNumberEnglish = [NSString stringWithFormat:@"%@", self.phoneTextField.text];
            if([language isEqualToString:@"ar"]){
                phoneNumb = [HelperClass convertArabicNumber:self.phoneTextField.text];
                mobileNumberEnglish = [NSString stringWithFormat:@"%d", phoneNumb];
            }
            
            
            NSLog(@"new phone : %@", mobileNumberEnglish);
            if([HelperClass validateMobileNumber:mobileNumberEnglish]){
                if(termsConfirmed){
                    /* Show loading view */
                    [self.delegate showRootLoadingView];
                    /* Call background method that will call service manager */
                    requestParameters = @{@"dialCode": @"966", @"phone": mobileNumberEnglish, @"language" : [HelperClass getDeviceLanguage]};
                    [self performSelectorInBackground:@selector(requestOTPInBackground:) withObject:requestParameters];
                }else{
                    [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"enter_mobile_terms_not_approved_error_title", @"") andMessage:NSLocalizedString(@"enter_mobile_terms_not_approved_error_title", @"")] animated:YES completion:nil];
                    [[self.termsButton layer] setBorderWidth:0.5f];
                    [[self.termsButton layer] setBorderColor:[UIColor redColor].CGColor];
                }
                
            }else{
                /* Invalid data alert */
                [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"enter_mobile_missing_title", @"") andMessage:NSLocalizedString(@"enter_mobile_missing_message", @"")] animated:YES completion:nil];
            }
        }else{
            /* No Mobile Entered */
            [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"enter_mobile_missing_title", @"") andMessage:NSLocalizedString(@"enter_mobile_missing_message", @"")] animated:YES completion:nil];
        }
    }else{
        /* No Internet Connection */
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"network_problem_title", @"") andMessage:NSLocalizedString(@"network_problem_message", @"")] animated:YES completion:nil];
    }
}


#pragma mark - Request OTP Code Back-End
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
    if(([[response objectForKey:@"code"] intValue] == 200) && ([response objectForKey:@"data"]))
        [self goToConfirm];
    else if([[response objectForKey:@"code"] intValue] == 409)
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"mobilr_exists_title", @"") andMessage:NSLocalizedString(@"mobilr_exists_message", @"")] animated:YES completion:nil];
    else
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_problem_title", @"") andMessage:NSLocalizedString(@"general_problem_message", @"")] animated:YES completion:nil];
}

/* Calling delegate method that would navigate to the next screen */
- (IBAction)termsButtonAction:(UIButton *)sender {
    termsConfirmed = !termsConfirmed;
    if(termsConfirmed)
        [self.termsButton setBackgroundImage:[UIImage imageNamed:@"terms_Correct_Icon-01.png"] forState:UIControlStateNormal];
    else
        [self.termsButton setBackgroundImage:[UIImage imageNamed:@"Term_of_use_box-01.png"] forState:UIControlStateNormal];
    
//    [[self.termsButton layer] setBorderWidth:0.0f];
    [[self.termsButton layer] setBorderColor:[UIColor clearColor].CGColor];
}

- (void)goToConfirm {
    [self.delegate moveToConfirmController:requestParameters];
}


#pragma mark - Textfields delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Keyboard
#pragma mark - Keyboard Show/Hide Methods
/* Keyboard will show (a textfield became active) */
- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    
    /* Get keyboard size */
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    /* Get keyboard height */
    currentKeyboardHeight = - kbSize.height;
    
    [self.delegate moveFooterView:currentKeyboardHeight];
    
}

/* Keyboard will hide (active textfield became inactive) */
- (void)keyboardWillHide:(NSNotification*)notification {
    
    NSLog(@"will hide");
    NSDictionary *info = [notification userInfo];
    
    /* Get keyboard size */
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    /* Get keyboard height */
    currentKeyboardHeight = kbSize.height;
    /* Change parent frame of ViewController's view (RegisterRootViewController) */
    [self.delegate moveFooterView:0];
}

#pragma mark - Hide Keyboard when click anywhere
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:TRUE];
    
}

@end
