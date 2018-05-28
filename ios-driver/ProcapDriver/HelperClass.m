//
//  HelperClass.m
//  Procap
//
//  Created by MacBookPro on 3/22/17.
//  Copyright © 2017 Amer. All rights reserved.
//  For

#import "HelperClass.h"

@implementation HelperClass




/* 
 Check if network is reachable
 Returns true if connection available, false if not available
 */
+ (BOOL)checkNetworkReachability
{
    Reachability *internetReachability = [Reachability reachabilityForInternetConnection];
    
    if(!((long)internetReachability.currentReachabilityStatus == 0)){
        NSLog(@"connection available");
        return YES;
    }else{
        NSLog(@"connection NOT available");
        return NO;
    }
}

/*
 Validate string
 Returns true if string is valid
 */
+ (BOOL)validateText:(NSString *)text{
    if(text && !([text isEqualToString:@""]) && !(text.length == 0))
        return YES;
    else
        return NO;
}

/*
 Validate mobile number
 Returns true if mobile number is valid
 */
+ (BOOL)validateMobileNumber:(NSString *)mobNumber{
    NSLog(@"will validate %@", mobNumber);
    BOOL valid = NO;
    if((mobNumber.length == 9) || (mobNumber.length == 10)){
        if([[mobNumber substringToIndex:NSMaxRange([mobNumber rangeOfComposedCharacterSequenceAtIndex:0])] isEqualToString:@"5"])
            valid = YES;
        if([[mobNumber substringToIndex:NSMaxRange([mobNumber rangeOfComposedCharacterSequenceAtIndex:1])] isEqualToString:@"05"])
            valid = YES;
    }
    return valid;
}

/*
 Validate email address
 Returns true if email address is valid
 */
+ (BOOL) validateEmailAddress:(NSString*) emailString {
    
    if([emailString length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
    NSLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)validateSSN:(NSString *)ssnString
{
    BOOL valid = NO;
    if(ssnString.length == 10){
        valid = YES;
    }
    return valid;
}

/*
 Method gets the device current language
 Returns shortcode for the current language
 */
+ (NSString *)getDeviceLanguage
{
    NSString *languageCode = @"";
    NSString *deviceLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if([deviceLanguage hasPrefix:@"en"]) //English
        languageCode = ENGLISH_LANG_APP_CODE;
    else if([deviceLanguage hasPrefix:@"ar"]) //Arabic
        languageCode = ARABIC_LANG_APP_CODE;
    else if([deviceLanguage isEqualToString:INDIAN_LANG_DEVICE_CODE]) //Indian
        languageCode = ENGLISH_LANG_APP_CODE;
    else if([self containsString:deviceLanguage andSubstring:ENGLISH_LANG_APP_CODE]) //Others -> English
        languageCode = ENGLISH_LANG_APP_CODE;
    
    return languageCode;
}

/*
 Method check if a string contains another substring
 Params: Parent string, Substring
 Returns: True of contained
 */
+ (BOOL)containsString:(NSString *)string andSubstring:(NSString *)substring
{
    NSRange range = [string rangeOfString : substring];
    BOOL found = ( range.location != NSNotFound );
    return found;
}

/*
 Method that create UIAlertController with title and message
 Params: Title, Message
 Returns: created UIAlertController
 */
#pragma mark - Alerts
+ (UIAlertController *)showAlert:(NSString *)title andMessage:(NSString *)message
{
    if(([HelperClass validateText:title]) && ([HelperClass validateText:message])){
        UIAlertController *myAlertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"general_ok", @"")
                                                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                 
                                                             }];
        
        [myAlertView addAction:doneAction];
        return myAlertView;
    }else{
        UIAlertController *myAlertView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"general_problem_title", @"") message:NSLocalizedString(@"general_problem_message", @"") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"general_ok", @"")
                                                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                 
                                                             }];
        
        [myAlertView addAction:doneAction];
        return myAlertView;
    }
}

+ (BOOL)validatedates:(NSString *)dateString
{
    BOOL valid = NO;
    if(!(dateString.length == 0) && ![dateString isEqualToString:@"0.000000"]){
        valid = YES;
    }
    return valid;
}

+(BOOL)validateFLNames:(NSString *)name{
    
    

    NSString *regEx = @"^[A-Za-zء-ي ]+$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject: name];
    if(myStringMatchesRegEx)
        NSLog(@"regex valid %@", name);
    else
        NSLog(@"regex not valid %@", name);
    return [regExPredicate evaluateWithObject: name];
    
//    NSCharacterSet *validChars = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ كمنتالبيسشضصثقفغعهخحجةورزدذطظؤإأءئآى"];
//    validChars = [validChars invertedSet];
//    BOOL valid = YES;
//    NSRange  range = [name rangeOfCharacterFromSet:validChars];
//    if (NSNotFound != range.location) {
//        NSLog(@"not valid");
//        valid = NO;
//    }
//    if(valid)
//        NSLog(@"valid");
//    else
//        NSLog(@"not valid");
//    return valid;
}

+(NSDate *)convertStringToDate:(NSString *)strDate fromFormat:(NSString *)strFromFormat
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = strFromFormat;
    return [dateFormatter dateFromString:strDate];
}

+(UIVisualEffectView *)createBlurViewWithFrame:(CGRect)frame{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = frame;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return blurEffectView;
}

+ (UIImageView *)returnTFImage:(NSString *)image andDimensions:(CGRect)frame
{
    UIImageView *imgforLeft=[[UIImageView alloc] initWithFrame:frame]; // Set frame as per space required around icon
    [imgforLeft setImage:[UIImage imageNamed:image]];
    
    [imgforLeft setContentMode:UIViewContentModeCenter];// Set content mode centre or fit
    
    return imgforLeft;
}

+(NSDictionary *)serverSideValidation:(NSDictionary *)response{
    NSString *title = @"";
    NSString *message = @"";
    NSDictionary *keys = [[NSDictionary alloc] init];
    
    switch ([[response objectForKey:@"code"] intValue]) {
        case 400:
            
            keys = [response objectForKey:@"errors"];
            break;
        
        case 401:
            
            break;
        
        case 402:
            title = @"Something Went Wrong";
            message = @"Please try again later";
            break;
        
        case 404:
            title = @"Something Went Wrong";
            message = @"Please try again later";
            break;
            
        case 409:
            title = @"Already Exists!";
            message = [NSString stringWithFormat:@"Wrong %@", [response objectForKey:@"key"]];
            break;
            
        default:
            break;
    }
    
    if([[response objectForKey:@"code"] intValue] == 400){
        if([keys count] > 0){
            message = @"Wrong in";
            title = @"Wrong Fields Provided";
            for (id key in keys) {
                if([[keys objectForKey:key] intValue] == 1)
                    message = [NSString stringWithFormat:@"%@ (%@)", message, key];
            }
        }
    }
    
    
    NSDictionary *returnDict = @{
                                 @"title" : title,
                                 @"message" : message
                                 };
    
    return  returnDict;
}


+(int)convertArabicNumber:(NSString *)numString{
    NSNumberFormatter *Formatter = [[NSNumberFormatter alloc] init];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"EN"];
    [Formatter setLocale:locale];
    NSNumber *newNum = [Formatter numberFromString:numString];
    
    int returnedEnglishNumber = [newNum intValue];
    return returnedEnglishNumber;
}

+(BOOL)checkAppVersion:(NSString *)appVersion andRemoteVersion:(NSString *)remoteVersion{
    return [appVersion isEqualToString:remoteVersion];
}

+(float)getBearing:(CLLocationCoordinate2D)locations1 andSecond:(CLLocationCoordinate2D)locattion2{
    float fLat = degreesToRadians(locations1.latitude);
    float fLng = degreesToRadians(locations1.longitude);
    float tLat = degreesToRadians(locattion2.latitude);
    float tLng = degreesToRadians(locattion2.longitude);
    
    float degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
    
    if (degree >= 0) {
        return degree;
    } else {
        return 360+degree;
    }
}
    
+ (NSString *)HEXFromDevicePushToken:(NSData *)data {
    
    NSUInteger capacity = data.length;
    NSMutableString *stringBuffer = [[NSMutableString alloc] initWithCapacity:capacity];
    const unsigned char *dataBuffer = data.bytes;
    
    // Iterate over the bytes
    for (NSUInteger i=0; i < data.length; i++) {
        
        [stringBuffer appendFormat:@"%02.2hhX", dataBuffer[i]];
    }
    
    return [stringBuffer copy];
}

+(BOOL)checkCoordinates:(NSDictionary *)data{
    BOOL valid = NO;
    if(data && ([data isKindOfClass:[NSDictionary class]])){
        if([data objectForKey:@"coordinates"]){
            if([[data objectForKey:@"coordinates"] isKindOfClass:[NSArray class]]){
                NSArray *coordinates = [data objectForKey:@"coordinates"];
                if([coordinates count] > 0){
                    valid = YES;
                }
            }
        }
    }
    return valid;
}

//+(double)distanceBetweenFirst:(CLLocation *)firstLocation andSecond:(CLLocation *)secondLocation{
//    
//    CLLocationCoordinate2D firstCoordinates= CLLocationCoordinate2DMake(firstLocation.coordinate.latitude, firstLocation.coordinate.longitude);
//    CLLocationCoordinate2D secondCoordinates= CLLocationCoordinate2DMake(secondLocation.coordinate.latitude, secondLocation.coordinate.longitude);
//    CLLocationDistance distance = GMSGeometryDistance(firstCoordinates, secondCoordinates);
//    if(distance){
//        return distance;
//    }else{
//        CLLocationDistance distance = [firstLocation distanceFromLocation:secondLocation];
//        return distance;
//    }
//}

+(float)angleFromCoordinate:(CLLocationCoordinate2D)first toCoordinate:(CLLocationCoordinate2D)second {
    
    float deltaLongitude = second.longitude - first.longitude;
    float deltaLatitude = second.latitude - first.latitude;
    float angle = (M_PI * .5f) - atan(deltaLatitude / deltaLongitude);
    
    if (deltaLongitude > 0)      return angle;
    else if (deltaLongitude < 0) return angle + M_PI;
    else if (deltaLatitude < 0)  return M_PI;
    
    return 0.0f;
}

@end
