//
//  EditPasswordView.m
//  Procap
//
//  Created by Mahmoud Amer on 7/31/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "EditPasswordView.h"

@implementation EditPasswordView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self customInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        [self customInit];
    }
    
    return self;
}

-(void)customInit{
    [[NSBundle mainBundle] loadNibNamed:@"EditPasswordView" owner:self options:nil];
    [self addSubview:self.CONTENTVIEW];
    self.CONTENTVIEW.frame = self.bounds;
    [_oldPasswordTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_confirmNewPasswordTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_updatedPassTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Loading View
-(void)showLoadingView:(BOOL)show{
    if(show) {
        loadingView = [[UIView alloc] initWithFrame:self.bounds];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.alpha = 0.7;
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
        indicator.center = loadingView.center;
        indicator.color = [UIColor whiteColor];
        [indicator startAnimating];
        [loadingView addSubview:indicator];
        
        [self addSubview:loadingView];
        [self bringSubviewToFront:loadingView];
    }else{
        [loadingView removeFromSuperview];
    }
}

- (IBAction)dismissAction:(UIButton *)sender {
    [self.delegate closePasswordView];
    [self.superview endEditing:TRUE];
}

#pragma mark - TextField Delegate
-(void)textFieldDidChange :(UITextField *)textField{
    NSLog( @"text changed: %@", textField.text);
    UILabel *currentLabel;
    if(textField == _oldPasswordTF)
        currentLabel = _oldPasswordLabel;
    else if (textField == _updatedPassTF)
        currentLabel = _updatedPassLabel;
    else if (textField == _confirmNewPasswordTF)
        currentLabel = _confirmNewPassLabel;
    
    if(textField.text.length > 0){
        [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             currentLabel.frame = CGRectMake(currentLabel.frame.origin.x, textField.frame.origin.y - (currentLabel.frame.size.height), currentLabel.frame.size.width, currentLabel.frame.size.height);
                             currentLabel.font = [UIFont fontWithName:FONT_ROBOTO_LIGHT size:12];
                             currentLabel.textColor = [UIColor colorWithRed:155.0/255.0f green:155.0/255.0f blue:155.0/255.0f alpha:1.0f];
                         }  completion:^(BOOL finished){}];
    }else{
        [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             currentLabel.frame = textField.frame;
                             currentLabel.font = [UIFont fontWithName:FONT_ROBOTO_LIGHT size:16];
                             currentLabel.textColor = [UIColor colorWithRed:34.0/255.0f green:50.0/255.0f blue:73.0/255.0f alpha:1.0f];
                         }  completion:^(BOOL finished){}];
    }
    
    //Validation
    [_oldPasswordSubView setBackgroundColor:[UIColor colorWithRed:34.0/255.0f green:50.0/255.0f blue:73.0/255.0f alpha:1.0]];
    [_updatePassSubview setBackgroundColor:[UIColor colorWithRed:34.0/255.0f green:50.0/255.0f blue:73.0/255.0f alpha:1.0]];
    [_ConfirmSubview setBackgroundColor:[UIColor colorWithRed:34.0/255.0f green:50.0/255.0f blue:73.0/255.0f alpha:1.0]];
    
    [_errorLabel setHidden:YES];
}

- (IBAction)showOldPassBtnAction:(UIButton *)sender {
    _oldPasswordTF.secureTextEntry = !_oldPasswordTF.secureTextEntry;
    if(!_oldPasswordTF.secureTextEntry)
        [sender setImage:[UIImage imageNamed:@"eyeHidePassword"] forState:UIControlStateNormal];
    else
        [sender setImage:[UIImage imageNamed:@"eyeShowPassword"] forState:UIControlStateNormal];
}

- (IBAction)showUpdatedPassBtnAction:(UIButton *)sender {
    _updatedPassTF.secureTextEntry = !_updatedPassTF.secureTextEntry;
    if(!_updatedPassTF.secureTextEntry)
        [sender setImage:[UIImage imageNamed:@"eyeHidePassword"] forState:UIControlStateNormal];
    else
        [sender setImage:[UIImage imageNamed:@"eyeShowPassword"] forState:UIControlStateNormal];
}

- (IBAction)showConfirmPassBtnAction:(UIButton *)sender {
    _confirmNewPasswordTF.secureTextEntry = !_confirmNewPasswordTF.secureTextEntry;
    if(!_confirmNewPasswordTF.secureTextEntry)
        [sender setImage:[UIImage imageNamed:@"eyeHidePassword"] forState:UIControlStateNormal];
    else
        [sender setImage:[UIImage imageNamed:@"eyeShowPassword"] forState:UIControlStateNormal];
}

- (IBAction)updateAction:(UIButton *)sender {
    if([HelperClass checkNetworkReachability]){
        NSString *oldPass = _oldPasswordTF.text;
        NSString *newPass = _updatedPassTF.text;
        NSString *confirmPass = _confirmNewPasswordTF.text;
        
        if(([HelperClass validateText:oldPass]) && ([HelperClass validateText:newPass]) && ([HelperClass validateText:confirmPass])){
            if((newPass.length > 5) && confirmPass.length > 5){
                if([newPass isEqualToString:confirmPass]){
                    [self showLoadingView:YES];
                    NSDictionary *params = @{
                                             @"oldPassword" : oldPass,
                                             @"newPassword" : newPass,
                                             @"newPasswordConfirmation" : confirmPass
                                             };
                    [self performSelectorInBackground:@selector(changePasswordInBackground:) withObject:params];
                }else{
                    [self showError:_ConfirmSubview andMessage:@"Passwords Not Equal"];
                    [self showError:_updatePassSubview andMessage:@"Passwords Not Equal"];
                }
            }else{
                [self showError:_updatePassSubview andMessage:@"Minimum 6 charecters"];
                [self showError:_ConfirmSubview andMessage:@"Minimum 6 charecters"];
            }
            
        }else{
            if(![HelperClass validateText:oldPass])
                [self showError:_oldPasswordSubView andMessage:@"Missing Old Password"];
            if(![HelperClass validateText:newPass])
                [self showError:_updatePassSubview andMessage:@"Missing New Password"];
            if(![HelperClass validateText:confirmPass])
                [self showError:_ConfirmSubview andMessage:@"Missing Password Confirmation"];
        }
    }else{
        [self showError:nil andMessage:@"No Network Connection"];
    }
}

#pragma mark - Change Password Request
-(void)changePasswordInBackground:(NSDictionary *)parameters{
    @autoreleasepool {
        [ProfileServiceManager updatePasswordData:parameters :^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishChangePasswordInBackground:) withObject:response waitUntilDone:NO];
        }];
    }
}

-(void)finishChangePasswordInBackground:(NSDictionary *)response{
    [self showLoadingView:NO];
    NSLog(@"finish Update password response %@", response);
    if(response){
        if([[response objectForKey:@"code"] intValue] == 200){
            [self.delegate closePasswordView];
        }else if([[response objectForKey:@"code"] intValue] == 401){
            [self showError:_ConfirmSubview andMessage:@"Wrong Old Password Provided"];
        }else{
            [self showError:_ConfirmSubview andMessage:@"An Error Occurred, Please try again"];
        }
    }
}

-(void)showError:(UIView *)view andMessage:(NSString *)errorMsg{
    [_errorLabel setHidden:NO];
    _errorLabel.text = errorMsg;
    
    [view setBackgroundColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0]];
}

@end
