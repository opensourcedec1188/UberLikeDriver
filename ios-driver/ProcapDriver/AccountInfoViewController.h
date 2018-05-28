//
//  AccountInfoViewController.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/20/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ServiceManager.h"
#import "EditPasswordView.h"
#import "UIHelperClass.h"

@interface AccountInfoViewController : UIViewController <EditPasswordViewDelegate> {
    NSDictionary *driverData;
    
}
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (strong, nonatomic) EditPasswordView *editPassword;

- (IBAction)editPasswordAction:(UIButton *)sender;

@end
