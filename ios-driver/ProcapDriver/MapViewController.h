//
//  MapViewController.h
//  ProcapDriver
//
//  Created by MacBookPro on 4/25/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GMSGeocoder.h>
#import <CoreLocation/CoreLocation.h>

#import "ServiceManager.h"
#import "HelperClass.h"


@interface MapViewController : UIViewController <GMSMapViewDelegate> {
    
    UIView *loadingView;
}

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) GMSPlacesClient *placesClient;

@end
