//
//  AddPayoutViewController.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/20/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "AddPayoutViewController.h"

@interface AddPayoutViewController ()

@end

@implementation AddPayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _addBtn.layer.cornerRadius = 3;
    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_headerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _headerView.layer.shadowPath = shadowPath.CGPath;
    
    [_nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_addressTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_cityTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_ibanTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addBtnAction:(UIButton *)sender {
    NSString *cardHolderName = _nameTextField.text;
    NSString *address = _addressTextField.text;
    NSString *city = _cityTextField.text;
    NSString *iban = _ibanTextField.text;
    
    if((cardHolderName.length > 0) && (address.length > 0) && (city.length > 0) && (iban.length > 0)){
        NSDictionary *params = @{
                                 @"holderName" : cardHolderName,
                                 @"address" : address,
                                 @"city" : city,
                                 @"iban" : iban
                                     };
        [self performSelectorInBackground:@selector(addPayoutBG:) withObject:params];
    }
}

-(void)addPayoutBG:(NSDictionary *)params{
    @autoreleasepool {
        [ProfileServiceManager addPayout:params :^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishAddPayout:) withObject:response waitUntilDone:NO];
        }];
    }
}

-(void)finishAddPayout:(NSDictionary *)response{
    NSLog(@"response : %@", response);
    if([[response objectForKey:@"code"] intValue] == 200){
        [ServiceManager getDriverData:[[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"] :^(NSDictionary *response){
            if([response objectForKey:@"data"]){
                NSDictionary *driver = [response objectForKey:@"data"];
                [ServiceManager saveLoggedInDriverData:driver andAccessToken:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

#pragma mark - TextField Delegate
-(void)textFieldDidChange :(UITextField *)textField{
    NSLog( @"text changed: %@", textField.text);
    UILabel *currentLabel;
    NSLayoutConstraint *constraint;
    if(textField == _nameTextField){
        currentLabel = _nameLabel;
        constraint = _nameTop;
    }else if (textField == _addressTextField){
        currentLabel = _addressLabel;
        constraint = _addressTop;
    }else if (textField == _cityTextField){
        currentLabel = _cityLabel;
        constraint = _cityTop;
    }else if (textField == _ibanTextField){
        currentLabel = _ibanLabel;
        constraint = _ibanTop;
    }
    
    
    if(textField.text.length > 0){
        constraint.constant = 7;
        [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             currentLabel.font = [UIFont fontWithName:FONT_ROBOTO_LIGHT size:12];
                             [self.view layoutIfNeeded];
                         }  completion:^(BOOL finished){}];
    }else{
        constraint.constant = 37;
        [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self.view layoutIfNeeded];
                             currentLabel.font = [UIFont fontWithName:FONT_ROBOTO_LIGHT size:16];
                         }  completion:^(BOOL finished){}];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Hide Keyboard when click anywhere
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:TRUE];
}

@end
