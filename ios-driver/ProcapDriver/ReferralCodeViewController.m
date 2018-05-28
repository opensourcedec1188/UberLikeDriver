//
//  ReferralCodeViewController.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/21/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "ReferralCodeViewController.h"
#import "ServiceManager.h"

@interface ReferralCodeViewController ()

@end

@implementation ReferralCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    referralCode = [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"referralCode"];
    _referralCodeLabel.text = referralCode;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareBtnAction:(UIButton *)sender {
    NSString *shareText = [NSString stringWithFormat:@"Join EGO as a Captin using this code %@", referralCode];
    NSArray *itemsToShare = @[shareText];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:itemsToShare applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
