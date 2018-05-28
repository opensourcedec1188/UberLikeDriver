//
//  AccountPaymentViewController.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/20/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "AccountPaymentViewController.h"

@interface AccountPaymentViewController ()

@end

@implementation AccountPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_headerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _headerView.layer.shadowPath = shadowPath.CGPath;
    
    _bankContainerView.layer.borderWidth = 1.0f;
    _bankContainerView.layer.borderColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.06].CGColor;
    _creditCardContainerView.layer.borderWidth = 1.0f;
    _creditCardContainerView.layer.borderColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.06].CGColor;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    driverData = [ServiceManager getDriverDataFromUserDefaults];
    if([driverData objectForKey:@"payoutHolderName"]){
        NSString *cardNumber = [driverData objectForKey:@"payoutIban"];
        if(cardNumber.length > 0){
//            [_addPayoutBtn setTitle:[driverData objectForKey:@"payoutIban"] forState:UIControlStateNormal];
            _addPayoutLabel.text = [driverData objectForKey:@"payoutIban"];
            [_addPayoutBtn setEnabled:NO];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addPayoutBtnAction:(UIButton *)sender {
    AddPayoutViewController *controller = [[AddPayoutViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
