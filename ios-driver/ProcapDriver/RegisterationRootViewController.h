//
//  RegisterationRootViewController.h
//  ProcapDriver
//
//  Created by MacBookPro on 3/8/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ConfirmMobileViewController.h"
#import "PersonalInfoRegisterationViewController.h"
#import "SecondPersonalViewController.h"
#import "VehicleRegisterViewController.h"
#import "DocumentsRegisterationViewController.h"
#import "DocumentsProgressViewController.h"
#import "UIHelperClass.h"


static int CONFIRM_MOBILE_INDEX = 0;
static int FIRST_PERSONAL_INDEX = 1;
static int SECOND_PERSONAL_INDEX = 2;
static int FIRST_VEHICLE_INDEX = 3;
static int SECOND_VEHICLE_INDEX = 4;
static int DOCS_PROGRESS_INDEX = 5;

@interface RegisterationRootViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, ConfirmMobileViewControllerDelegate, PersonalInfoRegisterationViewControllerDelegate, SecondPersonalViewControllerDelegate, VehicleRegisterViewControllerDelegate, DocumentsRegisterationViewControllerDelegate, DocumentsProgressViewControllerDelegate>
{
    NSArray *myViewControllers;
    NSUInteger pageIndex;
    
    ConfirmMobileViewController *confirmMobile;
    PersonalInfoRegisterationViewController *personalInfoController;
    SecondPersonalViewController *secondPersonalInfoController;
    VehicleRegisterViewController *vehicleInfoController;
    DocumentsRegisterationViewController *documentsController;
    DocumentsProgressViewController *documentsProgressController;
    
    CGFloat originalFooterViewY;
            
    int currentPageIndex;
    
    NSString *currentUploadStatus;
    
    //Testing
    UIView *selectionView;
    UIView *loadingView;
    
    float containerOriginY;
    CGRect originalSelectionViewFrame;
}
@property (nonatomic, strong) NSDictionary *requestParameters;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSString *currentUploadStatus;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewConstraint;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *footerSubmitBtn;

@property (strong, nonatomic) UIPageViewController *pageViewController;


- (IBAction)childControllerNextActions:(UIButton *)sender;
- (IBAction)backAction:(UIButton *)sender;

@end
