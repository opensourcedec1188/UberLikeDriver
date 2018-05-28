//
//  SplashViewController.h
//  ProcapDriver
//
//  Created by MacBookPro on 4/19/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceManager.h"
#import "ProfileServiceManager.h"
#import "HelperClass.h"
#import "UIImage+animatedGIF.h"
#import "OnRideViewController.h"
#import "PaymentViewController.h"
#import "TabBarRootViewController.h"

@interface SplashViewController : UIViewController {
    NSDictionary *currentRideData;
}

@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;


@end
