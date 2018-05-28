//
//  AddPayoutViewController.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/20/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ServiceManager.h"
#import "ProfileServiceManager.h"
#import "HelperClass.h"
#import "UIHelperClass.h"

@interface AddPayoutViewController : UIViewController {
    
}
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTop;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressTop;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityTop;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;

@property (weak, nonatomic) IBOutlet UILabel *ibanLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibanTop;
@property (weak, nonatomic) IBOutlet UITextField *ibanTextField;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addBtnAction:(UIButton *)sender;

@end
