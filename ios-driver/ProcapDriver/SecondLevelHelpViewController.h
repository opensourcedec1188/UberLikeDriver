//
//  SecondLevelHelpViewController.h
//  Procap
//
//  Created by Mahmoud Amer on 8/3/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ServiceManager.h"
#import "ProfileServiceManager.h"
#import "HelpTableViewCell.h"
#import "SecondLevelHelpViewController.h"
#import "SubmitHelpRequestViewController.h"
#import "UIHelperClass.h"


@interface SecondLevelHelpViewController : UIViewController <UINavigationControllerDelegate> {
    IBOutlet HelpTableViewCell *defaultCell;
}
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) NSArray *optionArray;
@property (nonatomic, strong) NSString *rideID;
@property (weak, nonatomic) IBOutlet UITableView *helpTableView;

- (IBAction)backBtnAction:(UIButton *)sender;
@end
