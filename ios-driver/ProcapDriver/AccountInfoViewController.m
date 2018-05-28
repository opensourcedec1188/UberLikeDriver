//
//  AccountInfoViewController.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/20/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "AccountInfoViewController.h"

@interface AccountInfoViewController ()

@end

@implementation AccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    driverData = [ServiceManager getDriverDataFromUserDefaults];
    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_headerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _headerView.layer.shadowPath = shadowPath.CGPath;
    
    _firstNameLabel.text = [driverData objectForKey:@"firstName"];
    _secondNameLabel.text = [driverData objectForKey:@"lastName"];
    _emailLabel.text = [driverData objectForKey:@"email"];
    _phoneNumberLabel.text = [driverData objectForKey:@"phone"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editPasswordAction:(UIButton *)sender {
    [_editPassword removeFromSuperview];
    _editPassword = [[EditPasswordView alloc] initWithFrame:self.view.bounds];
    _editPassword.mainView.frame = CGRectMake(0, _editPassword.frame.size.height, _editPassword.mainView.frame.size.width, _editPassword.mainView.frame.size.height);
    _editPassword.delegate = self;
    _editPassword.bgView.alpha = 0.0f;
    [self.view addSubview:_editPassword];
    [UIView animateWithDuration:0.3f
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         _editPassword.bgView.alpha = 1.0f;
                         _editPassword.mainView.frame = CGRectMake(0, _editPassword.frame.size.height - _editPassword.mainView.frame.size.height, _editPassword.mainView.frame.size.width, _editPassword.mainView.frame.size.height);
                         [_editPassword.oldPasswordTF becomeFirstResponder];
                     } completion:^(BOOL finished){}];
}

-(void)closePasswordView{
    [UIView animateWithDuration:0.4f
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         _editPassword.alpha = 0.0;
                         _editPassword.mainView.frame = CGRectMake(0, _editPassword.frame.size.height, _editPassword.mainView.frame.size.width, _editPassword.mainView.frame.size.height);
                     } completion:^(BOOL finished){
                         _editPassword.alpha = 1.0;
                         [_editPassword removeFromSuperview];
                     }];
}

@end
