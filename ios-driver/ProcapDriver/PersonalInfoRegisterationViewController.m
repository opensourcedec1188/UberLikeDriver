//
//  PersonalInfoRegisterationViewController.m
//  ProcapDriver
//
//  Created by MacBookPro on 3/8/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "PersonalInfoRegisterationViewController.h"

@interface PersonalInfoRegisterationViewController ()

@end

@implementation PersonalInfoRegisterationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.applicationDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self drawSelectionsView];
    
    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.frame.size.width, 595);
    
    [_fNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_lNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_emailTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_idNumberTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_passTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_confirmPassTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    fnameConst = _fNameTop.constant;
    lnameConst = _lnameTop.constant;
    emailConst = _emailTop.constant;
    passConst = _passTop.constant;
    confirmPassConst = _confirmPassTop.constant;
    birthdateConst = _birthdateTop.constant;
    idNumConst = _idNumTop.constant;
    idExpiryConst = _idExpiryTop.constant;
    
    _idImageContainerView.layer.borderWidth = 1.0f;
    _idImageContainerView.layer.borderColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.25f].CGColor;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [_mainScrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_idImageContainerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _idImageContainerView.layer.shadowPath = shadowPath.CGPath;
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:_idNumberTF action:@selector(resignFirstResponder)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolbar.items = [NSArray arrayWithObject:barButton];
    _idNumberTF.inputAccessoryView = toolbar;
}

- (void)singleTap:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
}


-(void)drawSelectionsView{
    datePickerContainerView = [[UIView alloc] init];
    datePickerContainerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 260);
    datePickerContainerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:datePickerContainerView];
    
    pickersDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pickersDoneButton addTarget:self action:@selector(donePickerAction:) forControlEvents:UIControlEventTouchUpInside];
    [pickersDoneButton setTitle:@"Show View" forState:UIControlStateNormal];
    pickersDoneButton.frame = CGRectMake(0, 0, self.view.frame.size.width, 40.0);
    pickersDoneButton.backgroundColor = [UIColor colorWithRed:35.0/255.0f green:46.0/255.0f blue:66.0/255.0f alpha:0.5f];
    [pickersDoneButton setTitle:NSLocalizedString(@"any_done", @"") forState:UIControlStateNormal];
    [datePickerContainerView addSubview:pickersDoneButton];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, pickersDoneButton.frame.size.height, self.view.frame.size.width, 220)];
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePickerContainerView addSubview:datePicker];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    maxBirthdate = [HelperClass convertStringToDate:[self.applicationDelegate.appRules objectForKey:@"maxBirthdate"] fromFormat:@"YYYY/MM/dd"];
    minBirthdate = [HelperClass convertStringToDate:[self.applicationDelegate.appRules objectForKey:@"minBirthdate"] fromFormat:@"YYYY/MM/dd"];
    
    maxExpiry = [HelperClass convertStringToDate:[self.applicationDelegate.appRules objectForKey:@"maxExpiry"] fromFormat:@"YYYY/MM/dd"];
    minExpiry = [HelperClass convertStringToDate:[self.applicationDelegate.appRules objectForKey:@"minExpiry"] fromFormat:@"YYYY/MM/dd"];
    
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

/* Method that send first personal screen validation request */


-(void)processPersonalInfoValidationRequest{
    NSDictionary *parameters =
    @{
      @"driver": @{
              @"birthdate": [NSString stringWithFormat:@"%f", birthdateInMiliseconds],
              @"email": _emailTF.text,
              @"firstName": _fNameTF.text,
              @"lastName" : _lNameTF.text,
              @"password" : _passTF.text,
              @"passwordConfirmation" : self.confirmPassTF.text,
              @"ssn": self.idNumberTF.text,
              @"ssnExpiry": [NSString stringWithFormat:@"%f", ssnExpiryInMiliseconds]
        }
      
    };
    NSLog(@"will validate params : %@", parameters);
    NSDictionary *validation = [ClientSideValidation validateFirstPersonalInfoData:[parameters objectForKey:@"driver"]];
    
    if([[validation objectForKey:@"isAllValid"] isEqualToString:@"1"]){
        if(self.applicationDelegate.idImage){
            NSLog(@"client side validation passed with response : %@", validation);
            /* Passed Client-Side validations */
            /* Show loading View */
            [self.delegate showRootLoadingView];
            [self.view endEditing:YES];
            NSLog(@"will validate first personal data %@", parameters);
            [self performSelectorInBackground:@selector(validFirstPersonalDataData:) withObject:parameters];
        }else{
            [self.idImageLabel setTextColor:[UIColor colorWithRed:236.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:1.0]];
        }
        
    }else{
        NSLog(@"client side validation NOT passed with response : %@", validation);
        [self shakeMissingFields:validation];
    }
}

-(void)validFirstPersonalDataData:(NSDictionary *)fullData{
    @autoreleasepool {
        BOOL registered = [ServiceManager validateFirstPersonalInfoData:fullData :^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishDataValidation:) withObject:response waitUntilDone:NO];
        }];
        if(!registered)
            [self performSelectorOnMainThread:@selector(finishDataValidation:) withObject:nil waitUntilDone:NO];
    }
}
-(void)finishDataValidation:(NSDictionary *)driverData
{
    [self.delegate hideRootLoadingView];
    NSLog(@"done personal info validation %@", driverData);
    if(driverData && [driverData objectForKey:@"data"]){
        NSLog(@"personal info validation successful with data %@ and go to second screen", [driverData objectForKey:@"data"]);
        NSDictionary *requestParameters = [driverData objectForKey:@"data"];
        
        [ServiceManager saveTempPersonalInfo:requestParameters];
        [self.delegate goToGeneralInfoRegisteration:requestParameters andPhone:self.phoneNumber andOTP:self.otpCode];
    }else{
        /* Failed */
        NSLog(@"failed with data  :%@", [driverData objectForKey:@"code"]);
        [self serverSideValidation:driverData];
    }
}


- (IBAction)datePickerValueChanged:(UIDatePicker *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/YYYY"];
    
    switch (currentDatePicker) {
        case 1:
            birthdate = [NSString stringWithFormat:@"%@",[formatter stringFromDate:sender.date]];
            [_birthdateButton setTitle:birthdate forState:UIControlStateNormal];

            birthdateInMiliseconds = [sender.date timeIntervalSince1970]*1000;
            [self selectBD];
            //Remove Error
            [_birthdateSubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
            if(_birthdateButton == currentFieldPopup){
                if(popupViewTag && (popupViewTag > 0)){
                    UIView *tempView = [self.view viewWithTag:popupViewTag];
                    [tempView removeFromSuperview];
                    tempView = nil;
                }
            }
            break;
        case 2:
            ssnExpiry = [NSString stringWithFormat:@"%@",[formatter stringFromDate:sender.date]];
            [_idExpiryButton setTitle:ssnExpiry forState:UIControlStateNormal];
            
            ssnExpiryInMiliseconds = [sender.date timeIntervalSince1970]*1000;
            [self selectIDExpiry];
            //Remove Error
            [_idExpirySubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
            if(_idExpiryButton == currentFieldPopup){
                if(popupViewTag && (popupViewTag > 0)){
                    UIView *tempView = [self.view viewWithTag:popupViewTag];
                    [tempView removeFromSuperview];
                    tempView = nil;
                }
            }
            break;
            
        default:
            break;
    }
}

-(void)selectBD{
    _birthdateTop.constant = birthdateConst - 30;
    [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.view layoutIfNeeded];
                         _birthdateLabel.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:14];
                     }  completion:^(BOOL finished){}];
}

-(void)selectIDExpiry{
    _idExpiryTop.constant = idExpiryConst - 30;
    [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.view layoutIfNeeded];
                         _idExpiryLabel.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:14];
                     }  completion:^(BOOL finished){}];
}

- (IBAction)donePickerAction:(UIButton *)sender {
    [self showHidePickerViewShow:NO];
}

- (IBAction)showHideBirthdateAction:(UIButton *)sender {
    datePicker.date = [NSDate date];
    
    datePicker.maximumDate = maxBirthdate;
    datePicker.minimumDate = minBirthdate;
    
    currentDatePicker = 1;
    NSLog(@"should show picker Birthdate");
    [self showHidePickerViewShow:YES];
}

- (IBAction)idAddImageAction:(UIButton *)sender {
    UIAlertController * alert=[UIAlertController
                               
                               alertControllerWithTitle:NSLocalizedString(@"Chose_camera_source_title", @"") message:@""preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camBtn = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"Chose_camera_source_first_option", @"")
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self showImageController:0];
                             }];
    UIAlertAction *libraryBtn = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"Chose_camera_source_second_option", @"")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self showImageController:1];
                                     
                                 }];
    UIAlertAction *cancelBtn = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Chose_camera_source_cancel", @"")
                                style:UIAlertActionStyleDefault
                                handler:nil];
    
    [alert addAction:camBtn];
    [alert addAction:libraryBtn];
    [alert addAction:cancelBtn];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)showImageController:(int)sourceType{
    [self showHidePickerViewShow:NO];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    switch (sourceType) {
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            break;
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
            
        default:
            break;
    }
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)showHideIDExpiryDateAction:(UIButton *)sender {
    datePicker.date = [NSDate date];
    
    datePicker.maximumDate = maxExpiry;
    datePicker.minimumDate = minExpiry;
    
    currentDatePicker = 2;
    NSLog(@"should show picker ID Expiry");
    [self showHidePickerViewShow:YES];
}

-(void) showHidePickerViewShow:(BOOL)show{
    NSLog(@"current picker : %@", (currentDatePicker == 2) ? @"should move footer" : @"not move footer");
    [self.delegate addSubView:datePickerContainerView andShow:show andMoveFooter:(currentDatePicker == 2) ? YES : NO];
    [self.view endEditing:YES];
    datePicketViewShown = show;
}


#pragma mark - UITextFieldDelegate
-(void)textFieldDidChange :(UITextField *)textField{
    UILabel *currentLabel;
    NSLayoutConstraint *constraint;
    if(textField == _fNameTF){
        constraint = _fNameTop;
        constraint.constant = fnameConst - 30;
        currentLabel = _fNameLabel;
    }else if (textField == _lNameTF){
        constraint = _lnameTop;
        constraint.constant = lnameConst - 30;
        currentLabel = _lNameLabel;
    }else if (textField == _emailTF){
        constraint = _emailTop;
        constraint.constant = emailConst - 30;
        currentLabel = _emailLabel;
    }else if (textField == _passTF){
        constraint = _passTop;
        constraint.constant = passConst - 30;
        currentLabel = _passLabel;
    }else if (textField == _confirmPassTF){
        constraint = _confirmPassTop;
        constraint.constant = confirmPassConst - 30;
        currentLabel = _confirmPassLabel;
    }else if (textField == _idNumberTF){
        constraint = _idNumTop;
        constraint.constant = idNumConst - 30;
        currentLabel = _idNumLabel;
    }
    
    if(textField.text.length > 0){
        [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self.view layoutIfNeeded];
                             currentLabel.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:14];
                         }  completion:^(BOOL finished){}];
    }else{
        constraint.constant = constraint.constant + 30;
        [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self.view layoutIfNeeded];
                             currentLabel.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:16];
                         }  completion:^(BOOL finished){}];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.textColor = [UIColor whiteColor];
    if(textField == currentFieldPopup){
        if(popupViewTag && (popupViewTag > 0)){
            UIView *tempView = [self.view viewWithTag:popupViewTag];
            [tempView removeFromSuperview];
            tempView = nil;
        }
    }
    if(textField == _fNameTF)
        [_fNameSubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    
    if(textField == _lNameTF)
        [_lNameSubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    
    if(textField == _emailTF)
        [_emailSubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    
    if(textField == _passTF)
        [_passSubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    
    if(textField == self.confirmPassTF)
        [_confirmPassSubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    
    if(textField == self.idNumberTF)
        [_idNumSubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    
    if(datePicketViewShown)
        [self showHidePickerViewShow:NO];
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.idNumberTF){
        if (textField.text.length > 9 && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        else
        {return YES;}
    }

    if((textField == _fNameTF) || (textField == _lNameTF)){
        if(textField.text.length > 24 && range.length == 0){
            return NO;
        }else
            return YES;
    }
    if((textField == _passTF) || (textField == self.confirmPassTF)){
        if(textField.text.length > 19 && range.length == 0){
            return NO;
        }else
            return YES;
    }
    if(textField == _emailTF){
        if(textField.text.length > 254 && range.length == 0){
            return NO;
        }else
            return YES;
    }
    
    return YES;
    
}
#pragma mark - Keyboard
#pragma mark - Keyboard Show/Hide Methods
/* Keyboard will show (a textfield became active) */
- (void)keyboardWillShow:(NSNotification*)notification {
    if(self.idNumberTF.editing){
        NSLog(@"will show and id field is active");
       
        [self.delegate moveViewForTextFields:85 andShow:YES];
    }else{
        [self.delegate moveViewForTextFields:0 andShow:NO];
    }
}

/* Keyboard will hide (active textfield became inactive) */
- (void)keyboardWillHide:(NSNotification*)notification {
    
    if(self.idNumberTF.editing){
        NSLog(@"will hide and id field is active");
        [self.delegate moveViewForTextFields:0 andShow:NO];
    }
}

#pragma mark - Hide Keyboard when click anywhere
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:TRUE];
    if(datePicketViewShown)
        [self showHidePickerViewShow:NO];
}

#pragma mark - Camera Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSData * pngData = UIImagePNGRepresentation(info[UIImagePickerControllerEditedImage]);
    //Check image size limit (5MB)
    if(((float)[pngData length]/1048576) <= 5){
        // get selected image
        UIImage *imageCaptured = info[UIImagePickerControllerEditedImage];
        if(imageCaptured){
            self.applicationDelegate.idImage = info[UIImagePickerControllerEditedImage];
            NSLog(@"id imaged : %@", self.applicationDelegate.idImage);
        }
        //Dismiss camera picker controller
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
        // Update ID Image Textfield text
        [self.idImageCheckmark setImage:[UIImage imageNamed:@"RegWhiteCheckmark"]];
        self.idImageLabel.textColor = [UIColor whiteColor];
    }else{
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_image_size_title", @"") andMessage:NSLocalizedString(@"general_image_size_message", @"")] animated:YES completion:nil];
    }
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


-(void)shakeMissingFields:(NSDictionary *)fields{
    if([[fields objectForKey:@"ssnExpiry"] isEqualToString:@"1"]){
        [self addPopupToField:_idExpiryButton andMessage:NSLocalizedString(@"personal_id_error", @"") andSubview:_idExpirySubview];
    }
    if([[fields objectForKey:@"ssn"] isEqualToString:@"1"]){
        [self addPopupToField:self.idNumberTF andMessage:NSLocalizedString(@"personal_id_error", @"") andSubview:_idNumSubview];
    }
    if([[fields objectForKey:@"birthdate"] isEqualToString:@"1"]){
        [self addPopupToField:_birthdateButton andMessage:@"Invalid Birthdate" andSubview:_birthdateSubview];
    }
    if([[fields objectForKey:@"email"] isEqualToString:@"1"]){
        
        [self addPopupToField:_emailTF andMessage:NSLocalizedString(@"personal_invalid_email", @"") andSubview:_emailSubview];
    }
    if([[fields objectForKey:@"password"] isEqualToString:@"1"])
        [self addPopupToField:_passTF andMessage:NSLocalizedString(@"personal_passwords_minimum_error", @"") andSubview:_passSubview];
    else if([[fields objectForKey:@"passwordConfirmation"] isEqualToString:@"1"])
        [self addPopupToField:self.confirmPassTF andMessage:NSLocalizedString(@"personal_confirm_password", @"") andSubview:_confirmPassSubview];
    else{
        if([[fields objectForKey:@"passwordsEquality"] isEqualToString:@"1"])
            [self addPopupToField:self.confirmPassTF andMessage:NSLocalizedString(@"personal_passwords_not_equal", @"") andSubview:_confirmPassSubview];
        else{
            if([[fields objectForKey:@"passwordLength"] isEqualToString:@"1"])
                [self addPopupToField:_passTF andMessage:NSLocalizedString(@"personal_passwords_minimum_error", @"") andSubview:_passSubview];
        }
    }
    if([[fields objectForKey:@"lastName"] isEqualToString:@"1"]){
        [self addPopupToField:_lNameTF andMessage:NSLocalizedString(@"personal_flnames_chars_error", @"") andSubview:_lNameSubview];
    }else{
        if([[fields objectForKey:@"lastName_chars"] isEqualToString:@"1"])
            [self addPopupToField:_lNameTF andMessage:NSLocalizedString(@"personal_flnames_chars_error", @"") andSubview:_lNameSubview];
    }
    
    if([[fields objectForKey:@"firstName"] isEqualToString:@"1"]){
        [self addPopupToField:_fNameTF andMessage:NSLocalizedString(@"personal_flnames_chars_error", @"") andSubview:_fNameSubview];
    }else{
        if([[fields objectForKey:@"firstName_chars"] isEqualToString:@"1"])
            [self addPopupToField:_fNameTF andMessage:NSLocalizedString(@"personal_flnames_chars_error", @"") andSubview:_fNameSubview];
    }
    
}

-(void)serverSideValidation:(NSDictionary *)errorData{
    if([[errorData objectForKey:@"code"] intValue] == 400){
        NSString *errorField = [[errorData objectForKey:@"error"] objectForKey:@"field"];
        if([errorField isEqualToString:@"birthdate"]){
            
            //BD Error
            [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_problem_title", @"") andMessage:[[errorData objectForKey:@"error"] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"]] animated:YES completion:nil];
            
        }else if([errorField isEqualToString:@"email"]){
            
            
            [self addPopupToField:_emailTF andMessage:[[errorData objectForKey:@"error"] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"] andSubview:_emailSubview];
            
        }else if([errorField isEqualToString:@"firstName"]){
            
            
            [self addPopupToField:_fNameTF andMessage:[[errorData objectForKey:@"error"] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"] andSubview:_fNameSubview];
            
        }else if([errorField isEqualToString:@"lastName"]){
            
            
            [self addPopupToField:_lNameTF andMessage:[[errorData objectForKey:@"error"] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"] andSubview:_lNameSubview];
            
        }else if([errorField isEqualToString:@"password"]){
            
            
            [self addPopupToField:_passTF andMessage:[[errorData objectForKey:@"error"] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"]  andSubview:_passSubview];
            
        }else if([errorField isEqualToString:@"passwordConfirmation"]){
            
            
            [self addPopupToField:_confirmPassTF andMessage:[[errorData objectForKey:@"error"] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"] andSubview:_confirmPassSubview];
            
        }else if([errorField isEqualToString:@"ssn"]){
            
            [self addPopupToField:_idNumberTF andMessage:[[errorData objectForKey:@"error"] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"] andSubview:_idNumSubview];
        
        }else if([errorField isEqualToString:@"ssnExpiry"]){
            
            [self addPopupToField:_idExpiryButton andMessage:NSLocalizedString(@"personal_id_error", @"") andSubview:_idExpirySubview];
        
        }else if([errorField isEqualToString:@"otp"]){
            
            [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_problem_title", @"") andMessage:[[errorData objectForKey:@"error"] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"]] animated:YES completion:nil];
        
        }else{
            
            [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_problem_title", @"") andMessage:[[errorData objectForKey:@"error"] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"]] animated:YES completion:nil];
       
        }
    }else if([[errorData objectForKey:@"code"] intValue] == 409){
        
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"driver_already_exists_title", @"") andMessage:NSLocalizedString(@"driver_already_exists_message", @"")] animated:YES completion:nil];
    
    }else{
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_problem_title", @"") andMessage:NSLocalizedString(@"general_problem_message", @"")] animated:YES completion:nil];
    }
}


-(void)addPopupToField:(UIView *)field andMessage:(NSString *)message andSubview:(UIView *)subview{
    if(popupViewTag && (popupViewTag > 0)){
        UIView *tempView = [self.view viewWithTag:popupViewTag];
        [tempView removeFromSuperview];
        tempView = nil;
    }
    
    subview.backgroundColor = [UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f];
    
    UIView *popupView = [[UIView alloc] initWithFrame:CGRectMake(field.frame.origin.x, field.frame.origin.y + 22, field.frame.size.width, field.frame.size.height)];
    popupView.tag = 131;
    popupView.backgroundColor = [UIColor clearColor];
    popupViewTag = (int)popupView.tag;
    
    UILabel *popupLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, popupView.frame.size.width, popupView.frame.size.height-7)];
    popupLbl.numberOfLines = 2;
    popupLbl.text = message;
    popupLbl.backgroundColor = [UIColor clearColor];
    popupLbl.textAlignment = NSTextAlignmentJustified;
    popupLbl.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:12];
    popupLbl.textColor = [UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f];
    [popupView addSubview:popupLbl];
    
    [[field superview] addSubview:popupView];
    [self.view bringSubviewToFront:popupView];
    currentFieldPopup = field;
}


@end
