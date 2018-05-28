//
//  DocumentsViewController.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/20/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ServiceManager.h"
#import "ProfileServiceManager.h"
#import "UIHelperClass.h"


@interface DocumentsViewController : UIViewController {
    NSDictionary *personalDocuments;
    NSDictionary *vehicleDocuments;
}

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *drivingLicenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *drivingLicenseStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *ssnLabel;
@property (weak, nonatomic) IBOutlet UILabel *ssnStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *vehicleTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *vehicleRegLabel;
@property (weak, nonatomic) IBOutlet UILabel *vehicleRegExpiryLabel;

@property (weak, nonatomic) IBOutlet UILabel *insuranceLabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *delegationLabel;
@property (weak, nonatomic) IBOutlet UILabel *delegationStatusLabel;

@end
