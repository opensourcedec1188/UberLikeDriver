//
//  LoginMobileViewController.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/21/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "LoginMobileViewController.h"

@interface LoginMobileViewController ()

@end

@implementation LoginMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.applicationDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [_mobileTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)GoBtnAction:(UIButton *)sender {
    if([HelperClass checkNetworkReachability]){
        if(_mobileTextField.text.length > 0){
            //Detect language
            NSArray *tagschemes = [NSArray arrayWithObjects:NSLinguisticTagSchemeLanguage, nil];
            NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:tagschemes options:0];
            [tagger setString:_mobileTextField.text];
            NSString *language = [tagger tagAtIndex:0 scheme:NSLinguisticTagSchemeLanguage tokenRange:NULL sentenceRange:NULL];
            
            int phoneNumb = 0;
            
            mobileNumberEnglish = [NSString stringWithFormat:@"%@", _mobileTextField.text];
            if([language isEqualToString:@"ar"]){
                phoneNumb = [HelperClass convertArabicNumber:_mobileTextField.text];
                mobileNumberEnglish = [NSString stringWithFormat:@"%d", phoneNumb];
            }
            
            if([HelperClass validateMobileNumber:mobileNumberEnglish]){
                /* Show loading view */
                [self showLoadingView:YES];
                /* Call background method that will call service manager */
                NSDictionary *params = @{@"dialCode": @"966", @"phone": mobileNumberEnglish, @"language" : [HelperClass getDeviceLanguage]};
                [self performSelectorInBackground:@selector(checkNumberInBackGround:) withObject:params];
            }else{
                //Invalid data alert
                [self showError:_mobileSubview andMessage:@"Invalid Mobile Number"];
            }
        }else{
            [self showError:_mobileSubview andMessage:@"Missing Mobile Number"];
        }
    }else{
        [self showError:_mobileSubview andMessage:@"No Network Connection"];
    }
}

-(void)checkNumberInBackGround:(NSDictionary *)parameters{
    @autoreleasepool {
        [ServiceManager requestOTPCode:parameters :^(NSDictionary *response) {
            [self performSelectorOnMainThread:@selector(finishCheckNumberInBackGround:) withObject:response waitUntilDone:NO];
        }];
    }
}

-(void)finishCheckNumberInBackGround:(NSDictionary *)response{
    [self showLoadingView:NO];
    if(response){
        if([[response objectForKey:@"code"] intValue] == 409){
            //User Registered, Go to password
            [self performSegueWithIdentifier:@"MobileGoPassword" sender:self];
        }else if ([[response objectForKey:@"code"] intValue] == 200){
            //Not Registered, Go Registration
            [self performSegueWithIdentifier:@"MobileGoRegister" sender:self];
        }else{
            [self showError:_mobileSubview andMessage:@"Wrong Mobile Number"];
        }
    }else
        [self showError:_mobileSubview andMessage:@"Wrong Mobile Number"];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"MobileGoPassword"]){
        LoginPasswordViewController *passwordController = [segue destinationViewController];
        passwordController.mobileNumber = mobileNumberEnglish;
    }else if([segue.identifier isEqualToString:@"MobileGoRegister"]){
        RegisterationRootViewController *regRoot = [segue destinationViewController];
        regRoot.requestParameters = @{@"dialCode": @"966", @"phone": mobileNumberEnglish, @"language" : [HelperClass getDeviceLanguage]};
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



#pragma mark - Hide Keyboard when click anywhere
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:TRUE];
}

#pragma mark - Textfield Delegate
-(void)textFieldDidChange :(UITextField *)textField{
    
    if(textField.text.length > 0){
        [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             _mobileLabel.frame = CGRectMake(_mobileLabel.frame.origin.x, textField.frame.origin.y - (_mobileLabel.frame.size.height), _mobileLabel.frame.size.width, _mobileLabel.frame.size.height);
                             _mobileLabel.font = [UIFont fontWithName:FONT_ROBOTO_LIGHT size:12];
                             _mobileLabel.textColor = [UIColor colorWithRed:155.0/255.0f green:155.0/255.0f blue:155.0/255.0f alpha:1.0f];
                         }  completion:^(BOOL finished){}];
    }else{
        [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             _mobileLabel.frame = textField.frame;
                             _mobileLabel.font = [UIFont fontWithName:FONT_ROBOTO_LIGHT size:16];
                             _mobileLabel.textColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:0.75f];
                         }  completion:^(BOOL finished){}];
    }
    
    [_mobileSubview setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
    [_errorLabel setHidden:YES];
}

#pragma mark - Error Validation
-(void)showError:(UIView *)view andMessage:(NSString *)errorMsg{
    [_errorLabel setHidden:NO];
    _errorLabel.text = errorMsg;
    
    [view setBackgroundColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0]];
}
@end
