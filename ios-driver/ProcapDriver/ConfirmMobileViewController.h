//
//  ConfirmMobileViewController.h
//  ProcapDriver
//
//  Created by MacBookPro on 3/8/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomTextField.h"

#import "ServiceManager.h"
#import "HelperClass.h"


@protocol ConfirmMobileViewControllerDelegate <NSObject>
@required
-(void)moveToRegisterController:(NSString *)phoneNumber andOTPCode:(NSString *)otpCode;
-(void)showRootLoadingView;
-(void)hideRootLoadingView;
-(void)moveFooterView:(float)newY;
@end

@interface ConfirmMobileViewController : UIViewController <CustomTextFieldDelegate, UITextInputDelegate, UITextFieldDelegate> {
    NSString *userInsertedCode;
    NSTimer *timer;
}
@property NSUInteger counter;

@property (nonatomic, weak) id<ConfirmMobileViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDictionary *requestParameters;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (weak, nonatomic) IBOutlet CustomTextField *firstDigitTF;
@property (weak, nonatomic) IBOutlet CustomTextField *secondDigitTF;
@property (weak, nonatomic) IBOutlet CustomTextField *thirdDigitTF;
@property (weak, nonatomic) IBOutlet CustomTextField *forthDigitTF;

@property (weak, nonatomic) IBOutlet UILabel *rulesLabel;

@property (weak, nonatomic) IBOutlet UIButton *resendOTPButton;

- (IBAction)resendOtpCpde:(UIButton *)sender;

@end
