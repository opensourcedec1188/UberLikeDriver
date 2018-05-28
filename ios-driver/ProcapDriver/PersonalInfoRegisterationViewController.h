//
//  PersonalInfoRegisterationViewController.h
//  ProcapDriver
//
//  Created by MacBookPro on 3/8/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"
#import "ServiceManager.h"
#import "HelperClass.h"
#import "ClientSideValidation.h"
#import "UIHelperClass.h"

@protocol PersonalInfoRegisterationViewControllerDelegate <NSObject>
@required
-(void)goToGeneralInfoRegisteration:(NSDictionary *)firstInfo andPhone:(NSString *)phone andOTP:(NSString *)otpCode;
-(void)showRootLoadingView;
-(void)hideRootLoadingView;
-(void)moveViewForTextFields:(float)newY andShow:(BOOL)show;

-(void)addSubView:(UIView *)viewToAdd andShow:(BOOL)show andMoveFooter:(BOOL)footer;
@end

@interface PersonalInfoRegisterationViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    NSString *ssnExpiry;
    NSTimeInterval ssnExpiryInMiliseconds;
    NSString *birthdate;
    NSTimeInterval birthdateInMiliseconds;
    
    BOOL datePicketViewShown;
    int currentDatePicker;
        
    NSDate *maxBirthdate;
    NSDate *minBirthdate;
    NSDate *maxExpiry;
    NSDate *minExpiry;

    UIView *datePickerContainerView;
    UIDatePicker *datePicker;
    UIButton *pickersDoneButton;
    
    //Error View Tag
    int popupViewTag;
    UIView *currentFieldPopup;
    
    //Constraints Constants
    double fnameConst;
    double lnameConst;
    double emailConst;
    double birthdateConst;
    double idNumConst;
    double idExpiryConst;
    double passConst;
    double confirmPassConst;
}
@property (nonatomic, strong) AppDelegate *applicationDelegate;

@property (nonatomic, weak) id <PersonalInfoRegisterationViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *otpCode;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UITextField *fNameTF;
@property (weak, nonatomic) IBOutlet UILabel *fNameLabel;
@property (weak, nonatomic) IBOutlet UIView *fNameSubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fNameTop;

@property (weak, nonatomic) IBOutlet UITextField *lNameTF;
@property (weak, nonatomic) IBOutlet UILabel *lNameLabel;
@property (weak, nonatomic) IBOutlet UIView *lNameSubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lnameTop;

@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIView *emailSubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailTop;

@property (weak, nonatomic) IBOutlet UITextField *passTF;
@property (weak, nonatomic) IBOutlet UILabel *passLabel;
@property (weak, nonatomic) IBOutlet UIView *passSubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passTop;

@property (weak, nonatomic) IBOutlet UITextField *confirmPassTF;
@property (weak, nonatomic) IBOutlet UILabel *confirmPassLabel;
@property (weak, nonatomic) IBOutlet UIView *confirmPassSubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmPassTop;

@property (weak, nonatomic) IBOutlet UILabel *birthdateLabel;
@property (weak, nonatomic) IBOutlet UIButton *birthdateButton;
@property (weak, nonatomic) IBOutlet UIView *birthdateSubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *birthdateTop;

@property (weak, nonatomic) IBOutlet UILabel *idImageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *idImageCheckmark;
@property (weak, nonatomic) IBOutlet UIButton *idAddImageButton;

@property (weak, nonatomic) IBOutlet UIButton *idExpiryButton;
@property (weak, nonatomic) IBOutlet UILabel *idExpiryLabel;
@property (weak, nonatomic) IBOutlet UIView *idExpirySubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idExpiryTop;

@property (weak, nonatomic) IBOutlet UITextField *idNumberTF;
@property (weak, nonatomic) IBOutlet UILabel *idNumLabel;
@property (weak, nonatomic) IBOutlet UIView *idNumSubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idNumTop;


- (IBAction)showHideBirthdateAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *idImageContainerView;

- (IBAction)idAddImageAction:(UIButton *)sender;
- (IBAction)showHideIDExpiryDateAction:(UIButton *)sender;

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender;
- (IBAction)donePickerAction:(UIButton *)sender;

-(void)processPersonalInfoValidationRequest;

@end
