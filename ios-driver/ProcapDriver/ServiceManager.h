//
//  ServiceManager.h
//  ProcapDriver
//
//  Created by MacBookPro on 3/23/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <Security/Security.h>
#import <SAMKeychain.h>

#import "HelperClass.h"

#define BASE_URL @"https://www.procabnow.com/api/v0" /* Back-End base url */
#define SERVICE_NAME @"procab_driver" /* Keychain service name for access token */
#define DRIVER_ACCESS_TOKEN_KEY @"driverAccessToken" /* keychain key for service token */
#define DRIVER_PHONE_SESSION_ACCESS_TOKEN_KEY @"driverPhoneSession"

//#define UD_DRIVER_LOGIN @"procab_driver_logged_in" /* Bool represents user logged in or not in UserDefaults */
#define UD_DRIVER_DATA @"procab_driver_data" /* dictionary represents full driver data in userDefaults */
//#define UD_DRIVER_LOGGED_IN @"procab_driver_logged_in" /* dictionary represents full driver data in userDefaults */

/* Response keys as per Back-End */
#define DRIVERTDATA_API_ID @"_id"
#define DRIVERTDATA_API_CURRENT_REG_STEP @"currentRegistrationStep"
#define DRIVERDATA_API_EMAIL @"email"
#define DRIVERDATA_API_DIALCODE @"dialCode"
#define DRIVERDATA_API_FNAME @"firstName"
#define DRIVERDATA_API_LNAME @"lastName"
#define DRIVERDATA_API_LANGUAGE @"language"
#define DRIVERDATA_API_GENDER @"gender"
#define DRIVERDATA_API_PHONE @"phone"
#define DRIVERDATA_API_REFERRAL_CODE @"referralCode"
#define DRIVERDATA_API_PASSWORD @"password"
#define DRIVERDATA_API_PASSWORD_CONFIRM @"passwordConfirmation"

#define DRIVERTDATA_API_BIRTHDATE @"birthdate"
#define DRIVERTDATA_API_CAN_DRIVER_UPLOAD_LICENSE_PHOTO @"canDriverUploadLicensePhoto"
#define DRIVERTDATA_API_CAN_DRIVER_UPLOAD_SSN_PHOTO @"canDriverUploadSsnPhoto"
#define DRIVERTDATA_API_CITY @"city"
#define DRIVERTDATA_API_COUNTRY @"country"
#define DRIVERTDATA_API_DISTRICT @"district"
#define DRIVERTDATA_API_IS_BOOKED @"isBooked"
#define DRIVERTDATA_API_IS_CARVERIFIED @"isCarVerifiedByGovernment"
#define DRIVERTDATA_API_IS_ONDUTY @"isOnDuty"
#define DRIVERTDATA_API_IS_RATED @"isRated"
#define DRIVERTDATA_API_IS_VERIFIED @"isVerifiedByGovernment"
#define DRIVERTDATA_API_SSN @"ssn"
#define DRIVERTDATA_API_SSN_EXPIRY @"ssnExpiry"
#define DRIVERTDATA_API_SSN_PHOTO_EXISTS @"ssnPhotoExists"
#define DRIVERTDATA_API_STREET @"street"

@interface ServiceManager : NSObject
#pragma mark - Rules
/*
 Get App Rules
 Return: Rules Data
 */

+ (void)getAppRules :( void (^)(NSDictionary *))completion;
+ (void) setDriverState :( void (^)(NSDictionary *))completion;

#pragma mark - Registeration
/*
 SMS Message Request OTP
 Params:
 Return:
 */
+ (void)requestOTPCode:(NSDictionary *)parameters :(void (^)(NSDictionary *))completion;

/*
 Confirm OTP Code
 Params:
 Return:
 */
+(void)confirmOTPCode:(NSDictionary *)parameters :(void (^)(NSDictionary *))completion;

/* Save phone session to keychain after confirming OTP To be used in driver registration */
+(BOOL)savePhoneSession:(NSString *)accessToken;
/* Get phone session from keychain */
+(NSString *)getPhoneSession;

+(void)deletePhoneSessionFromKeychain;

/*
 Validate First Personal Info Screen Inputs Request
 Params:
 Return:
 */
+(BOOL)validateFirstPersonalInfoData:(NSDictionary *)dataToValidate :(void (^)(NSDictionary *))completion;

/*
 Full Register Request
 Params:
 Return:
 */
+(BOOL)personalInfoRegister:(NSDictionary *)personalInfo :(void (^)(NSDictionary *))completion;

/*
 Get Driver Data
Params: driverID
 */
+(void)getDriverData:(NSString *)driverID :( void (^)(NSDictionary *))completion;
+(void)driverLogout :(void (^)(NSDictionary *))completion;
/*
 Validate Vehicle Request Request
 Params:
 Return:
 */
+(BOOL)validateVehicleRequest:(NSDictionary *)dataToValidate :(void (^)(NSDictionary *))completion;

/*
 Add Vehicle Request Request
 Params:
 Return:
 */
+ (BOOL)registerVehicle:(NSDictionary *)vehicleInfo andAccessToken:(NSString *)accessToken :(void (^)(NSDictionary *))completion;


/*
 Upload Image
 Params: UIImage
 */

+ (BOOL)uploadImage:(UIImage *)image andPhotoType:(NSString *)type andAccessToken:(NSString *)accessToken :(void (^)(double))progressing :(void (^)(NSDictionary *))completion;



/*
 Register New Vehivle Request
 Params: 
 Return:
 */
//+ (BOOL)registerVehicle:(NSDictionary *)vehicleInfo :(void (^)(NSDictionary *))completion;


#pragma mark - Delete Driver
//+ (BOOL) deleteDriver:(NSString *)driverID andAccessToken:(NSString *)accessToken :(void (^)(NSDictionary *))completion;
+ (BOOL)deleteLoggedInDriverDataFromDevice;

#pragma mark - Sign in
/*
 Login Request
 Params: role, device, email, password
 Return: data { accessToken, device, role, userId }
 */

+ (void)driverLogin:(NSDictionary *)loginData :( void (^)(NSDictionary *))completion;

#pragma mark - Save logged-in driver data
/*
 Login Request
 Params: role, device, email, password
 Return: data { accessToken, device, role, userId }
 */
+ (BOOL)saveLoggedInDriverData:(NSDictionary *)driverData andAccessToken:(NSString *)accessToken;

+(NSDictionary *)getDriverDataFromUserDefaults;



+(NSString *)getAccessTokenFromKeychain;

+(void) saveCurrentRegisterationStep:(NSString *)currentRegStep;

+(NSString *) getCurrentRegisterationStep;

+(void)saveRegisterVehicleData:(NSDictionary *)vehicleData  :( void (^)(BOOL))completed;

+(NSDictionary *)getVehicleDataFromUserDefaults;
//+(void)deleteRegisterVehicleData;

+(void)saveTempPersonalInfo:(NSDictionary *)info;
+(NSDictionary *)getTempPersonalInfo;

+(void)saveTempVehicleInfo:(NSDictionary *)info;
+(NSDictionary *)getTempVehicleInfo;

@end
