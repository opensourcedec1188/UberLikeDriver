//
//  OfflineViewController.m
//  ProcapDriver
//
//  Created by MacBookPro on 4/27/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    driverData = [ServiceManager getDriverDataFromUserDefaults];
    
    _editBtn.layer.cornerRadius = _editBtn.frame.size.height/2;
    _editBtn.layer.borderWidth = 1.0f;
    _editBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"driverImageData"])
        [_driverImageView setImage:[UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"driverImageData"]]];
    else{
        NSString *driverPhotoURL = [driverData objectForKey:@"photoUrl"];
        [_driverImageView setImageWithURL:[NSURL URLWithString:driverPhotoURL] placeholderImage:[UIImage imageNamed:@"driver_placeholder.png"]];
    }
    
    _driverImageContainer.layer.cornerRadius = _driverImageContainer.frame.size.height/2;
    _driverImageView.layer.cornerRadius = _driverImageView.frame.size.height/2;
    _driverImageView.layer.borderWidth = 1.0f;
    _driverImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"vehicleImageData"])
        [_vehicleImageView setImage:[UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"vehicleImageData"]]];
    else{
        NSString *vehiclePhotoURL = [driverData objectForKey:@"currentVehiclePhotoUrl"];
        [_vehicleImageView setImageWithURL:[NSURL URLWithString:vehiclePhotoURL] placeholderImage:[UIImage imageNamed:@"driver_placeholder.png"]];
    }
    
    _vehicleImageContainer.layer.cornerRadius = _vehicleImageContainer.frame.size.height/2;
    _vehicleImageView.layer.cornerRadius = _vehicleImageView.frame.size.height/2;
    _vehicleImageView.layer.borderWidth = 1.0f;
    _vehicleImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _driverNameLabel.text = [NSString stringWithFormat:@"%@ %@", [driverData objectForKey:@"firstName"], [driverData objectForKey:@"lastName"]];
    _driverRateLabel.text = [NSString stringWithFormat:@"%.2f", [[driverData objectForKey:@"ratingsAvg"] floatValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)editBtnAction:(UIButton *)sender {
}

- (IBAction)accountInfoAction:(UIButton *)sender {
    [self.delegate goToAccountInfo];
}

- (IBAction)ratingAction:(UIButton *)sender {
    [self.delegate goToRating];
}

- (IBAction)documentsAction:(UIButton *)sender {
    [self.delegate GoToDocuments];
}

- (IBAction)paymentsAction:(UIButton *)sender {
    [self.delegate goToPayment];
}

- (IBAction)helpAction:(UIButton *)sender {
    [self.delegate goHelp];
}

- (IBAction)settingsAction:(UIButton *)sender {
    [self.delegate goToSettings];
}
@end
