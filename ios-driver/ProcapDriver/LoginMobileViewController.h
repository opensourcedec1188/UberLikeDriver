//
//  LoginMobileViewController.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/21/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceManager.h"
#import "HelperClass.h"
#import "AppDelegate.h"
#import "Keychain.h"
#import "LoginPasswordViewController.h"
#import "RegisterationRootViewController.h"

@interface LoginMobileViewController : UIViewController {
    UIView *loadingView;
    NSString *mobileNumberEnglish;
}
@property (nonatomic, strong) AppDelegate *applicationDelegate;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UIView *mobileSubview;

@end
