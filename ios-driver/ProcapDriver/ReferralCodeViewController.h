//
//  ReferralCodeViewController.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/21/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceManager.h"

@interface ReferralCodeViewController : UIViewController {
    NSString *referralCode;
}

@property (weak, nonatomic) IBOutlet UIView *heaederView;

@property (weak, nonatomic) IBOutlet UILabel *referralCodeLabel;


@end
