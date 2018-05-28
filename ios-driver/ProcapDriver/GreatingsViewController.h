//
//  GreatingsViewController.h
//  ProcapDriver
//
//  Created by MacBookPro on 4/2/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceManager.h"

@interface GreatingsViewController : UIViewController {
    
}

@property (nonatomic, strong) NSString *comingFrom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *congratsLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneLastStepLabelTopConstraint;

- (IBAction)openMapAction:(UIButton *)sender;
- (IBAction)logoutAction:(UIButton *)sender;
@end
