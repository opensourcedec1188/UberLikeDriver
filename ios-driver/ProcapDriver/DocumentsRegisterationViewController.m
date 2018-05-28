//
//  DocumentsRegisterationViewController.m
//  ProcapDriver
//
//  Created by MacBookPro on 3/8/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "DocumentsRegisterationViewController.h"

@interface DocumentsRegisterationViewController ()

@end

@implementation DocumentsRegisterationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.frame.size.width, 740);
    self.applicationDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _insuranveImgContainerView.layer.borderWidth = 1.0f;
    _insuranveImgContainerView.layer.borderColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.25f].CGColor;
    
    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_insuranveImgContainerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _insuranveImgContainerView.layer.shadowPath = shadowPath.CGPath;
    
    _delegationImgContainerView.layer.borderWidth = 1.0f;
    _delegationImgContainerView.layer.borderColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.25f].CGColor;
    
    UIBezierPath *delegationShadowPath = [UIHelperClass setViewShadow:_delegationImgContainerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _delegationImgContainerView.layer.shadowPath = delegationShadowPath.CGPath;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.vehicleData = [ServiceManager getTempVehicleInfo];
    driverData = [ServiceManager getDriverDataFromUserDefaults];
    NSLog(@"here with owner : %@ and vehicle %@ and driver %@", [self.vehicleData objectForKey:@"isOwner"], self.vehicleData, driverData);
    if(!self.vehicleData){
        NSLog(@"vehicle data is null");
    }
    if([[self.vehicleData objectForKey:@"isOwner"] intValue] == 1)
        [self hideDelegationView:YES];
    else
        [self hideDelegationView:NO];
    
    self.carImageView.layer.cornerRadius = self.carImageView.frame.size.height /2;
    self.carImageView.layer.masksToBounds = YES;
    self.carImageView.layer.borderWidth = 0;
    self.carImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if([[HelperClass getDeviceLanguage] isEqualToString:@"ar"]){
        self.insuranceExpiryLabel.textAlignment = NSTextAlignmentRight;
        self.delegationExpiryDateLabel.textAlignment = NSTextAlignmentRight;
    }
    
    /*Date Picker Work*/
    //Container View
    datePickerContainerView = [[UIView alloc] init];
    datePickerContainerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 260);
    datePickerContainerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:datePickerContainerView];
    //Done Button
    pickersDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pickersDoneButton addTarget:self action:@selector(donePickerSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [pickersDoneButton setTitle:@"Show View" forState:UIControlStateNormal];
    pickersDoneButton.frame = CGRectMake(0, 0, self.view.frame.size.width, 40.0);
    pickersDoneButton.backgroundColor = [UIColor colorWithRed:35.0/255.0f green:46.0/255.0f blue:66.0/255.0f alpha:0.5f];
    [pickersDoneButton setTitle:NSLocalizedString(@"any_done", @"") forState:UIControlStateNormal];
    [datePickerContainerView addSubview:pickersDoneButton];
    //Picker
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, pickersDoneButton.frame.size.height, self.view.frame.size.width, 220)];
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePickerContainerView addSubview:datePicker];
    
    maxExpiry = [HelperClass convertStringToDate:[self.applicationDelegate.appRules objectForKey:@"maxExpiry"] fromFormat:@"yyyy/MM/dd"];
    minExpiry = [HelperClass convertStringToDate:[self.applicationDelegate.appRules objectForKey:@"minExpiry"] fromFormat:@"yyyy/MM/dd"];
    NSLog(@" expiry limit %@", _applicationDelegate.appRules);
    NSLog(@" expiry limit %@", [_applicationDelegate.appRules objectForKey:@"minExpiry"]);
    datePicker.maximumDate = maxExpiry;
    datePicker.minimumDate = minExpiry;
    
    insuranceExpConst = _insuranceLabelTop.constant;
    delegationExpConst = _delegationExpiryLabelTop.constant;
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [_mainScrollView addGestureRecognizer:singleTapGestureRecognizer];
}

- (void)singleTap:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self showHidePickerView:NO];
}

-(void)hideDelegationView:(BOOL)hide{
    
    if(hide){
        [self.delegationView setHidden:YES];
    }else{
        [self.delegationView setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Vehicle
-(void)showImageController:(int)sourceType{
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

-(void)showImageChooseSourceAlert{
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

- (IBAction)insuranceImageAction:(UIButton *)sender {
    currentImageCapturing = 0;
    [self showImageChooseSourceAlert];
}

- (IBAction)delegationImageAction:(UIButton *)sender {
    currentImageCapturing = 1;
    [self showImageChooseSourceAlert];
}

- (IBAction)carImageAction:(UIButton *)sender {
    currentImageCapturing = 2;
    [self showImageChooseSourceAlert];
}

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/yyyy"];
    
    switch (currentDatePicker) {
        case 1:
            insuranceExpiryString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:sender.date]];
            [_insuranceBtn setTitle:insuranceExpiryString forState:UIControlStateNormal];
            insuranceExpiryDate = sender.date;
            insuranceExpiryInMiliseconds = [sender.date timeIntervalSince1970]*1000;
            
            [self selectInsuranceExp];
            break;
        case 2:
            delegationExpiryString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:sender.date]];
            [_delegationExpiryBtn setTitle:delegationExpiryString forState:UIControlStateNormal];
            delegationExpiryDate = sender.date;
            delegationExpiryInMiliseconds = [sender.date timeIntervalSince1970]*1000;
            
            [self selectDelegationExp];
            break;
            
        default:
            break;
    }
}

-(void)selectInsuranceExp{
    _insuranceLabelTop.constant = insuranceExpConst - 30;
    [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.view layoutIfNeeded];
                         _insuranceExpiryLabel.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:14];
                     }  completion:^(BOOL finished){}];
    
    [_insuranceSubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    if(_insuranceBtn == currentFieldPopup){
        if(popupViewTag && (popupViewTag > 0)){
            UIView *tempView = [self.view viewWithTag:popupViewTag];
            [tempView removeFromSuperview];
            tempView = nil;
        }
    }
}

-(void)selectDelegationExp{
    _delegationExpiryLabelTop.constant = delegationExpConst - 30;
    [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.view layoutIfNeeded];
                         _delegationExpiryDateLabel.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:14];
                     }  completion:^(BOOL finished){}];
    
    [_delegationExpirySubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    if(_delegationExpiryBtn == currentFieldPopup){
        if(popupViewTag && (popupViewTag > 0)){
            UIView *tempView = [self.view viewWithTag:popupViewTag];
            [tempView removeFromSuperview];
            tempView = nil;
        }
    }
}

-(void) showHidePickerView:(BOOL)show{
    [self.view endEditing:YES];
    datePicker.backgroundColor = [UIColor clearColor];
    datePicketViewShown = show;
    [self.delegate addSubView:datePickerContainerView andShow:show andMoveFooter:NO];
    
}

- (IBAction)chooseInsuranceExpiryDateAction:(UIButton *)sender {
    datePicker.date = [NSDate date];
    
    currentDatePicker = 1;
    NSLog(@"should show picker Insurance Expiry");
    [self showHidePickerView:YES];
}

- (IBAction)chooseDelegationExpiryAction:(UIButton *)sender {
    datePicker.date = [NSDate date];

    currentDatePicker = 2;
    NSLog(@"should show picker delegation Expiry");
    [self showHidePickerView:YES];
}

- (IBAction)donePickerSelectAction:(UIButton *)sender {
    [self showHidePickerView:NO];
}

- (IBAction)termsButtonAction:(UIButton *)sender {
    termsConfirmed = !termsConfirmed;
    if(termsConfirmed)
        [self.termsButton setBackgroundImage:[UIImage imageNamed:@"terms_Correct_Icon-01.png"] forState:UIControlStateNormal];
    else
        [self.termsButton setBackgroundImage:[UIImage imageNamed:@"Term_of_use_box-01.png"] forState:UIControlStateNormal];
    
    [[self.termsButton layer] setBorderColor:[UIColor clearColor].CGColor];
}

-(void)processCompleteVehicleRequest
{
    [experienceView removeFromSuperview];
    experienceView = [[WorkExperienceView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    experienceView.delegate = self;
    [self.delegate addExperienceView:experienceView];
}

-(void)finishWorkExpWithAnswer:(BOOL)worked{
    [self hideME];
    
    workedForUber = worked;
    [self processFinalRequest];
}

-(void)hideME{
    [UIView animateWithDuration:0.3 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         experienceView.alpha = 0.0f;
                     } completion:^(BOOL finished){
                         [experienceView removeFromSuperview];
                         experienceView = nil;
                     }];
}

-(void)processFinalRequest{
    NSDictionary *parameters =
    @{
      @"vehicle": @{
              @"driverId": driverData ? [driverData objectForKey:@"_id"] : @"",
              @"insuranceExpiry" : (insuranceExpiryInMiliseconds && insuranceExpiryDate && ![insuranceExpiryDate isEqual:[NSNull null]]) ? [NSString stringWithFormat:@"%f", insuranceExpiryInMiliseconds] : @"",
              @"isOwner" : ([[self.vehicleData objectForKey:@"isOwner"] intValue] == 1) ? @"true" : @"false",
              @"delegationOrLeaseExpiry" : (delegationExpiryInMiliseconds && delegationExpiryDate && ![delegationExpiryDate isEqual:[NSNull null]]) ?  [NSString stringWithFormat:@"%f", delegationExpiryInMiliseconds] : @"",
              @"manufacturer" : self.vehicleData ? [self.vehicleData  objectForKey:@"manufacturer"] : @"",
              @"model" : self.vehicleData ? [self.vehicleData objectForKey:@"model"] : @"",
              @"plateLetters" : self.vehicleData ? [self.vehicleData objectForKey:@"plateLetters"] : @"",
              @"plateNumber" : self.vehicleData ? [NSString stringWithFormat:@"%@", [self.vehicleData objectForKey:@"plateNumber"]] : @"",
              @"registrationExpiry": self.vehicleData ? [NSString stringWithFormat:@"%@", [self.vehicleData objectForKey:@"registrationExpiry"]] : @"",
              @"sequenceNumber": self.vehicleData ? [NSString stringWithFormat:@"%@", [self.vehicleData objectForKey:@"sequenceNumber"]] : @"",
              @"year" : self.vehicleData ? [NSString stringWithFormat:@"%@", [self.vehicleData objectForKey:@"year"]] : @"",
              }
      };
    NSLog(@"will validate data : %@", parameters);
    NSDictionary *validation = [ClientSideValidation validateCompleteVehicleData:[parameters objectForKey:@"vehicle"]];
    if([[validation objectForKey:@"isAllValid"] isEqualToString:@"1"]){
        if((self.applicationDelegate.insuranceImg)){
            if(self.applicationDelegate.carImg){
                if(termsConfirmed){
                    /* Passed Client-Side validations */
                    /* Show loading View */
                    [self.delegate showRootLoadingView];
                    [self.view endEditing:YES];
                    [self performSelectorInBackground:@selector(addVehicleInfoRequest:) withObject:parameters];
                }else{
                    [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"enter_mobile_terms_not_approved_error_title", @"") andMessage:NSLocalizedString(@"enter_mobile_terms_not_approved_error_title", @"")] animated:YES completion:nil];
                    [[self.termsButton layer] setBorderWidth:0.5f];
                    [[self.termsButton layer] setBorderColor:[UIColor redColor].CGColor];
                }
            }else{
                [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"docs_missing_vehicle_image_title", @"") andMessage:NSLocalizedString(@"docs_missing_vehicle_image_message", @"")] animated:YES completion:nil];
            }
        }else{
            self.insuranceImageLabel.textColor = [UIColor redColor];
        }
        
        
    }else{
        NSLog(@"client side validation NOT passed with response : %@", validation);
        [self shakeMissingFields:validation];
    }
}

-(void)addVehicleInfoRequest:(NSDictionary *)parameters{
    @autoreleasepool {
        BOOL validated = [ServiceManager registerVehicle:parameters andAccessToken:[ServiceManager getAccessTokenFromKeychain] :^(NSDictionary *response){
            NSLog(@"Add Vehicle Response : %@", response);
            [self performSelectorOnMainThread:@selector(finishAddVehicle:) withObject:response waitUntilDone:NO];
        }];
        if(!validated)
            [self performSelectorOnMainThread:@selector(finishAddVehicle:) withObject:nil waitUntilDone:NO];
    }
}
-(void)finishAddVehicle:(NSDictionary *)vehicleData
{
    [self.delegate hideRootLoadingView];
    NSLog(@"done Vehicle info validation %@", vehicleData);
    if(vehicleData && [vehicleData objectForKey:@"data"]){
        NSLog(@"vehicle info validation successful with data %@ and go to documents attach screen", [vehicleData objectForKey:@"data"]);
        
        [ServiceManager saveRegisterVehicleData:[vehicleData objectForKey:@"data"] :^(BOOL completed){
            if(completed)
                [ServiceManager saveCurrentRegisterationStep:@"uploads"];
        }];
        [self.delegate goToDocumentsProgressScreenWithVehicleData:@"vehicle"];
    }else{
        /* Failed */
        NSLog(@"hhh %@ hhh %@", NSLocalizedString(@"docs_failed_add_vehicle_title", @""), NSLocalizedString(@"docs_failed_add_vehicle_title", @""));
        
        [self serverSideValidation:vehicleData];
        
    }
}

#pragma mark - Camera Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSData * pngData = UIImagePNGRepresentation(info[UIImagePickerControllerEditedImage]);
    //Check image size limit (5MB)
    if(((float)[pngData length]/1048576) <= 5){
        // get selected image
        UIImage *imageCaptured = info[UIImagePickerControllerEditedImage];
        
        //Dismiss camera picker controller
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
        if(imageCaptured){
            // Update Textfield text
            switch (currentImageCapturing) {
                case 0:
                    [self.insuranceImageCheckmark setImage:[UIImage imageNamed:@"RegWhiteCheckmark"]];
                    self.applicationDelegate.insuranceImg = imageCaptured;
                    [self.insuranceImageLabel setTextColor:[UIColor whiteColor]];
                    break;
                case 1:
                    [self.delegationImageCheckmark setImage:[UIImage imageNamed:@"RegWhiteCheckmark"]];
                    self.applicationDelegate.delegationImg = imageCaptured;
                    [self.delegationImageLabel setTextColor:[UIColor whiteColor]];
                    break;
                case 2:
                    [self.carImageCheckmark setImage:[UIImage imageNamed:@"RegWhiteCheckmark"]];
                    [self.carImageView setImage:imageCaptured];
                    self.applicationDelegate.carImg = imageCaptured;
                    break;
                    
                default:
                    break;
            }
        }
    }else{
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_image_size_title", @"") andMessage:NSLocalizedString(@"general_image_size_message", @"")] animated:YES completion:nil];
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - Hide Keyboard when click anywhere
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:TRUE];
    if(datePicketViewShown){
        [self showHidePickerView:NO];
    }
}
#pragma mark - Shake Missing Fields
-(void)shakeMissingFields:(NSDictionary *)fields{
    
    
    if([[self.vehicleData objectForKey:@"isOwner"] intValue] == 0){
        if(!self.applicationDelegate.delegationImg){
            self.delegationImageLabel.textColor = [UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f];
        }
    }
    
    if(!self.applicationDelegate.carImg){
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"docs_missing_vehicle_image_title", @"") andMessage:NSLocalizedString(@"docs_missing_vehicle_image_message", @"")] animated:YES completion:nil];
    }
    
    if(!self.applicationDelegate.delegationImg)
        self.delegationImageLabel.textColor = [UIColor redColor];
    
    if([[fields objectForKey:@"delegationOrLeaseExpiry"] isEqualToString:@"1"])
        [self addPopupToField:_delegationExpiryBtn andMessage:@"Missing Delegation Expiry" andSubview:_delegationExpirySubview];
    
    if(!self.applicationDelegate.insuranceImg)
        self.insuranceImageLabel.textColor = [UIColor redColor];
    
    if([[fields objectForKey:@"insuranceExpiry"] isEqualToString:@"1"])
        [self addPopupToField:_insuranceBtn andMessage:@"Missing Insurance Expiry" andSubview:_insuranceSubview];
    
    if([[fields objectForKey:@"driverId"] isEqualToString:@"1"])
        [self presentViewController:[HelperClass showAlert:@"No Registered Driver" andMessage:@"Please call EGO customer service to register as a driver"] animated:YES completion:nil];
}

-(void)serverSideValidation:(NSDictionary *)errorData{
    if([[errorData objectForKey:@"code"] intValue] == 400){
        NSString *errorField = [[errorData objectForKey:@"error"] objectForKey:@"field"];
        if([errorField isEqualToString:@"insuranceExpiry"])
            
            [self addPopupToField:_insuranceBtn andMessage:@"Missing Insurance Expiry" andSubview:_insuranceSubview];
        
        else if([errorField isEqualToString:@"delegationOrLeaseExpiry"])
            
            [self addPopupToField:_delegationExpiryBtn andMessage:@"Missing Delegation Expiry" andSubview:_delegationExpirySubview];
        
        else{
            [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"docs_failed_add_vehicle_title", @"") andMessage:NSLocalizedString(@"docs_failed_add_vehicle_message", @"")] animated:YES completion:nil];
        }
    }else if([[errorData objectForKey:@"code"] intValue] == 409){
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"vehicle_already_exists_title", @"") andMessage:NSLocalizedString(@"vehicle_already_exists_message", @"")] animated:YES completion:nil];
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
