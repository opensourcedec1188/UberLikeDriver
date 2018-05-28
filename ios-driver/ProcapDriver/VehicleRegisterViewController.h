//
//  VehicleRegisterViewController.h
//  ProcapDriver
//
//  Created by MacBookPro on 3/8/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "ServiceManager.h"
#import "HelperClass.h"
#import "ClientSideValidation.h"
#import "UIHelperClass.h"

@protocol VehicleRegisterViewControllerDelegate <NSObject>
@required
-(void)goToDocumentsScreen:(NSString *)isOwner andVehicleData:(NSDictionary *)vehicleData;
-(void)showRootLoadingView;
-(void)hideRootLoadingView;
-(void)moveViewForSearch:(float)newY andShow:(BOOL)show;

-(void)addSubView:(UIView *)viewToAdd andShow:(BOOL)show andMoveFooter:(BOOL)footer;
@end

@interface VehicleRegisterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UISearchBarDelegate> {
    
    BOOL datePicketViewShown;
    BOOL tableContainerShown;
    
    int currentChoosingTable;
    
    NSArray *manufacturersArray;
    NSArray *modelsArray;
    NSArray *yearsArray;
    
    NSString *selectedManufacturerString;
    NSString *selectedManufacturerCode;
    
    NSString *selectedYear;
    
    NSString *selectedModelCode;
    NSString *selectedModelString;
    
    NSString *selectedvehicleRegExpireDateString;
    NSDate *selectedvehicleRegExpireDate;
    NSTimeInterval selectedvehicleRegExpireDateInMiliseconds;
    
    NSDate *maxVehicleExpiry;
    NSDate *minVehicleExpiry;
    
    UIVisualEffectView *blurEffectView;
    
    NSString *isOwner;
    UIColor *activeColor;
    UIColor *inActiveColor;
    
    BOOL ownerSelected;
    NSString *plateLettersText;
    NSString *plateLettersTextSeparated;
    
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
    double manConst;
    double modelConst;
    double yearConst;
    double plateNumConst;
    double plateLettersConst;
    double vehicleRegConst;
    double vehicleExpireConst;
}

@property (nonatomic, strong) AppDelegate *applicationDelegate;

@property (nonatomic, strong) UISearchBar *tablesSearchBar;

@property (nonatomic, weak) id <VehicleRegisterViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UILabel *manufacturerLabel;
@property (weak, nonatomic) IBOutlet UIView *manSubview;
@property (weak, nonatomic) IBOutlet UIButton *manufacturerBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manTop;

@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UIButton *modelBtn;
@property (weak, nonatomic) IBOutlet UIView *modelSubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *modelTop;

@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UIButton *yearBtn;
@property (weak, nonatomic) IBOutlet UIView *yearSubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yearTop;

@property (weak, nonatomic) IBOutlet UITextField *plateNumberTF;
@property (weak, nonatomic) IBOutlet UILabel *plateNumLabel;
@property (weak, nonatomic) IBOutlet UIView *plateNumbersSubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plateNumbersTop;

@property (weak, nonatomic) IBOutlet UITextField *plateLettersTF;
@property (weak, nonatomic) IBOutlet UILabel *plateLettersLabel;
@property (weak, nonatomic) IBOutlet UIView *plateLettersSubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plateLettersTop;

@property (weak, nonatomic) IBOutlet UITextField *vehicleRegNumberTF;
@property (weak, nonatomic) IBOutlet UILabel *vehicleRegLabel;
@property (weak, nonatomic) IBOutlet UIView *vehicleRegSubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vehicleRegTop;

@property (weak, nonatomic) IBOutlet UILabel *vehicleRegExpireDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *vehicleRegExpireDateBtn;
@property (weak, nonatomic) IBOutlet UIView *vehicleRegExpireSubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vehicleRegExpireTop;

@property (weak, nonatomic) IBOutlet UIView *vehicleRegImgContainerView;
@property (weak, nonatomic) IBOutlet UILabel *vehicleRegImageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vehicleRegCheckmark;

@property (weak, nonatomic) IBOutlet UILabel *ownerNotOwnerLabel;

- (IBAction)chooseManufacturerButtonAction:(UIButton *)sender;
- (IBAction)chooseModelButtonAction:(UIButton *)sender;
- (IBAction)chooseYearButtonAction:(UIButton *)sender;
- (IBAction)chooseVehicleRegImgAction:(UIButton *)sender;
- (IBAction)chooseVehicleRegExpiryDate:(UIButton *)sender;

- (IBAction)ownerSegmentValueChanged:(UISegmentedControl *)sender;

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender;

- (IBAction)doneTableSelectAction:(UIButton *)sender;
- (IBAction)donePickerSelectAction:(UIButton *)sender;

-(void)processVehicleInfoValidationRequest;

@end
