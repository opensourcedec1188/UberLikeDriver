//
//  HelperClass.h
//  Procap
//
//  Created by MacBookPro on 3/22/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GMSGeocoder.h>
#import <CoreLocation/CoreLocation.h>

#import "Reachability.h"

#define ARABIC_LANG_APP_CODE @"ar"
#define ENGLISH_LANG_APP_CODE @"en"
#define ARABIC_LANG_DEVICE_CODE @"ar-US"
#define INDIAN_LANG_DEVICE_CODE @"hi-US"

#define LONG_FIELD @"Long_Field-01.png"
#define LONG_FIELD_with_arrow @"Long_Field_with_arrow-01.png"
#define LONG_FIELD_ERROR @"Long_Field_Error-01.png"
#define LONG_FIELD_with_error_with_arrow @"Long_field_Error-01.png"
#define SHORT_FIELD @"Short_Field-01.png"
#define SHORT_FIELD_with_arrow @"Short_Field_with_arrow-01.png"
#define SHORT_FIELD_ERROR @"Short_Field_Error-01.png"
#define SHORT_FIELD_with_arrow_with_error @"Short_field_error_Error-01.png"

#define POPUP_ERROR_LONG @"Popup_note_Long-01.png"
#define POPUP_ERROR_SHORT @"Popup_note_short-01.png"

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (x * 180.0 / M_PI)

#define FONT_ROBOTO_REGULAR @"Roboto-Regular"
#define FONT_ROBOTO_LIGHT @"Roboto-Light"
#define FONT_ROBOTO_MEDIUM @"Roboto-Medium"
#define FONT_ROBOTO_BOLD @"Roboto-Bold"


@interface HelperClass : NSObject


+ (BOOL)checkNetworkReachability;
+ (BOOL)validateText:(NSString *)text ;
+ (BOOL)validateMobileNumber:(NSString *)mobNumber;
+ (BOOL) validateEmailAddress:(NSString*) emailString;
+ (BOOL)validateSSN:(NSString *)ssnString;
+ (BOOL)validatedates:(NSString *)dateString;
+(BOOL)validateFLNames:(NSString *)name;


+ (NSString *)getDeviceLanguage;

+ (UIAlertController *)showAlert:(NSString *)title andMessage:(NSString *)message;

+ (NSDate *)convertStringToDate:(NSString *)strDate fromFormat:(NSString *)strFromFormat;

+(UIVisualEffectView *)createBlurViewWithFrame:(CGRect)frame;

+ (UIImageView *)returnTFImage:(NSString *)image andDimensions:(CGRect)frame;

+(NSDictionary *)serverSideValidation:(NSDictionary *)response;

+(int)convertArabicNumber:(NSString *)numString;

+(BOOL)checkAppVersion:(NSString *)appVersion andRemoteVersion:(NSString *)remoteVersion;

+(float)getBearing:(CLLocationCoordinate2D)locations1 andSecond:(CLLocationCoordinate2D)locattion2;

+ (NSString *)HEXFromDevicePushToken:(NSData *)data;

+(BOOL)checkCoordinates:(NSDictionary *)data;

//+(double)distanceBetweenFirst:(CLLocation *)firstLocation andSecond:(CLLocation *)secondLocation;

+(float)angleFromCoordinate:(CLLocationCoordinate2D)first toCoordinate:(CLLocationCoordinate2D)second;
    
@end
