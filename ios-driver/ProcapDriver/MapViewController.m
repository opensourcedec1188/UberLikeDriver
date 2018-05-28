//
//  MapViewController.m
//  ProcapDriver
//
//  Created by MacBookPro on 4/25/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"

@interface MapViewController ()
@property (nonatomic, strong) AppDelegate *applicationDelegate;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _applicationDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    GMSCameraPosition *mapCamera = [GMSCameraPosition cameraWithLatitude:_applicationDelegate.currentLocation.coordinate.latitude
                                                               longitude:_applicationDelegate.currentLocation.coordinate.longitude
                                                                    zoom:13];
    _mapView.myLocationEnabled = YES;
    _mapView.settings.myLocationButton = YES;
    _mapView.settings.consumesGesturesInView = NO;
    _mapView.delegate = self;
    
    [_mapView setCamera:mapCamera];
    
    //Map Style
    GMSMapStyle *style = [RidesServiceManager setMapStyleFromFileName:@"style"];
    if(style)
        [_mapView setMapStyle:style];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
