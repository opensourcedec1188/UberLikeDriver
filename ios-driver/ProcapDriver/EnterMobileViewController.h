//
//  EnterMobileViewController.h
//  ProcapDriver
//
//  Created by MacBookPro on 3/8/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceManager.h"
#import "HelperClass.h"

@protocol EnterMobileViewControllerDelegate <NSObject>
@required
-(void)moveToConfirmController:(NSDictionary *)parameters;
-(void)showRootLoadingView;
-(void)hideRootLoadingView;
-(void)moveFooterView:(float)newY;
@end

@interface EnterMobileViewController : UIViewController {
    CGFloat currentKeyboardHeight;
    BOOL termsConfirmed;
    NSString *mobileNumberEnglish;
    
    NSDictionary *requestParameters;
}
@property (weak, nonatomic) IBOutlet UILabel *dialCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *byContinueLabel;

@property (nonatomic, weak) id<EnterMobileViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIButton *termsButton;
- (IBAction)termsButtonAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *rulesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rulesLabel;

- (void)goToConfirm;

-(void)processPhoneRequest;

@end
