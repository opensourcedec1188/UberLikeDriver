//
//  AccountPaymentViewController.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/20/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ServiceManager.h"
#import "AddPayoutViewController.h"
#import "UIHelperClass.h"

@interface AccountPaymentViewController : UIViewController {
    NSDictionary *driverData;
}

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIView *bankContainerView;
@property (weak, nonatomic) IBOutlet UIView *creditCardContainerView;

@property (weak, nonatomic) IBOutlet UIButton *addPayoutBtn;
@property (weak, nonatomic) IBOutlet UILabel *addPayoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *addCreditCardLabel;
- (IBAction)addPayoutBtnAction:(UIButton *)sender;


@end
