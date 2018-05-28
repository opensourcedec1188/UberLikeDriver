//
//  ProfileServiceManager.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/20/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "ProfileServiceManager.h"


@implementation ProfileServiceManager

+(void)getDriverImage:(NSString *)urlString :( void (^)(NSData *))completion{
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlString]];
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"driverImageData"];
    
    completion(imageData);
}

+(void)getVehicleImage:(NSString *)urlString :( void (^)(NSData *))completion{
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlString]];
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"vehicleImageData"];
    
    completion(imageData);
}

+(void)toggleReceiveAllTrips:(NSDictionary *)parameters :( void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/%@/settings", BASE_URL, [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]];
    NSLog(@"Will toggleReceiveAllTrips : %@ ", parameters);
    
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
            NSLog(@"body : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+ (void)updatePasswordData:(NSDictionary *)parameters :( void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/%@/change-password", BASE_URL, [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Password -- success! responseObject:  %@", responseObject);
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"body : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+(void)getDriverDocuments :( void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/%@/documents", BASE_URL, [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]];
    NSLog(@"getDriverDocuments URLString : %@", URLString);
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
            NSLog(@"getDriverDocuments error : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}


+ (void)addPayout:(NSDictionary *)parameters :( void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/%@/payout", BASE_URL, [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"addPayout -- success! responseObject:  %@", responseObject);
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"addPayout body : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

#pragma mark - Help
+(void)getGeneralHelpOptions :( void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/%@/options/help?language=%@", BASE_URL, [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"], [HelperClass getDeviceLanguage]];
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
            NSLog(@"ride get error : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+(void)getRideHelpOptions :( void (^)(NSDictionary *))completion;{
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/%@/options/report-ride?language=%@", BASE_URL, [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"], [HelperClass getDeviceLanguage]];
    NSLog(@"URLString : %@", URLString);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"getRideHelpOptions : %@", responseObject);
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
}

@end
