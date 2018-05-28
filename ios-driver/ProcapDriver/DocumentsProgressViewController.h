//
//  DocumentsProgressViewController.h
//  ProcapDriver
//
//  Created by MacBookPro on 3/26/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "ServiceManager.h"
#import "HelperClass.h"
#import "UIHelperClass.h"
#import "ClientSideValidation.h"

@protocol DocumentsProgressViewControllerDelegate <NSObject>
@required

-(void)showRootLoadingView;
-(void)hideRootLoadingView;
-(void)hideFooterView;
@end

@interface DocumentsProgressViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    NSString *driverID;
    int currentImageCapturing;
    UIImage *recentUploadedImage;
    
    BOOL automaticUploadFinished;
        
//    UIImage *imageUploadedFile;
//    UIImage *imageNotUploadedFile;
    
    NSDictionary *vehicleData;
    NSDictionary *driverData;
    
    BOOL comintFromImagePicker;
}
@property (nonatomic, strong) NSString *comingFrom;
@property (nonatomic, strong) AppDelegate *applicationDelegate;

@property (nonatomic, weak) id <DocumentsProgressViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *driverIDContainer;
@property (weak, nonatomic) IBOutlet UIProgressView *driverIDProgress;
@property (weak, nonatomic) IBOutlet UIButton *driverIDButton;
@property (weak, nonatomic) IBOutlet UIImageView *idImageView;

@property (weak, nonatomic) IBOutlet UIView *drivingLicContainer;
@property (weak, nonatomic) IBOutlet UIProgressView *drivingLicenseProgress;
@property (weak, nonatomic) IBOutlet UIButton *drivingLicenseButton;
@property (weak, nonatomic) IBOutlet UIImageView *drivingLicenseImageView;

@property (weak, nonatomic) IBOutlet UIView *vehicleRegContainer;
@property (weak, nonatomic) IBOutlet UIProgressView *vehicleRegProgress;
@property (weak, nonatomic) IBOutlet UIButton *vehicleRegButton;
@property (weak, nonatomic) IBOutlet UIImageView *vehicleRegImageView;

@property (weak, nonatomic) IBOutlet UIView *insuranceContainer;
@property (weak, nonatomic) IBOutlet UIProgressView *vehicleInsuranceProgress;
@property (weak, nonatomic) IBOutlet UIButton *vehicleInsuranceButton;
@property (weak, nonatomic) IBOutlet UIImageView *insuranceImageView;

@property (weak, nonatomic) IBOutlet UIProgressView *delegationImageProgress;
@property (weak, nonatomic) IBOutlet UIButton *delegationButton;
@property (weak, nonatomic) IBOutlet UIImageView *delegationImageView;

@property (weak, nonatomic) IBOutlet UIView *vehicleImageContainer;
@property (weak, nonatomic) IBOutlet UIProgressView *vehicleImageProgress;
@property (weak, nonatomic) IBOutlet UIButton *vehicleImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *carDoneImageView;

@property (weak, nonatomic) IBOutlet UIView *delegationContainerView;

- (IBAction)addDriverIDImage:(UIButton *)sender;
- (IBAction)addDrivingLicenseImage:(UIButton *)sender;
- (IBAction)addVehicleRegistationImage:(UIButton *)sender;
- (IBAction)addInsuranceImage:(UIButton *)sender;
- (IBAction)addDelegationImage:(UIButton *)sender;
- (IBAction)addVehicleImage:(UIButton *)sender;

@end
