//
//  RidesServiceManager.m
//  ProcapDriver
//
//  Created by MacBookPro on 4/25/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "RidesServiceManager.h"

@implementation RidesServiceManager


+(void)getvehicle:(NSString *)vehicleID :(void (^)(NSDictionary *))completion {
    NSString *URLString = [NSString stringWithFormat:@"%@/vehicles/%@", BASE_URL, vehicleID];
    NSLog(@"Will get vehicle : %@ ", vehicleID);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"vehicles : %@", responseObject);
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"vehicles get error : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];

}

+(void)setDriverOnRide:(NSDictionary *)parameters :(void (^)(NSDictionary *))completion {
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/%@/on-duty", BASE_URL, [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]];
    NSLog(@"Will setDriverOnRide : %@ ", parameters);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"setDriverOnRide error body : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+(void)acceptRideRequest:(NSDictionary *)parameters andRideID:(NSString *)rideID :(void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/rides/%@/accept", BASE_URL, rideID];
    NSLog(@"Will accept Ride : %@ with access token %@ and parameters %@", URLString, [ServiceManager getAccessTokenFromKeychain], parameters);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"acceptRideRequest error : %@", error.localizedDescription);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+(void)getClientInfo:(NSString *)clientID :(void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/rides/%@/client", BASE_URL, clientID];
    NSLog(@"Will get client : %@ ", clientID);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"client get error : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+(void)sendDriverLocation:(NSString *)url params:(NSDictionary *)parameters :(void (^)(NSDictionary *))completion {
    if(parameters){
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
        
        [manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            completion((NSDictionary *)responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion(nil);
        }];
    }
}



+(void)driverConfirmArrivalToClient:(NSDictionary *)parameters andRideID:(NSString *)rideID :(void (^)(NSDictionary *))completion {
    NSString *URLString = [NSString stringWithFormat:@"%@/rides/%@/arrived", BASE_URL, rideID];
    NSLog(@"driver arrived : %@ ", URLString);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"driverConfirmArrivalToClient error body : %@", error.localizedDescription);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+(void)driverBecameNearby:(NSDictionary *)parameters andRideID:(NSString *)rideID :(void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/rides/%@/nearby", BASE_URL, rideID];
    NSLog(@"driver nearby (< 300M) : %@ ", URLString);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"driverBecameNearby error body : %@", error.localizedDescription);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+(void)updateRideDestination:(NSDictionary *)parameters andRideID:(NSString *)rideID :(void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/rides/%@/dropoff-location", BASE_URL, rideID];
    NSLog(@"ride started : %@ ", URLString);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"updateRideDestination error body : %@", error.localizedDescription);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+(void)beginRide:(NSDictionary *)parameters andRideID:(NSString *)rideID :(void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/rides/%@/begin", BASE_URL, rideID];
    NSLog(@"ride started : %@ ", URLString);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"beginRide error body : %@", error.localizedDescription);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+(void)stopRide:(NSDictionary *)parameters andRideID:(NSString *)rideID :(void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/rides/%@/stop", BASE_URL, rideID];
    NSLog(@"ride stopped : %@ ", URLString);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"stopRide error body : %@", error.localizedDescription);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+(void)finishRide:(NSDictionary *)parameters andRideID:(NSString *)rideID :(void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/rides/%@/finish", BASE_URL, rideID];
    NSLog(@"ride stopped : %@ and params : %@", URLString, parameters);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"finishRide error body : %@", error.localizedDescription);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+(void)cancelRideRequest:(NSDictionary *)parameters andRideID:(NSString *)rideID :( void (^)(NSDictionary *))completion {
    NSString *URLString = [NSString stringWithFormat:@"%@/rides/%@/cancel", BASE_URL, rideID];
    NSLog(@"Will cancel ride : %@ ", URLString);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"cancelRideRequest -- error: %@", error.localizedDescription);
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"cancelRideRequest error body : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+(void)getRide:(NSString *)rideID :(void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/rides/%@", BASE_URL, rideID];
    NSLog(@"Will get ride URL : %@", URLString);
    if(rideID.length > 0)
    {
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
        [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
        
        [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            completion((NSDictionary *)responseObject);
            [manager invalidateSessionCancelingTasks:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
                NSLog(@"ride get error : %@", failureResponseBody);
                completion(failureResponseBody);
            }else{
                completion(nil);
            }
            [manager invalidateSessionCancelingTasks:YES];
        }];
        
    }else{
        NSLog(@"NO rideID passed");
        completion(nil);
    }
}

+(void)dismissLastRideCancelation :( void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/%@/dismiss-last-ride-message", BASE_URL, [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]];
    NSLog(@"Will rate : %@ ", URLString);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager PUT:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"dismissLastRideCancelation == error: %@", error.localizedDescription);
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"dismissLastRideCancelation error body : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+(void)rateClient:(NSDictionary *)parameters AfterRide:(NSString *)rideID :(void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/rides/%@/rate", BASE_URL, rideID];
    NSLog(@"Will rate : %@ and parameters : %@ ", URLString, parameters);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"rateClient -- error: %@", error.localizedDescription);
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"rateClient error body : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+(GMSMapStyle *)setMapStyleFromFileName : (NSString *)fileName{
    // Set the map style by passing the URL for style.json.
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *styleUrl = [mainBundle URLForResource:fileName withExtension:@"json"];
    NSError *error;
    
    GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:styleUrl error:&error];
    
    if (!style)
        return nil;
    else
        return style;
}

+(void)getCancelationReasons :(void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/%@/options/cancellation-reasons?language=%@", BASE_URL, [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"], [HelperClass getDeviceLanguage]];
    NSLog(@"URLString : %@", URLString);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"cancellation-reasons get error : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

@end
