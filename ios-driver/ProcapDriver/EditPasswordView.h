//
//  EditPasswordView.h
//  Procap
//
//  Created by Mahmoud Amer on 7/31/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProfileServiceManager.h"
#import "HelperClass.h"

@protocol EditPasswordViewDelegate <NSObject>

@required
-(void)closePasswordView;
@end

@interface EditPasswordView : UIView <UITextFieldDelegate> {
    UIView *loadingView;
}
@property (nonatomic, weak) id <EditPasswordViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *CONTENTVIEW;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIView *oldPasswordSubView;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTF;
@property (weak, nonatomic) IBOutlet UILabel *oldPasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *showOldPassBtn;
- (IBAction)showOldPassBtnAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *updatePassSubview;
@property (weak, nonatomic) IBOutlet UITextField *updatedPassTF;
@property (weak, nonatomic) IBOutlet UILabel *updatedPassLabel;
@property (weak, nonatomic) IBOutlet UIButton *showUpdatedPassBtn;
- (IBAction)showUpdatedPassBtnAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *ConfirmSubview;
@property (weak, nonatomic) IBOutlet UITextField *confirmNewPasswordTF;
@property (weak, nonatomic) IBOutlet UILabel *confirmNewPassLabel;
@property (weak, nonatomic) IBOutlet UIButton *showConfirmPassBtn;
- (IBAction)showConfirmPassBtnAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

- (IBAction)updateAction:(UIButton *)sender;

- (IBAction)dismissAction:(UIButton *)sender;

@end
