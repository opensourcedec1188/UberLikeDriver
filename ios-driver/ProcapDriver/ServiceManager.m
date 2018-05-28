//
//  ServiceManager.m
//  ProcapDriver
//
//  Created by MacBookPro on 3/23/17.
//  Copyright © 2017 Amer. All rights reserved.
//
#import <AFNetworking.h>
#import "ServiceManager.h"

@implementation ServiceManager

#pragma mark - Rules
/*
 Get App Rules
 Return: Rules Data
 */

+ (void)getAppRules :( void (^)(NSDictionary *))completion
{
    NSString *URLString = [NSString stringWithFormat:@"%@/rules", BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        completion(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil);
        NSLog(@"getAppRules - error: %@", error.localizedDescription);
    }];
    
}

/*
 Method to determine driver state
 Returns: NSDictionary contains segue that splash controller should implement
--> LoggedInDriver?
        NO   --> Go Login Screen
        YES? --> isActive?
                    YES --> Go Map Screen
                    NO  --> All Registration Done?
                              YES --> Go Inspection (Greetings)
                              NO --> Go SignUp, handles current registration step
 
 1 -> Go Login
 2 -> Go SignUp
 3 -> Go Inspection
 4 -> Go Map
 */
+ (void) setDriverState :( void (^)(NSDictionary *))completion
{
    
    if([self getDriverDataFromUserDefaults]){
        NSDictionary *loggedInDriver = [self getDriverDataFromUserDefaults];
        NSLog(@"driver on this device : %@", loggedInDriver);
        [self getDriverData:[loggedInDriver objectForKey:@"_id"] :^(NSDictionary *driver) {
            NSLog(@"getDriverData : %@", driver);
            if([driver objectForKey:@"data"]){
                NSDictionary *updatedData = [driver objectForKey:@"data"];
                //Update driver data with the new data from server
                [self saveLoggedInDriverData:updatedData andAccessToken:nil];
                //Check if isActive driver, Go Map
                if([[updatedData objectForKey:@"isActive"] intValue] == 1){
                    //Clean registration shit
                    [self cleanRegistrationShit];
                    
                    if([[updatedData objectForKey:@"isOnRide"] intValue] == 1){
                                                NSDictionary *currentRide = (NSDictionary *)[driver objectForKey:@"currentRide"];
                        NSDictionary *state;
                        if([[currentRide objectForKey:@"status"] isEqualToString:@"clearance"]){
                            state = @{
                                      @"segue" : @"splashGoPayment",
                                      @"description" : @"payment",
                                      @"currentRide" : currentRide
                                      };
                        }else{
                            state = @{
                                    @"segue" : @"splashGoOnRide",
                                    @"description" : @"onRide",
                                    @"currentRide" : currentRide
                                    };
                        }
                        completion(state);
                    }else{
                        //Not on ride
                        NSDictionary *state;
                        if([[updatedData objectForKey:@"lastRideMessage"] isEqualToString:@"not-rated"]){
                            state = @{
                                      @"segue" : @"splashGoRating"
                                      };
                        }else{
                            state = @{
                                        @"segue" : @"goHomeSegue"
                                    };
                        }
                        completion(state);
                    }
                    
                }else{
                    NSLog(@"in-active driver -- Reg Step : %@", [ServiceManager getCurrentRegisterationStep]);
                    //We've a driver but not Active,
                    //   If he finished all registration, Go inspection
                    //   Else, Go to signup (RegistrationRootViewController), It will handle
                    NSString *segue = @"";
                    if([[ServiceManager getCurrentRegisterationStep] isEqualToString:@"all_done"] || !([ServiceManager getCurrentRegisterationStep]) )
                        segue = @"goInspection";
                    else
                        segue = @"goSignUp"; //RegistrationRootController will handle step
                    NSDictionary *state = @{
                                            @"segue" : segue
                                            };
                    completion(state);
                }
                
            }else{
                if([[driver objectForKey:@"code"] intValue] == 401){
                    [self saveLoggedInDriverData:nil andAccessToken:nil];
                    //No Driver on this device, Go Login
                    NSDictionary *state = @{
                                            @"segue" : @"goLoginSegue"
                                            };
                    completion(state);
                }else if([[driver objectForKey:@"code"] intValue] == 404){
                    [self saveLoggedInDriverData:nil andAccessToken:nil];
                    //No Driver on this device, Go Login
                    NSDictionary *state = @{
                                            @"segue" : @"goLoginSegue"
                                            };
                    completion(state);
                }else{
                    NSLog(@"important test case, Driver exists on device, And not on server!!! ");
                    //No Driver on this device, Go Login
                    NSDictionary *state = @{
                                            @"segue" : @"goHomeSegue"
                                            };
                    completion(state);
                }
            }
        }];
    }else{//No Driver on this device, Go Login
        completion(@{@"segue" : @"goLoginSegue"});
    }
}

+(void)cleanRegistrationShit{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"temp_vehicle_info"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"temp_personal_info"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"currentRegistrationStep"];
//    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"register_vehicle_data"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
 SMS Message Request OTP
 Params: phone number
 Return: true or false
 */
+ (void)requestOTPCode:(NSDictionary *)parameters :(void (^)(NSDictionary *))completion {
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/send-otp", BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"requestOTPCode body : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
    
}
/*
 Confirm Confirm OTP Code
 Params: OTP code, Phone number
 Return: Yes if
 */
+(void)confirmOTPCode:(NSDictionary *)parameters :(void (^)(NSDictionary *))completion {
    NSLog(@"will verify mobile : %@", parameters);
    //URL String
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/verify-otp", BASE_URL];
    //Request Parameters
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
        
    [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"confirmOTPCode body : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
    }];
    
    
}

/* Save phone session after confirming OTP To be used in driver registration */
+(BOOL)savePhoneSession:(NSString *)accessToken{
    
    
    [SAMKeychain deletePasswordForService:SERVICE_NAME account:DRIVER_PHONE_SESSION_ACCESS_TOKEN_KEY];
    
    BOOL inserted = [SAMKeychain setPassword:accessToken forService:SERVICE_NAME account:DRIVER_PHONE_SESSION_ACCESS_TOKEN_KEY];
    
    return inserted;
}
+(NSString *)getPhoneSession
{
//    Keychain * keychain =[[Keychain alloc] initWithService:SERVICE_NAME withGroup:nil];
//    NSData * atData =[keychain find:DRIVER_PHONE_SESSION_ACCESS_TOKEN_KEY];
    
    NSString *accessToken = [SAMKeychain passwordForService:SERVICE_NAME account:DRIVER_PHONE_SESSION_ACCESS_TOKEN_KEY];//[[NSString alloc] initWithData:atData encoding:NSUTF8StringEncoding];
    
    NSLog(@"KEYCHAIN PHONE ACESSTOKEN : %@", accessToken);
    
    return accessToken;
}

+(void)deletePhoneSessionFromKeychain
{
    [SAMKeychain deletePasswordForService:SERVICE_NAME account:DRIVER_PHONE_SESSION_ACCESS_TOKEN_KEY];
}

/*
 Validate First Personal Info Screen Inputs Request
 Params:
 Return:
 */
+(BOOL)validateFirstPersonalInfoData:(NSDictionary *)dataToValidate :(void (^)(NSDictionary *))completion
{
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/validate-personal-info", BASE_URL];
    if(dataToValidate)
    {
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
        
        [manager PUT:URLString parameters:dataToValidate success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            completion((NSDictionary *)responseObject);
            [manager invalidateSessionCancelingTasks:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
                NSLog(@"validateFirstPersonalInfoData error body : %@", failureResponseBody);
                completion(failureResponseBody);
            }else{
                completion(nil);
            }
            [manager invalidateSessionCancelingTasks:YES];
        }];
    }else{
        return NO;
    }
    return YES;
}

/*
 Full Register Request
 Params:
 Return:
 */
+(BOOL)personalInfoRegister:(NSDictionary *)personalInfo :(void (^)(NSDictionary *))completion
{
    
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers", BASE_URL];
    NSLog(@"Will RegisterFullData : %@ and URL : %@", personalInfo, URLString);
    if(personalInfo)
    {
        NSLog(@"validation passed");
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:[self getPhoneSession] forHTTPHeaderField:@"X-Access-Token"];
        [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
        
        [manager POST:URLString parameters:personalInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            completion((NSDictionary *)responseObject);
            [manager invalidateSessionCancelingTasks:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
                NSLog(@"personalInfoRegister error body : %@", failureResponseBody);
                completion(failureResponseBody);
            }else{
                completion(nil);
            }
            [manager invalidateSessionCancelingTasks:YES];
        }];
    }else{
        NSLog(@"validation not passed");
        return NO;
    }
    return YES;
    
}

+(void)getDriverData:(NSString *)driverID :( void (^)(NSDictionary *))completion{
    
    NSString *URLString = [NSString stringWithFormat:@"%@/drivers/%@", BASE_URL, driverID];
    NSLog(@"Will getDriverData URL : %@ -- %@", URLString, [self getAccessTokenFromKeychain]);
    if(driverID.length > 0)
    {
        NSLog(@"validation passed");
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSLog(@"access token : %@", [ServiceManager getAccessTokenFromKeychain]);
        [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
        [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
        
        [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"DriverGetResponse : %@", responseObject);
            completion((NSDictionary *)responseObject);
            [manager invalidateSessionCancelingTasks:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
                NSLog(@"driver get error : %@", failureResponseBody);
                completion(failureResponseBody);
            }else{
                completion(nil);
            }
            [manager invalidateSessionCancelingTasks:YES];
        }];
       
    }else{
        NSLog(@"NO ID passed");
        completion(nil);
    }
}

+(void)driverLogout :(void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"%@/sessions/current", BASE_URL];
    NSLog(@"Will logout driver : %@ ", [self getAccessTokenFromKeychain]);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[self getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager DELETE:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self deleteLoggedInDriverDataFromDevice];
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self deleteLoggedInDriverDataFromDevice];
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"logout error body : %@", failureResponseBody);
            completion(failureResponseBody);
        }else{
            completion(nil);
        }
        [manager invalidateSessionCancelingTasks:YES];
        NSLog(@"driverLogout -- error: %@", error.localizedDescription);
    }];
    
}
/*
 Validate Vehicle Request Request
 Params:
 Return:
 */
+(BOOL)validateVehicleRequest:(NSDictionary *)dataToValidate :(void (^)(NSDictionary *))completion
{
    NSString *URLString = [NSString stringWithFormat:@"%@/vehicles/validate-basic-info", BASE_URL];
    NSLog(@"Will validate vehicle info : %@ and URL : %@", dataToValidate, URLString);
    if(dataToValidate)
    {
        NSLog(@"validation passed");
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
        
        
        [manager PUT:URLString parameters:dataToValidate success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"success! %@", responseObject);
            completion((NSDictionary *)responseObject);
            [manager invalidateSessionCancelingTasks:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
                NSLog(@"validateVehicleRequest error body : %@", failureResponseBody);
                completion(failureResponseBody);
            }else{
                completion(nil);
            }
            [manager invalidateSessionCancelingTasks:YES];
        }];
    }else{
        NSLog(@"validation not passed");
        return NO;
    }
    return YES;
}
/*
 Register New Vehivle Request
 Params:
 Return:
 */
+ (BOOL)registerVehicle:(NSDictionary *)vehicleInfo andAccessToken:(NSString *)accessToken :(void (^)(NSDictionary *))completion
{
    NSString *URLString = [NSString stringWithFormat:@"%@/vehicles", BASE_URL];
    NSLog(@"Will Register Vehicle : %@ and URL : %@", vehicleInfo, URLString);
    if(vehicleInfo)
    {
        NSLog(@"validation passed");
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:accessToken forHTTPHeaderField:@"X-Access-Token"];
        [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
        
        [manager POST:URLString parameters:vehicleInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"success! %@", [responseObject objectForKey:@"code"]);
            completion((NSDictionary *)responseObject);
            [manager invalidateSessionCancelingTasks:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
                NSLog(@"registerVehicle error body : %@", failureResponseBody);
                completion(failureResponseBody);
            }else{
                completion(nil);
            }
            [manager invalidateSessionCancelingTasks:YES];
        }];
    }else{
        NSLog(@"validation not passed");
        return NO;
    }
    return YES;
}

/*
 Upload Image
 Params: UIImage
 */

+ (BOOL)uploadImage:(UIImage *)image andPhotoType:(NSString *)type andAccessToken:(NSString *)accessToken :(void (^)(double))progressing :(void (^)(NSDictionary *))completion
{
    NSString *URLString = [NSString stringWithFormat:@"%@/%@", BASE_URL, type];
    NSLog(@"url string : %@", URLString);
    NSArray *charsArray = [URLString componentsSeparatedByString:@"/"];
    NSString *file = [charsArray objectAtIndex:(charsArray.count - 1)];
    NSLog(@"fileName : %@", file);
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"PUT" URLString:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.9) name:file fileName:file mimeType:@"image/jpeg"];
    } error:nil];
    
    [request setValue:accessToken forHTTPHeaderField:@"X-Access-Token"];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      progressing(uploadProgress.fractionCompleted);
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"uploadImage -- Error: %@", error);
                          NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                          if(errorData){
                              NSDictionary *failureResponseBody = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
                              NSLog(@"error body : %@", failureResponseBody);
                              completion(failureResponseBody);
                          }else
                              completion(nil);
                      } else {
                          NSLog(@"uploadImage responseObject : %@", responseObject);
                          completion(responseObject);
                      }
                  }];
    
    [uploadTask resume];
    
    return YES;
    
}


#pragma mark - Delete logged-in driver from device UserDefaults and Keychain
+ (BOOL)deleteLoggedInDriverDataFromDevice
{
    BOOL result = YES;
    if(![SAMKeychain deletePasswordForService:SERVICE_NAME account:DRIVER_ACCESS_TOKEN_KEY])
        result = NO;
    
    /* Second, Delete user data from NSUserDefaults */
    /* Delete Driver data from NSUserDefaults */
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:UD_DRIVER_DATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return result;
}


#pragma mark - Sign in
/*
 Login Request
 Params: NSDictionary (role, device, email, password)
 Return: data { accessToken, device, role, userId }
 aPrELzpXDhNsrI9z4pwERX1p5TEdk1fB
 */

+ (void)driverLogin:(NSDictionary *)loginData :( void (^)(NSDictionary *))completion
{
    NSLog(@"Login trial using data : %@", loginData);
    NSString *URLString = [NSString stringWithFormat:@"%@/sessions", BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager POST:URLString parameters:loginData progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success! %@", responseObject);
        if(([responseObject objectForKey:@"data"]) && [[responseObject objectForKey:@"data"] objectForKey:@"accessToken"])
            [self saveLoggedInDriverData:[responseObject objectForKey:@"user"] andAccessToken:[[responseObject objectForKey:@"data"] objectForKey:@"accessToken"]];
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil);
        NSLog(@"driverLogin -- error: %@", error.localizedDescription);
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

#pragma mark - Save logged-in driver data
/*
 Save driver data to userdefaults and accessToken to keychain
 Params: driver data dictionary
 Return: data { accessToken, device, role, userId }
 */
+ (BOOL)saveLoggedInDriverData:(NSDictionary *)driverData andAccessToken:(NSString *)accessToken
{
    BOOL result = YES;
    if(driverData && accessToken)
    {
        [SAMKeychain deletePasswordForService:SERVICE_NAME account:DRIVER_ACCESS_TOKEN_KEY];
        
        /* First, Save access token in device keychain */        
        if(![SAMKeychain setPassword:accessToken forService:SERVICE_NAME account:DRIVER_ACCESS_TOKEN_KEY])
            result = NO;
        
        /* Second, Save user data to user defaults */
        /* Driver data */
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:driverData] forKey:UD_DRIVER_DATA];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else if(driverData){
        //Update Driver
        /* Driver data */
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:driverData] forKey:UD_DRIVER_DATA];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:UD_DRIVER_DATA];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return result;
}

+(NSDictionary *)getDriverDataFromUserDefaults
{
    NSDictionary *driverData = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]objectForKey:UD_DRIVER_DATA]];
    return driverData;
}


+(NSString *)getAccessTokenFromKeychain
{
    return [SAMKeychain passwordForService:SERVICE_NAME account:DRIVER_ACCESS_TOKEN_KEY];
//    return [[NSString alloc] initWithData:[[[Keychain alloc] initWithService:SERVICE_NAME withGroup:nil] find:DRIVER_ACCESS_TOKEN_KEY] encoding:NSUTF8StringEncoding];
}

+(void) saveCurrentRegisterationStep:(NSString *)currentRegStep{
    NSLog(@"saveCurrentRegisterationStep : %@", currentRegStep);
    [[NSUserDefaults standardUserDefaults] setObject:currentRegStep forKey:@"currentRegistrationStep"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *) getCurrentRegisterationStep
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"currentRegistrationStep"];
}

//Note: callback created to avoid synchronizing NSUserDefaults sequentially
+(void)saveRegisterVehicleData:(NSDictionary *)vehicleData  :( void (^)(BOOL))completed
{
    NSLog(@"will save vehilce data to userDefaults : %@", vehicleData);
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:vehicleData] forKey:@"register_vehicle_data"];
    
    completed(YES);
}

+(NSDictionary *)getVehicleDataFromUserDefaults
{
    NSLog(@"getVehicleDataFromUserDefaults : %@", [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]objectForKey:@"register_vehicle_data"]]);
    return (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]objectForKey:@"register_vehicle_data"]];
}


+(void)saveTempPersonalInfo:(NSDictionary *)info{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:info] forKey:@"temp_personal_info"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSDictionary *)getTempPersonalInfo{
    return (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]objectForKey:@"temp_personal_info"]];
}

+(void)saveTempVehicleInfo:(NSDictionary *)info{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:info] forKey:@"temp_vehicle_info"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDictionary *)getTempVehicleInfo{
    NSDictionary *tempVehicleInfo = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]objectForKey:@"temp_vehicle_info"]];
    return tempVehicleInfo;
}

@end
