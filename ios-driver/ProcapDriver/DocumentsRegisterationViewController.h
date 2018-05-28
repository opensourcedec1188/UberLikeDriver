//
//  DocumentsRegisterationViewController.h
//  ProcapDriver
//
//  Created by MacBookPro on 3/8/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "ServiceManager.h"
#import "HelperClass.h"
#import "UIHelperClass.h"
#import "ClientSideValidation.h"
#import "WorkExperienceView.h"

@protocol DocumentsRegisterationViewControllerDelegate <NSObject>
@required
-(void)goToDocumentsProgressScreenWithVehicleData:(NSString *)comingFrom;
-(void)showRootLoadingView;
-(void)hideRootLoadingView;

-(void)addSubView:(UIView *)viewToAdd andShow:(BOOL)show andMoveFooter:(BOOL)footer;
-(void)addExperienceView:(UIView *)expView;
@end

@interface DocumentsRegisterationViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, WorkExperienceViewDelegate> {
    
    BOOL datePicketViewShown;
    int currentDatePicker;
    
    int currentImageCapturing;
    
    NSString *insuranceExpiryString;
    NSDate *insuranceExpiryDate;
    NSTimeInterval insuranceExpiryInMiliseconds;
    
    NSString *delegationExpiryString;
    NSDate *delegationExpiryDate;
    NSTimeInterval delegationExpiryInMiliseconds;
    
    NSDate *maxExpiry;
    NSDate *minExpiry;
    
    NSDictionary *driverData;
    
    //TEMP
    UIView *datePickerContainerView;
    UIDatePicker *datePicker;
    UIButton *pickersDoneButton;
    
    BOOL termsConfirmed;
    
    //Constraints Constants
    double insuranceExpConst;
    double delegationExpConst;
    
    //Error View Tag
    int popupViewTag;
    UIView *currentFieldPopup;
    
    WorkExperienceView *experienceView;
    BOOL workedForUber;
    
    
}

@property (nonatomic, strong) AppDelegate *applicationDelegate;
@property (nonatomic, weak) id <DocumentsRegisterationViewControllerDelegate> delegate;

@property (nonatomic, strong) NSDictionary *vehicleData;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *insuranceImageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *insuranceImageCheckmark;

@property (weak, nonatomic) IBOutlet UIView *insuranveImgContainerView;
@property (weak, nonatomic) IBOutlet UILabel *insuranceExpiryLabel;
@property (weak, nonatomic) IBOutlet UIButton *insuranceBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *insuranceLabelTop;
@property (weak, nonatomic) IBOutlet UIView *insuranceSubview;

@property (weak, nonatomic) IBOutlet UIView *delegationView;
@property (weak, nonatomic) IBOutlet UIView *delegationImgContainerView;
@property (weak, nonatomic) IBOutlet UILabel *delegationImageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *delegationImageCheckmark;

@property (weak, nonatomic) IBOutlet UILabel *delegationExpiryDateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *delegationExpiryLabelTop;
@property (weak, nonatomic) IBOutlet UIButton *delegationExpiryBtn;
@property (weak, nonatomic) IBOutlet UIView *delegationExpirySubview;

@property (weak, nonatomic) IBOutlet UIView *carImageContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *carImageCheckmark;
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;



- (IBAction)insuranceImageAction:(UIButton *)sender;
- (IBAction)delegationImageAction:(UIButton *)sender;
- (IBAction)carImageAction:(UIButton *)sender;
- (IBAction)datePickerValueChanged:(UIDatePicker *)sender;

- (IBAction)chooseInsuranceExpiryDateAction:(UIButton *)sender;
- (IBAction)chooseDelegationExpiryAction:(UIButton *)sender;

- (IBAction)donePickerSelectAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *termsButton;
- (IBAction)termsButtonAction:(UIButton *)sender;

-(void)processCompleteVehicleRequest;

@end
