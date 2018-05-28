//
//  SettingsViewController.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/20/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ServiceManager.h"
#import "ProfileServiceManager.h"
#import "HelperClass.h"
#import "UIHelperClass.h"

@protocol SettingsViewControllerDelegate <NSObject>

@required
-(void)dismissAfterLogout;
@end

@interface SettingsViewController : UIViewController {
    UIView *loadingView;
    NSDictionary *driverData;
}
@property (nonatomic, weak) id <SettingsViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UISwitch *receiveAllTripsSwitch;
- (IBAction)receiveAllTripsAction:(UISwitch *)sender;


- (IBAction)logoutAction:(UIButton *)sender;



@end
