//
//  DocumentsProgressViewController.m
//  ProcapDriver
//
//  Created by MacBookPro on 3/26/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "DocumentsProgressViewController.h"

@interface DocumentsProgressViewController ()

@end

@implementation DocumentsProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.applicationDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self.driverIDProgress setProgress:0];
    [self.drivingLicenseProgress setProgress:0];
    [self.vehicleRegProgress setProgress:0];
    [self.vehicleInsuranceProgress setProgress:0];
    [self.vehicleImageProgress setProgress:0];
    [self.delegationImageProgress setProgress:0];
    
    automaticUploadFinished = NO;
    comintFromImagePicker = NO;
    
    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_driverIDContainer edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _driverIDContainer.layer.shadowPath = shadowPath.CGPath;
    
    UIBezierPath *driveLicPath = [UIHelperClass setViewShadow:_drivingLicContainer edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _drivingLicContainer.layer.shadowPath = driveLicPath.CGPath;
    
    UIBezierPath *vehicleRegPath = [UIHelperClass setViewShadow:_vehicleRegContainer edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _vehicleRegContainer.layer.shadowPath = vehicleRegPath.CGPath;
    
    UIBezierPath *_insuranceContainerPath = [UIHelperClass setViewShadow:_insuranceContainer edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _insuranceContainer.layer.shadowPath = _insuranceContainerPath.CGPath;
    
    UIBezierPath *_vehicleImageContainerViewPath = [UIHelperClass setViewShadow:_vehicleImageContainer edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _vehicleImageContainer.layer.shadowPath = _vehicleImageContainerViewPath.CGPath;
    
    UIBezierPath *delegationContainerViewPath = [UIHelperClass setViewShadow:_delegationContainerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _delegationContainerView.layer.shadowPath = delegationContainerViewPath.CGPath;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    vehicleData = [ServiceManager getVehicleDataFromUserDefaults];
    
    driverData = [ServiceManager getDriverDataFromUserDefaults];
    
    //Coming from vehicle, Or just open the app
    if([self.comingFrom isEqualToString:@"vehicle"]){
        //First time here, Start auto uploads sequentially
        [self uploadIDImage:NO andImage:self.applicationDelegate.idImage];
    }else if([self.comingFrom isEqualToString:@"start"]){
        //Coming after app was closed previously, Should enable/disable available/not-available buttons
        [self comeFromStart];
    }else{
        //Coming from camera... Nothing to do
    }
    
    NSLog(@"Vehicle data : %@ ", vehicleData);
    NSLog(@"driver data : %@", driverData);
    NSLog(@"coming from : %@", self.comingFrom);
    [self.delegate hideFooterView];
    
    if([[vehicleData objectForKey:@"isOwner"] intValue] == 1){
        [self.delegationContainerView setHidden:YES];
    }else{
        [self.delegationContainerView setHidden:NO];
    }
    
}

-(void)comeFromStart{
    

    if([[driverData objectForKey:@"ssnPhotoExists"] intValue] == 1){
        self.driverIDButton.enabled = NO;
        _idImageView.image = [_idImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_idImageView setTintColor:[UIColor whiteColor]];
        [self.driverIDProgress setProgress:1];
    }else{
        _idImageView.image = [_idImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_idImageView setTintColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94/255.0f alpha:1.0f]];
        [self.driverIDProgress setProgress:0];
        self.driverIDButton.enabled = YES;
    }
    
    if([[driverData objectForKey:@"licensePhotoExists"] intValue] == 1){
        self.drivingLicenseButton.enabled = NO;
        _drivingLicenseImageView.image = [_idImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_drivingLicenseImageView setTintColor:[UIColor whiteColor]];
        [self.drivingLicenseProgress setProgress:1];
    }else{
        _drivingLicenseImageView.image = [_drivingLicenseImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_drivingLicenseImageView setTintColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94/255.0f alpha:1.0f]];
        [self.drivingLicenseProgress setProgress:0];
        self.drivingLicenseButton.enabled = YES;
    }
    
    if([[vehicleData objectForKey:@"registrationPhotoExists"] intValue] == 1){
        self.vehicleRegButton.enabled = NO;
        _vehicleRegImageView.image = [_idImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_vehicleRegImageView setTintColor:[UIColor whiteColor]];
        [self.vehicleRegProgress setProgress:1];
    }else{
        _vehicleRegImageView.image = [_vehicleRegImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_vehicleRegImageView setTintColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94/255.0f alpha:1.0f]];
        [self.vehicleRegProgress setProgress:0];
        self.vehicleRegButton.enabled = YES;
    }
    
    if([[vehicleData objectForKey:@"insurancePhotoExists"] intValue] == 1){
        self.vehicleInsuranceButton.enabled = NO;
        _insuranceImageView.image = [_insuranceImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_insuranceImageView setTintColor:[UIColor whiteColor]];
        [self.vehicleInsuranceProgress setProgress:1];
    }else{
        _insuranceImageView.image = [_insuranceImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_insuranceImageView setTintColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94/255.0f alpha:1.0f]];
        [self.vehicleInsuranceProgress setProgress:0];
        self.vehicleInsuranceButton.enabled = YES;
    }
    
    if([[vehicleData objectForKey:@"carPhotoExists"] intValue] == 1){
        self.vehicleImageButton.enabled = NO;
        _carDoneImageView.image = [_carDoneImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_carDoneImageView setTintColor:[UIColor whiteColor]];
        [self.vehicleImageProgress setProgress:1];
    }else{
        _carDoneImageView.image = [_carDoneImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_carDoneImageView setTintColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94/255.0f alpha:1.0f]];
        [self.vehicleImageProgress setProgress:0];
        self.vehicleImageButton.enabled = YES;
    }
    
    if([[vehicleData objectForKey:@"delegationOrLeasePhotoExists"] intValue] == 1){
        self.delegationButton.enabled = NO;
        _delegationImageView.image = [_delegationImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_delegationImageView setTintColor:[UIColor whiteColor]];
        [self.delegationImageProgress setProgress:1];
    }else{
        _delegationImageView.image = [_delegationImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_delegationImageView setTintColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94/255.0f alpha:1.0f]];
        [self.delegationImageProgress setProgress:0];
        self.delegationButton.enabled = YES;
    }
}



-(void)checkAllUploaded{
    if(([[driverData objectForKey:@"ssnPhotoExists"] intValue] == 1) && ([[driverData objectForKey:@"licensePhotoExists"] intValue] == 1) && ([[vehicleData objectForKey:@"registrationPhotoExists"] intValue] == 1) && ([[vehicleData objectForKey:@"insurancePhotoExists"] intValue] == 1) && ([[vehicleData objectForKey:@"carPhotoExists"] intValue] == 1)){
        if([[vehicleData objectForKey:@"isOwner"] intValue] == 1){
            [ServiceManager saveCurrentRegisterationStep:@"all_done"];
            [self performSegueWithIdentifier:@"GoToGreatings" sender:self];
        }else{
            if([[vehicleData objectForKey:@"delegationOrLeasePhotoExists"] intValue] == 1){
                [ServiceManager saveCurrentRegisterationStep:@"all_done"];
                [self performSegueWithIdentifier:@"GoToGreatings" sender:self];
                
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)uploadFile:(NSDictionary *)uploadData
{
    @autoreleasepool {
        [(UIButton *)[uploadData objectForKey:@"uploadButton"] setEnabled:NO];
        if(([uploadData objectForKey:@"image"]) && [[uploadData objectForKey:@"image"] isKindOfClass:[UIImage class]]){
            [ServiceManager uploadImage:[uploadData objectForKey:@"image"] andPhotoType:[uploadData objectForKey:@"type"] andAccessToken:[ServiceManager getAccessTokenFromKeychain] :^(double progress){
                NSLog(@"image Upload progress : %f", progress);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Update the progress view
                    [(UIProgressView *)[uploadData objectForKey:@"progressBar"] setProgress:progress*0.6 animated:YES];
                });
            } :^(NSDictionary *response){
                if(!([[response objectForKey:@"code"] intValue] == 200)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //Update the progress view
                        [(UIProgressView *)[uploadData objectForKey:@"progressBar"] setProgress:0 animated:YES];
                        [[uploadData objectForKey:@"uploadButton"] setEnabled:YES];

                        UIImageView *imgView = (UIImageView *)[uploadData objectForKey:@"resultImage"];
                        imgView.image = [imgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                        [imgView setTintColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94/255.0f alpha:1.0f]];
                        [self serverSideValidation:response];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //Update the progress view
                        [(UIProgressView *)[uploadData objectForKey:@"progressBar"] setProgress:1 animated:YES];
                        [(UIButton *)[uploadData objectForKey:@"uploadButton"] setEnabled:NO];
                        
                        UIImageView *imgView = (UIImageView *)[uploadData objectForKey:@"resultImage"];
                        imgView.image = [imgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                        [imgView setTintColor:[UIColor whiteColor]];
                    });
                    
                    if([[uploadData objectForKey:@"type"] isEqualToString:[NSString stringWithFormat:@"drivers/%@/photos/ssn", [driverData objectForKey:@"_id"]]]){
                        
                        [ServiceManager saveLoggedInDriverData:[response objectForKey:@"data"] andAccessToken:nil];
                        driverData = [ServiceManager getDriverDataFromUserDefaults];
                    }
                    if([[uploadData objectForKey:@"type"] isEqualToString:[NSString stringWithFormat:@"drivers/%@/photos/license", [driverData objectForKey:@"_id"]]]){
                        [ServiceManager saveLoggedInDriverData:[response objectForKey:@"data"] andAccessToken:nil];
                        driverData = [ServiceManager getDriverDataFromUserDefaults];
                    }
                    if([[uploadData objectForKey:@"type"] isEqualToString:[NSString stringWithFormat:@"vehicles/%@/photos/registration", [vehicleData objectForKey:@"_id"]]]){
                        [ServiceManager saveRegisterVehicleData:[response objectForKey:@"data"] :^(BOOL completed){[[NSUserDefaults standardUserDefaults] synchronize];}];
                        vehicleData = [ServiceManager getVehicleDataFromUserDefaults];
                    }
                    if([[uploadData objectForKey:@"type"] isEqualToString:[NSString stringWithFormat:@"vehicles/%@/photos/insurance", [vehicleData objectForKey:@"_id"]]]){
                        [ServiceManager saveRegisterVehicleData:[response objectForKey:@"data"] :^(BOOL completed){[[NSUserDefaults standardUserDefaults] synchronize];}];
                        vehicleData = [ServiceManager getVehicleDataFromUserDefaults];
                    }
                    if([[uploadData objectForKey:@"type"] isEqualToString:[NSString stringWithFormat:@"vehicles/%@/photos/car", [vehicleData objectForKey:@"_id"]]]){
                        [ServiceManager saveRegisterVehicleData:[response objectForKey:@"data"] :^(BOOL completed){[[NSUserDefaults standardUserDefaults] synchronize];}];
                        vehicleData = [ServiceManager getVehicleDataFromUserDefaults];
                    }
                    if([[uploadData objectForKey:@"type"] isEqualToString:[NSString stringWithFormat:@"vehicles/%@/photos/delegationOrLease", [vehicleData objectForKey:@"_id"]]]){
                        [ServiceManager saveRegisterVehicleData:[response objectForKey:@"data"] :^(BOOL completed){[[NSUserDefaults standardUserDefaults] synchronize];}];
                        vehicleData = [ServiceManager getVehicleDataFromUserDefaults];
                    }
                }
                [self performSelectorOnMainThread:@selector(callNextStep:) withObject:[uploadData objectForKey:@"nextUpload"] waitUntilDone:YES];
            }];
        }else{
            NSLog(@"no image to upload : %@", [uploadData objectForKey:@"type"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[uploadData objectForKey:@"uploadButton"] setEnabled:YES];
                
                UIImageView *imgView = (UIImageView *)[uploadData objectForKey:@"resultImage"];
                imgView.image = [imgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [imgView setTintColor:[UIColor whiteColor]];
            });
            [self performSelectorOnMainThread:@selector(callNextStep:) withObject:[uploadData objectForKey:@"nextUpload"] waitUntilDone:YES];
        }
    }
}

-(void)serverSideValidation:(NSDictionary *)errorData{
    if([[errorData objectForKey:@"code"] intValue] == 400){
        NSDictionary *errors = [errorData objectForKey:@"errors"];
        if([[errors objectForKey:@"accessToken"] intValue] == 1)
            [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"prog_auth_error_title", @"") andMessage:NSLocalizedString(@"prog_auth_error_message", @"")] animated:YES completion:nil];
        if([[errors objectForKey:@"driverId"] intValue] == 1)
            [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"prog_no_driver_error_title", @"") andMessage:NSLocalizedString(@"prog_no_driver_error_message", @"")] animated:YES completion:nil];
        if([[errors objectForKey:@"file"] intValue] == 1)
            [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"prog_file_error_title", @"") andMessage:NSLocalizedString(@"prog_file_error_message", @"")] animated:YES completion:nil];
        if([[errors objectForKey:@"fileName"] intValue] == 1)
            [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"prog_file_name_error_title", @"") andMessage:NSLocalizedString(@"prog_file_name_error_message", @"")] animated:YES completion:nil];
    }else if([[errorData objectForKey:@"code"] intValue] == 409){
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"prog_already_exists_error_title", @"") andMessage:NSLocalizedString(@"prog_already_exists_error_message", @"")] animated:YES completion:nil];
    }else{
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"prog_file_name_error_title", @"") andMessage:NSLocalizedString(@"prog_file_name_error_message", @"")] animated:YES completion:nil];
    }
}

-(void)callNextStep:(NSString *)nextStep{
    NSLog(@"next step : %@", nextStep);
    vehicleData = [ServiceManager getVehicleDataFromUserDefaults];
    driverData = [ServiceManager getDriverDataFromUserDefaults];
    
    if([[driverData objectForKey:@"ssnPhotoExists"] intValue] == 1){
        self.driverIDButton.enabled = NO;
        
        _idImageView.image = [_idImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_idImageView setTintColor:[UIColor whiteColor]];
        
        [self.driverIDProgress setProgress:1];
    }else{
        if(automaticUploadFinished)
            self.driverIDButton.enabled = YES;
        
        _idImageView.image = [_idImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_idImageView setTintColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94/255.0f alpha:1.0f]];
        
        [self.driverIDProgress setProgress:0];
    }
    
    if([[driverData objectForKey:@"licensePhotoExists"] intValue] == 1){
        self.drivingLicenseButton.enabled = NO;
        
        _drivingLicenseImageView.image = [_drivingLicenseImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_drivingLicenseImageView setTintColor:[UIColor whiteColor]];
        
        [self.drivingLicenseProgress setProgress:1];
    }else{
        if(automaticUploadFinished)
            self.drivingLicenseButton.enabled = YES;
        
        _drivingLicenseImageView.image = [_drivingLicenseImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_drivingLicenseImageView setTintColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94/255.0f alpha:1.0f]];
        
        [self.drivingLicenseProgress setProgress:0];
    }
    
    if([[vehicleData objectForKey:@"registrationPhotoExists"] intValue] == 1){
        self.vehicleRegButton.enabled = NO;
        
        _vehicleRegImageView.image = [_vehicleRegImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_vehicleRegImageView setTintColor:[UIColor whiteColor]];
        
        [self.vehicleRegProgress setProgress:1];
    }else{
        if(automaticUploadFinished)
            self.vehicleRegButton.enabled = YES;
        
        _vehicleRegImageView.image = [_vehicleRegImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_vehicleRegImageView setTintColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94/255.0f alpha:1.0f]];
        
        [self.vehicleRegProgress setProgress:0];
    }
    
    if([[vehicleData objectForKey:@"insurancePhotoExists"] intValue] == 1){
        self.vehicleInsuranceButton.enabled = NO;
        
        _insuranceImageView.image = [_insuranceImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_insuranceImageView setTintColor:[UIColor whiteColor]];
        
        [self.vehicleInsuranceProgress setProgress:1];
    }else{
        if(automaticUploadFinished)
            self.vehicleInsuranceButton.enabled = YES;
        
        _insuranceImageView.image = [_insuranceImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_insuranceImageView setTintColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94/255.0f alpha:1.0f]];
        
        [self.vehicleInsuranceProgress setProgress:0];
    }
    
    if([[vehicleData objectForKey:@"carPhotoExists"] intValue] == 1){
        self.vehicleImageButton.enabled = NO;
        
        _carDoneImageView.image = [_carDoneImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_carDoneImageView setTintColor:[UIColor whiteColor]];
        
        [self.vehicleImageProgress setProgress:1];
    }else{
        if(automaticUploadFinished)
            self.vehicleImageButton.enabled = YES;
        
        _carDoneImageView.image = [_carDoneImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_carDoneImageView setTintColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94/255.0f alpha:1.0f]];
        
        [self.vehicleImageProgress setProgress:0];
    }
    
    if([[vehicleData objectForKey:@"delegationOrLeasePhotoExists"] intValue] == 1){
        self.delegationButton.enabled = NO;
        
        _delegationImageView.image = [_delegationImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_delegationImageView setTintColor:[UIColor whiteColor]];
        
        [self.delegationImageProgress setProgress:1];
    }else{
        if(automaticUploadFinished)
            self.delegationButton.enabled = YES;
        
        _delegationImageView.image = [_delegationImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_delegationImageView setTintColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94/255.0f alpha:1.0f]];
        
        [self.delegationImageProgress setProgress:0];
    }
    
    if(([nextStep isEqualToString:@"drivingLicense"]) && !([[driverData objectForKey:@"licensePhotoExists"] intValue] == 1)){
        [self uploadDrivingLicense:NO andImage:nil];
    }else if(([nextStep isEqualToString:@"vehicleRegistration"]) && !([[vehicleData objectForKey:@"registrationPhotoExists"] intValue] == 1)){
        [self uploadVehicleRegImage:NO andImage:nil];
    }else if(([nextStep isEqualToString:@"insurance"]) && !([[vehicleData objectForKey:@"insurancePhotoExists"] intValue] == 1)){
        [self uploadInsuranceImage:NO andImage:nil];
    }else if(([nextStep isEqualToString:@"carImage"]) && !([[vehicleData objectForKey:@"carPhotoExists"] intValue] == 1)){
        [self uploadCarImage:NO andImage:nil];
    }else if (([nextStep isEqualToString:@"delegationImage"]) && !([[vehicleData objectForKey:@"delegationOrLeasePhotoExists"] intValue] == 1)){
        [self uploadDelegationImage:NO andImage:nil];
        automaticUploadFinished = YES;
    }
    
    [self checkAllUploaded];
}

-(void)checkButtons{
    if(!([[driverData objectForKey:@"ssnPhotoExists"] intValue] == 1))
        [self.driverIDButton setEnabled:NO];
    if(!([[driverData objectForKey:@"licensePhotoExists"] intValue] == 1))
        [self.drivingLicenseButton setEnabled:NO];
    if(!([[vehicleData objectForKey:@"registrationPhotoExists"] intValue] == 1))
        [self.vehicleRegButton setEnabled:NO];
    if(!([[vehicleData objectForKey:@"insurancePhotoExists"] intValue] == 1))
        [self.vehicleInsuranceButton setEnabled:NO];
    if(!([[vehicleData objectForKey:@"carPhotoExists"] intValue] == 1))
        [self.vehicleImageButton setEnabled:NO];
    if([[vehicleData objectForKey:@"isOwner"] intValue] == 0){
        if(!([[vehicleData objectForKey:@"delegationOrLeasePhotoExists"] intValue] == 1))
            [self.delegationButton setEnabled:NO];
    }
}

#pragma mark - Uploads start here
-(void)uploadIDImage:(BOOL)singleUpload andImage:(UIImage *)imageToUpload
{
    UIImage *finalImg = singleUpload ? imageToUpload : self.applicationDelegate.idImage;
    NSDictionary *uploadParameters = @{
                                       @"image" : finalImg ? finalImg : @"false",
                                       @"type" : [NSString stringWithFormat:@"drivers/%@/photos/ssn", [driverData objectForKey:@"_id"]],
                                       @"progressBar" : self.driverIDProgress,
                                       @"uploadButton" : self.driverIDButton,
                                       @"nextUpload" : !singleUpload ? @"drivingLicense" : @"stop",
                                       @"resultImage" : self.idImageView
                                       };
    [self performSelectorInBackground:@selector(uploadFile:) withObject:uploadParameters];
}

-(void)uploadDrivingLicense:(BOOL)singleUpload andImage:(UIImage *)imageToUpload
{
    UIImage *finalImg = singleUpload ? imageToUpload : self.applicationDelegate.drivingLicenseImage;
    NSDictionary *uploadParameters = @{
                                       @"image" : finalImg ? finalImg : @"false",
                                       @"type" : [NSString stringWithFormat:@"drivers/%@/photos/license", [driverData objectForKey:@"_id"]],
                                       @"progressBar" : self.drivingLicenseProgress,
                                       @"uploadButton" : self.drivingLicenseButton,
                                       @"nextUpload" : singleUpload ? @"stop" : @"vehicleRegistration",
                                       @"resultImage" : self.drivingLicenseImageView
                                       };
    [self performSelectorInBackground:@selector(uploadFile:) withObject:uploadParameters];
    
}

-(void)uploadVehicleRegImage:(BOOL)singleUpload andImage:(UIImage *)imageToUpload
{
    UIImage *finalImg = singleUpload ? imageToUpload : self.applicationDelegate.vehicleRegImage;
    NSDictionary *uploadParameters = @{
                                       @"image" : finalImg ? finalImg : @"false",
                                       @"type" : [NSString stringWithFormat:@"vehicles/%@/photos/registration", [vehicleData objectForKey:@"_id"]],
                                       @"progressBar" : self.vehicleRegProgress,
                                       @"uploadButton" : self.vehicleRegButton,
                                       @"nextUpload" : singleUpload ? @"stop" : @"insurance",
                                       @"resultImage" : self.vehicleRegImageView
                                       };
    [self performSelectorInBackground:@selector(uploadFile:) withObject:uploadParameters];
    
}

-(void)uploadInsuranceImage:(BOOL)singleUpload andImage:(UIImage *)imageToUpload
{
    UIImage *finalImg = singleUpload ? imageToUpload : self.applicationDelegate.insuranceImg;
    NSDictionary *uploadParameters = @{
                                       @"image" : finalImg ? finalImg : @"false",
                                       @"type" : [NSString stringWithFormat:@"vehicles/%@/photos/insurance", [vehicleData objectForKey:@"_id"]],
                                       @"progressBar" : self.vehicleInsuranceProgress,
                                       @"uploadButton" : self.vehicleInsuranceButton,
                                       @"nextUpload" : singleUpload ? @"stop" : @"carImage",
                                       @"resultImage" : self.insuranceImageView
                                       };
    [self performSelectorInBackground:@selector(uploadFile:) withObject:uploadParameters];
    
}

-(void)uploadCarImage:(BOOL)singleUpload andImage:(UIImage *)imageToUpload
{
    UIImage *finalImg = singleUpload ? imageToUpload : self.applicationDelegate.carImg;
    NSDictionary *uploadParameters = @{
                                       @"image" : finalImg ? finalImg : @"false",
                                       @"type" : [NSString stringWithFormat:@"vehicles/%@/photos/car", [vehicleData objectForKey:@"_id"]],
                                       @"progressBar" : self.vehicleImageProgress,
                                       @"uploadButton" : self.vehicleImageButton,
                                       @"nextUpload" : singleUpload ? @"stop" : @"delegationImage",
                                       @"resultImage" : self.carDoneImageView
                                       };
    [self performSelectorInBackground:@selector(uploadFile:) withObject:uploadParameters];
    
}

-(void)uploadDelegationImage:(BOOL)singleUpload andImage:(UIImage *)imageToUpload
{
    UIImage *finalImg = singleUpload ? imageToUpload : self.applicationDelegate.delegationImg;
    NSDictionary *uploadParameters = @{
                                       @"image" : finalImg ? finalImg : @"false",
                                       @"type" : [NSString stringWithFormat:@"vehicles/%@/photos/delegationOrLease", [vehicleData objectForKey:@"_id"]],
                                       @"progressBar" : self.delegationImageProgress,
                                       @"uploadButton" : self.delegationButton,
                                       @"nextUpload" : @"stop",
                                       @"resultImage" : self.delegationImageView
                                       };
    [self performSelectorInBackground:@selector(uploadFile:) withObject:uploadParameters];

}

- (IBAction)addDriverIDImage:(UIButton *)sender {
    currentImageCapturing = 1;
    [self alertForChoosingSource];
}

- (IBAction)addDrivingLicenseImage:(UIButton *)sender {
    currentImageCapturing = 2;
    [self alertForChoosingSource];
}

- (IBAction)addVehicleRegistationImage:(UIButton *)sender {
    currentImageCapturing = 3;
    [self alertForChoosingSource];
}

- (IBAction)addInsuranceImage:(UIButton *)sender {
    currentImageCapturing = 4;
    [self alertForChoosingSource];
}

- (IBAction)addDelegationImage:(UIButton *)sender {
    currentImageCapturing = 5;
    [self alertForChoosingSource];
}

- (IBAction)addVehicleImage:(UIButton *)sender {
    currentImageCapturing = 6;
    [self alertForChoosingSource];
}

-(void)alertForChoosingSource{
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

-(void)showImageController:(int)source{
    comintFromImagePicker = YES;
    self.comingFrom = @"camera";
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    switch (source) {
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


#pragma mark - Camera Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSData * pngData = UIImagePNGRepresentation(info[UIImagePickerControllerEditedImage]);
    //Check image size limit (5MB)
    if(((float)[pngData length]/1048576) <= 5){
        // get selected image
        recentUploadedImage = info[UIImagePickerControllerEditedImage];
        
        //Dismiss camera picker controller
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
        if(recentUploadedImage){
            // Update Textfield text
            switch (currentImageCapturing) {
                case 1:
                    [self uploadIDImage:YES andImage:recentUploadedImage];
                    break;
                case 2:
                    [self uploadDrivingLicense:YES andImage:recentUploadedImage];
                    break;
                case 3:
                    [self uploadVehicleRegImage:YES andImage:recentUploadedImage];
                    break;
                case 4:
                    [self uploadInsuranceImage:YES andImage:recentUploadedImage];
                    break;
                case 5:
                    [self uploadDelegationImage:YES andImage:recentUploadedImage];
                    break;
                case 6:
                    [self uploadCarImage:YES andImage:recentUploadedImage];
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



@end
