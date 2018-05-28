//
//  DocumentsViewController.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/20/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "DocumentsViewController.h"

@interface DocumentsViewController ()

@end

@implementation DocumentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_headerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _headerView.layer.shadowPath = shadowPath.CGPath;
    [self performSelectorInBackground:@selector(getDocumentsBG) withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getDocumentsBG{
    @autoreleasepool {
        [ProfileServiceManager getDriverDocuments:^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishGetDocuments:) withObject:response waitUntilDone:NO];
        }];
    }
}

-(void)finishGetDocuments:(NSDictionary *)response{
    NSLog(@"finishGetDocuments : %@", response);
    if(response){
        if([response objectForKey:@"data"]){
            personalDocuments = [response objectForKey:@"data"];
            [self displayPersonalDocuments];
        }
        
        if([response objectForKey:@"vehicles"]){
            vehicleDocuments = [[response objectForKey:@"vehicles"] objectAtIndex:0];
            [self displayVehicleData];
        }
    }
}

-(void)displayPersonalDocuments{
    if([personalDocuments objectForKey:@"licenseExpiry"])
        _drivingLicenseLabel.text = [personalDocuments objectForKey:@"licenseExpiry"];
    
    if([[personalDocuments objectForKey:@"isLicenseExpired"] intValue] == 1)
        _drivingLicenseStatusLabel.text = @"expired";
    
    if([personalDocuments objectForKey:@"ssnExpiry"])
        _ssnLabel.text = [personalDocuments objectForKey:@"ssnExpiry"];
    
    if([[personalDocuments objectForKey:@"isSsnExpired"] intValue] == 1)
        _ssnStatusLabel.text = @"expired";
}

-(void)displayVehicleData{
    _vehicleTypeLabel.text = [NSString stringWithFormat:@"%@ %@ %@", [vehicleDocuments objectForKey:@"manufacturer"], [vehicleDocuments objectForKey:@"model"], [vehicleDocuments objectForKey:@"year"]];
    
    if([vehicleDocuments objectForKey:@"insuranceExpiry"])
        _insuranceLabel.text = [vehicleDocuments objectForKey:@"insuranceExpiry"];
    
    if([[vehicleDocuments objectForKey:@"isInsuranceExpired"] intValue] == 1)
        _insuranceStatusLabel.text = @"expired";
    
    if([vehicleDocuments objectForKey:@"registrationExpiry"])
        _vehicleRegLabel.text = [vehicleDocuments objectForKey:@"registrationExpiry"];
    
    if([[vehicleDocuments objectForKey:@"isRegistrationExpired"] intValue] == 1)
        _vehicleRegExpiryLabel.text = @"expired";
    
    if([vehicleDocuments objectForKey:@"delegationOrLeaseExpiry"]){
        if([vehicleDocuments objectForKey:@"delegationOrLeaseExpiry"])
            _delegationLabel.text = [vehicleDocuments objectForKey:@"delegationOrLeaseExpiry"];
        
        if([[vehicleDocuments objectForKey:@"isDelegationOrLeaseExpired"] intValue] == 1)
            _delegationStatusLabel.text = @"expired";
    }
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
