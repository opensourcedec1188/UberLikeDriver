//
//  EarningsServiceManager.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/17/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

#import "ServiceManager.h"


@interface EarningsServiceManager : NSObject

+(void)getDailyProfit:(NSDictionary *)parameters :(void (^)(NSDictionary *))completion;

+(void)getDayRides:(NSDictionary *)parameters :(void (^)(NSDictionary *))completion;

+(void)getRideProfit:(NSString *)rideID :(void (^)(NSDictionary *))completion;

+(void)getWeeklyProfitWithParameters:(NSDictionary *)parameters :(void (^)(NSDictionary *))completion;

+(void)getWeeklyProfit :(void (^)(NSDictionary *))completion;

+(void)getWeeklyRides:(NSDictionary *)parameters :(void (^)(NSDictionary *))completion;

+(void)getTransactions :(void (^)(NSDictionary *))completion;

@end
