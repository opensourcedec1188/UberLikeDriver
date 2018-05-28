//
//  ProfileServiceManager.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/20/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "ServiceManager.h"
#import "HelperClass.h"

@interface ProfileServiceManager : NSObject

+(void)getDriverImage:(NSString *)urlString :( void (^)(NSData *))completion;

+(void)getVehicleImage:(NSString *)urlString :( void (^)(NSData *))completion;

+(void)toggleReceiveAllTrips:(NSDictionary *)parameters :( void (^)(NSDictionary *))completion;

+ (void)updatePasswordData:(NSDictionary *)parameters :( void (^)(NSDictionary *))completion;

+(void)getDriverDocuments :( void (^)(NSDictionary *))completion;

+ (void)addPayout:(NSDictionary *)parameters :( void (^)(NSDictionary *))completion;

#pragma mark - Help
+(void)getGeneralHelpOptions :( void (^)(NSDictionary *))completion;

+(void)getRideHelpOptions :( void (^)(NSDictionary *))completion;

@end
