//
//  GoogleServicesManager.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 9/16/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

#import <GoogleMaps/GMSGeocoder.h>

#import "ServiceManager.h"
#import "RidesServiceManager.h"
#import "HelperClass.h"

#define GMS_SERVICE_KEY @"AIzaSyAYsFg9P4ptXphKnKTPID9zXYZz8D04Axk"
#define GMS_SNAPTOROAD_KEY @"AIzaSyArRSzgJXWdwiPwWw1UxywoXAi0a0hQ_YI"

@interface GoogleServicesManager : NSObject

+(void)getAddressFromCoordinates:(float)latitude andLong:(float)longitude :( void (^)(NSDictionary *))completion;

+(void)getRouteFrom:(CLLocationCoordinate2D)fromLocation to:(CLLocationCoordinate2D)toLocation :( void (^)(NSDictionary *))completion;

+(void)snapCoordinates:(NSMutableArray *)coordinatesArray :( void (^)(NSDictionary *))completion;

@end
