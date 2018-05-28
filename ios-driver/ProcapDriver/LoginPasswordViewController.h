//
//  LoginPasswordViewController.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/21/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ServiceManager.h"
#import "HelperClass.h"

@interface LoginPasswordViewController : UIViewController {
    UIView *loadingView;
}

@property (strong, nonatomic) NSString *mobileNumber;


@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTop;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UIView *passwordSubView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;


- (IBAction)goBtnAction:(UIButton *)sender;
- (IBAction)backBtnAction:(UIButton *)sender;
@end
