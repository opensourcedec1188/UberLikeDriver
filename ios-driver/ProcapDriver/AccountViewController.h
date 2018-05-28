//
//  OfflineViewController.h
//  ProcapDriver
//
//  Created by MacBookPro on 4/27/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceManager.h"
#import "RidesServiceManager.h"
#import "HelperClass.h"
#import "UIImageView+AFNetworking.h"

@protocol AccountViewControllerDelegate <NSObject>
@required
-(void)GoToDocuments;
-(void)goToSettings;
-(void)goToAccountInfo;
-(void)goToRating;
-(void)goToPayment;
-(void)goHelp;
@end

@interface AccountViewController : UIViewController {
    UIView *loadingView;
    NSDictionary *driverData;
}
@property (nonatomic, weak) id <AccountViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *driverImageContainer;
@property (weak, nonatomic) IBOutlet UIImageView *driverImageView;
@property (weak, nonatomic) IBOutlet UIView *vehicleImageContainer;
@property (weak, nonatomic) IBOutlet UIImageView *vehicleImageView;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
- (IBAction)editBtnAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *driverNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverRateLabel;

- (IBAction)accountInfoAction:(UIButton *)sender;
- (IBAction)ratingAction:(UIButton *)sender;
- (IBAction)documentsAction:(UIButton *)sender;
- (IBAction)paymentsAction:(UIButton *)sender;
- (IBAction)helpAction:(UIButton *)sender;
- (IBAction)settingsAction:(UIButton *)sender;


@end
