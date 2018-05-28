//
//  RidesServiceManager.h
//  ProcapDriver
//
//  Created by MacBookPro on 4/25/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

#import "ServiceManager.h"
#import "HelperClass.h"

/* Ride Status */
#define RIDE_STATUS_INITIATED @"initiated"
#define RIDE_STATUS_ACCEPTED @"accepted"
#define RIDE_STATUS_NEARBY @"nearby"
#define RIDE_STATUS_ARRIVED @"arrived"
#define RIDE_STATUS_STARTED @"on-ride"
#define RIDE_STATUS_ENDED @"clearance"
#define RIDE_STATUS_FINISHED @"finished"

#define RIYADH_LATITUDE ((float)24.740273)
#define RIYADH_LONGITUDE ((float)46.700025)

#define RIYADH_NE_CORNER_LATITUDE ((float)25.505344)
#define RIYADH_NE_CORNER_LONGITUDE ((float)47.319077)

#define RIYADH_SW_CORNER_LATITUDE ((float)23.933626)
#define RIYADH_SW_CORNER_LONGITUDE ((float)45.890855)

@interface RidesServiceManager : NSObject

+(void)getvehicle:(NSString *)vehicleID :(void (^)(NSDictionary *))completion;

+(void)setDriverOnRide:(NSDictionary *)parameters :(void (^)(NSDictionary *))completion;

+(void)acceptRideRequest:(NSDictionary *)parameters andRideID:(NSString *)rideID :(void (^)(NSDictionary *))completion;

+(void)getClientInfo:(NSString *)clientID :(void (^)(NSDictionary *))completion;

+(void)sendDriverLocation:(NSString *)url params:(NSDictionary *)parameters :(void (^)(NSDictionary *))completion;


+(void)driverConfirmArrivalToClient:(NSDictionary *)parameters andRideID:(NSString *)rideID :(void (^)(NSDictionary *))completion;

+(void)driverBecameNearby:(NSDictionary *)parameters andRideID:(NSString *)rideID :(void (^)(NSDictionary *))completion;

+(void)updateRideDestination:(NSDictionary *)parameters andRideID:(NSString *)rideID :(void (^)(NSDictionary *))completion;

+(void)beginRide:(NSDictionary *)parameters andRideID:(NSString *)rideID :(void (^)(NSDictionary *))completion;

+(void)stopRide:(NSDictionary *)parameters andRideID:(NSString *)rideID :(void (^)(NSDictionary *))completion;

+(void)finishRide:(NSDictionary *)parameters andRideID:(NSString *)rideID :(void (^)(NSDictionary *))completion;

+(void)cancelRideRequest:(NSDictionary *)parameters andRideID:(NSString *)rideID :( void (^)(NSDictionary *))completion;

+(void)getRide:(NSString *)rideID :(void (^)(NSDictionary *))completion;

+(void)dismissLastRideCancelation :( void (^)(NSDictionary *))completion;

+(void)rateClient:(NSDictionary *)parameters AfterRide:(NSString *)rideID :(void (^)(NSDictionary *))completion;


+(void)getCancelationReasons :(void (^)(NSDictionary *))completion;

+(GMSMapStyle *)setMapStyleFromFileName : (NSString *)fileName;
@end
