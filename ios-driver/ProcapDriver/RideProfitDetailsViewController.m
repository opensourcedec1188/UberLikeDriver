//
//  RideProfitDetailsViewController.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/19/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "RideProfitDetailsViewController.h"

@interface RideProfitDetailsViewController ()

@end

@implementation RideProfitDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelectorInBackground:@selector(getRideDetailsBG) withObject:nil];

    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_headerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _headerView.layer.shadowPath = shadowPath.CGPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getRideDetailsBG{
    @autoreleasepool {
        [EarningsServiceManager getRideProfit:_RideID :^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishGetRide:) withObject:response waitUntilDone:NO];
        }];
    }
}

-(void)finishGetRide:(NSDictionary *)response{
    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.frame.size.width, 760);
    NSLog(@"response : %@", response);
    if(response){
        if([response objectForKey:@"data"]){
            rideDetails = [response objectForKey:@"data"];
            
            _timeDateLabel.text = [NSString stringWithFormat:@"%@ - %@", [rideDetails objectForKey:@"time"], [rideDetails objectForKey:@"category"]];
            
            _durationLabel.text = [NSString stringWithFormat:@"%@ : %@", [[rideDetails objectForKey:@"duration"] objectForKey:@"hours"], [[rideDetails objectForKey:@"duration"] objectForKey:@"minutes"]];
            
            _distanceLabel.text = [NSString stringWithFormat:@"%@ KM", [[rideDetails objectForKey:@"distance"] stringValue]];
            
            _pickupLabel.text = [rideDetails objectForKey:@"startAddress"];
            _dropOffLabel.text = [rideDetails objectForKey:@"endAddress"];
            
            _smallProfitLabel.text = [[rideDetails objectForKey:@"profit"] stringValue];
            _fareLabel.text = [[rideDetails objectForKey:@"fare"] stringValue];
            _walletLabel.text = [[rideDetails objectForKey:@"discount"] stringValue];
            _collectedCashLabel.text = [[rideDetails objectForKey:@"cashCollected"] stringValue];
            _outstandingLabels.text = [[rideDetails objectForKey:@"outstandingBalance"] stringValue];
            _settlmentLabel.text = [[rideDetails objectForKey:@"settlement"] stringValue];
            
            [_tripImageView setImageWithURL:[NSURL URLWithString:[rideDetails objectForKey:@"mapPhotoUrl"]] placeholderImage:nil];
        }
    }
}


- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
