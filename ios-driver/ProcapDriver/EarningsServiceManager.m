//
//  EarningsServiceManager.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/17/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "EarningsServiceManager.h"

@implementation EarningsServiceManager

+(void)getDailyProfit:(NSDictionary *)parameters :(void (^)(NSDictionary *))completion{
    
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/%@/profits/daily", BASE_URL, [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]];
    NSLog(@"URLString : %@ params : %@", URLString, parameters);
    if(parameters){
        if([parameters objectForKey:@"day"] && [parameters objectForKey:@"month"] && [parameters objectForKey:@"year"]){
            URLString = [NSString stringWithFormat:@"%@?day=%@&month=%@&year=%@", URLString, [parameters objectForKey:@"day"], [parameters objectForKey:@"month"], [parameters objectForKey:@"year"]];
        }
    }
    NSLog(@"URLString : %@", URLString);
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
            NSLog(@"getDailyProfit error : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+(void)getDayRides:(NSDictionary *)parameters :(void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/%@/profits/daily/rides", BASE_URL, [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]];
    NSLog(@"getDayRides URLString : %@ params : %@", URLString, parameters);
    if(parameters){
        if([parameters objectForKey:@"day"] && [parameters objectForKey:@"month"] && [parameters objectForKey:@"year"]){
            URLString = [NSString stringWithFormat:@"%@?day=%@&month=%@&year=%@", URLString, [parameters objectForKey:@"day"], [parameters objectForKey:@"month"], [parameters objectForKey:@"year"]];
        }
    }
    NSLog(@"getDayRides URLString : %@", URLString);
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
            NSLog(@"getDailyProfit error : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+(void)getRideProfit:(NSString *)rideID :(void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/rides/%@/details", BASE_URL, rideID];
    NSLog(@"getRideProfit URLString : %@ ", URLString);

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
            NSLog(@"getRideProfit error : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}
+(void)getWeeklyProfitWithParameters:(NSDictionary *)parameters :(void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/%@/profits/weekly", BASE_URL, [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]];
    NSLog(@"URLString : %@ params : %@", URLString, parameters);
    if(parameters){
        if([parameters objectForKey:@"day"] && [parameters objectForKey:@"month"] && [parameters objectForKey:@"year"]){
            URLString = [NSString stringWithFormat:@"%@?day=%@&month=%@&year=%@", URLString, [parameters objectForKey:@"day"], [parameters objectForKey:@"month"], [parameters objectForKey:@"year"]];
        }
    }
    NSLog(@"URLString : %@", URLString);
    
    NSString *stringCleanPath = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager GET:stringCleanPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(completion)
            completion(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"getWeeklyProfitWithParameters -- error: %@", error.localizedDescription);
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            completion(failureResponseBody);
        }else{
            completion(@{});
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+(void)getWeeklyProfit :(void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/%@/profits/weekly", BASE_URL, [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]];
    NSLog(@"URLString : %@", URLString);
    
    NSString *stringCleanPath = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager GET:stringCleanPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"getWeeklyProfit -- error: %@", error.localizedDescription);
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            completion(failureResponseBody);
        }else{
            completion(@{});
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
    
}

+(void)getWeeklyRides:(NSDictionary *)parameters :(void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/%@/profits/weekly/rides", BASE_URL, [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]];
    NSLog(@"getWeeklyRides URLString : %@ params : %@", URLString, parameters);
    if(parameters){
        if([parameters objectForKey:@"day"] && [parameters objectForKey:@"month"] && [parameters objectForKey:@"year"]){
            URLString = [NSString stringWithFormat:@"%@?day=%@&month=%@&year=%@", URLString, [parameters objectForKey:@"day"], [parameters objectForKey:@"month"], [parameters objectForKey:@"year"]];
        }
    }
    NSLog(@"getWeeklyRides URLString : %@", URLString);
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
            NSLog(@"getWeeklyRides error : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+(void)getTransactions :(void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/%@/transactions", BASE_URL, [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]];
    NSLog(@"getTransactions URLString : %@", URLString);
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
            NSLog(@"getTransactions error : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

@end
