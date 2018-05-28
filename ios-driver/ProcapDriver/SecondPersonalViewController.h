//
//  SecondPersonalViewController.h
//  ProcapDriver
//
//  Created by MacBookPro on 3/26/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"
#import "ServiceManager.h"
#import "HelperClass.h"
#import "ClientSideValidation.h"
#import "UIHelperClass.h"

@protocol SecondPersonalViewControllerDelegate <NSObject>
@required
-(void)goToVehicleRegisteration;
//-(void)backToPersonalInfo;
-(void)showRootLoadingView;
-(void)hideRootLoadingView;
-(void)moveViewForTextFields:(float)newY andShow:(BOOL)show;
-(void)moveViewForSearch:(float)newY andShow:(BOOL)show;

-(void)addSubView:(UIView *)viewToAdd andShow:(BOOL)show andMoveFooter:(BOOL)footer;
@end


@interface SecondPersonalViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UISearchBarDelegate> {
    
    
    BOOL datePicketViewShown;
    BOOL tableContainerShown;
    int currentChoosingTable;
    
    NSString *selectedDrivingLicenseExpiryDate;
    NSDate *drivingLicenseExpiryDate;
    NSTimeInterval selectedDrivingLicenseExpiryInMiliseconds;
    
    NSArray *districtsArray;
    NSArray *nationalitiesArray;
    
    NSString *selectedDistrictCode;
    NSString *selectedNationalityCode;
    
    
    NSDate *maxDLExpiry;
    NSDate *minDLExpiry;
    
    UIVisualEffectView *blurEffectView;
    
    UIView *datePickerContainerView;
    UIDatePicker *datePicker;
    UIButton *pickersDoneButton;
    
    UIView *tableContainerView;
    UITableView *dataTableView;
    UIButton *tableDoneButton;
    
    //Error View Tag
    int popupViewTag;
    UIView *currentFieldPopup;
    
    BOOL searching;
    BOOL viewSearching;
    NSMutableArray *currentSearchingArray;
    
    //Constraints Constants
    double streetConst;
    double referralCodeConst;
    double districtConst;
    double nationalityConst;
    double drivingLicExpiryConst;
    
    BOOL hearingImpaired;
    BOOL mobilityImpaired;
}

@property (nonatomic, strong) AppDelegate *applicationDelegate;

@property (nonatomic, strong) UISearchBar *tablesSearchBar;

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *otpCode;
@property (nonatomic, strong) NSDictionary *firstPersonalInfo;


@property (nonatomic, weak) id <SecondPersonalViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UILabel *drivingLicenseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *drivingLicenseCheckmark;

@property (weak, nonatomic) IBOutlet UILabel *drivingLicenseExpiryLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *drivingLicenseTop;
@property (weak, nonatomic) IBOutlet UIButton *drivingLicExpiryBtn;
@property (weak, nonatomic) IBOutlet UIView *drivingLicExpirySubview;

@property (weak, nonatomic) IBOutlet UILabel *districtLabel;
@property (weak, nonatomic) IBOutlet UIButton *districtBtn;
@property (weak, nonatomic) IBOutlet UIView *districtSubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *districtTop;

@property (weak, nonatomic) IBOutlet UITextField *streetTF;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UIView *streetSubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *streetTop;

@property (weak, nonatomic) IBOutlet UILabel *nationalityLabel;
@property (weak, nonatomic) IBOutlet UIView *nationalitySubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nationalityTop;
@property (weak, nonatomic) IBOutlet UIButton *nationalityBtn;

@property (weak, nonatomic) IBOutlet UITextField *referralCodeTF;
@property (weak, nonatomic) IBOutlet UILabel *referralCodeLabel;
@property (weak, nonatomic) IBOutlet UIView *referralCodeSubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *referralTop;

@property (weak, nonatomic) IBOutlet UIButton *hearImpBtn;
- (IBAction)hearImpBtnAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *impBtn;
- (IBAction)impBtnAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *drivingLicImageContainerView;

-(void)processCompletePersonalInfoRequest;
- (IBAction)addDrivingLicenseImageAction:(UIButton *)sender;
- (IBAction)chooseDrivingLicenseExpiryDate:(UIButton *)sender;
- (IBAction)chooseDistrictAction:(UIButton *)sender;
- (IBAction)chooseNationalityAction:(UIButton *)sender;

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender;
- (IBAction)DonePickerAction:(UIButton *)sender;
- (IBAction)doneTableAction:(UIButton *)sender;

@end
