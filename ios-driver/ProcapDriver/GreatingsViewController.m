//
//  GreatingsViewController.m
//  ProcapDriver
//
//  Created by MacBookPro on 4/2/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "GreatingsViewController.h"

@interface GreatingsViewController ()

@end

@implementation GreatingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.congratsLabelTopConstraint.constant = 93;
    self.oneLastStepLabelTopConstraint.constant = 140;
    [UIView animateWithDuration:1.4f animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){}];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)openMapAction:(UIButton *)sender {
    UIAlertController * alert=[UIAlertController
                               
                               alertControllerWithTitle:NSLocalizedString(@"choose_map_title", @"") message:@""preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camBtn = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"choose_map_apple", @"")
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self openMap:1];
                             }];
    UIAlertAction *libraryBtn = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"choose_map_google", @"")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self openMap:2];
                                     
                                 }];
    UIAlertAction *cancelBtn = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Chose_camera_source_cancel", @"")
                                style:UIAlertActionStyleDefault
                                handler:nil];
    
    [alert addAction:camBtn];
    [alert addAction:libraryBtn];
    [alert addAction:cancelBtn];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)logoutAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"greetingsLogoutSegue" sender:self];
}

-(void)openMap:(int)map{
    if(map == 1){
        NSURL *url = [NSURL URLWithString:@"http://maps.apple.com/?ll=24.798330,46.782318&z=14&z=15&q=exit+9+services"];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }else{
        if ([[UIApplication sharedApplication] canOpenURL:
             [NSURL URLWithString:@"comgooglemaps://"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"comgooglemaps://?q=24.798330,46.782318&center=24.798330,46.782318&zoom=14&views=traffic"] options:@{} completionHandler:nil];
        } else {
            NSLog(@"Can't use comgooglemaps://");
        }
    }
}

@end
