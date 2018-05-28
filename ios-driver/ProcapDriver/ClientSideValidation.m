//
//  ClientSideValidation.m
//  ProcapDriver
//
//  Created by MacBookPro on 3/27/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "ClientSideValidation.h"
#import "HelperClass.h"


@implementation ClientSideValidation



+ (NSMutableDictionary *)validateFirstPersonalInfoData:(NSDictionary *)dataToValidate
{
    BOOL valid = YES;
    NSMutableDictionary *validationDetails = [[NSMutableDictionary alloc] init];
    NSLog(@"22 %@", [dataToValidate objectForKey:@"birthdate"]);
    if([HelperClass validatedates:[dataToValidate objectForKey:@"birthdate"]]){
        [validationDetails setObject:@"0" forKey:@"birthdate"];
    }else{
        [validationDetails setObject:@"1" forKey:@"birthdate"];
        valid = NO;
    }
    if([HelperClass validateEmailAddress:[dataToValidate objectForKey:@"email"]]){
        [validationDetails setObject:@"0" forKey:@"email"];
    }else{
        [validationDetails setObject:@"1" forKey:@"email"];
        valid = NO;
    }
    
    if([HelperClass validateText:[dataToValidate objectForKey:@"firstName"]]){
        [validationDetails setObject:@"0" forKey:@"firstName"];
    }else{
        [validationDetails setObject:@"1" forKey:@"firstName"];
        valid = NO;
    }

    if([HelperClass validateFLNames:[dataToValidate objectForKey:@"firstName"]]){
        [validationDetails setObject:@"0" forKey:@"firstName_chars"];
    }else{
        [validationDetails setObject:@"1" forKey:@"firstName_chars"];
        valid = NO;
    }
    
    if([HelperClass validateText:[dataToValidate objectForKey:@"lastName"]]){
        [validationDetails setObject:@"0" forKey:@"lastName"];
    }else{
        [validationDetails setObject:@"1" forKey:@"lastName"];
        valid = NO;
    }
    
    if([HelperClass validateFLNames:[dataToValidate objectForKey:@"lastName"]]){
        [validationDetails setObject:@"0" forKey:@"lastName_chars"];
    }else{
        [validationDetails setObject:@"1" forKey:@"lastName_chars"];
        valid = NO;
    }
    
    if([HelperClass validateText:[dataToValidate objectForKey:@"password"]]){
        [validationDetails setObject:@"0" forKey:@"password"];
    }else{
        [validationDetails setObject:@"1" forKey:@"password"];
        valid = NO;
    }
    if([HelperClass validateText:[dataToValidate objectForKey:@"passwordConfirmation"]]){
        [validationDetails setObject:@"0" forKey:@"passwordConfirmation"];
    }else{
        [validationDetails setObject:@"1" forKey:@"passwordConfirmation"];
        valid = NO;
    }
    if([HelperClass validateSSN:[dataToValidate objectForKey:@"ssn"]]){
        [validationDetails setObject:@"0" forKey:@"ssn"];
    }else{
        [validationDetails setObject:@"1" forKey:@"ssn"];
        valid = NO;
    }
    if([HelperClass validatedates:[dataToValidate objectForKey:@"ssnExpiry"]]){
        [validationDetails setObject:@"0" forKey:@"ssnExpiry"];
    }else{
        [validationDetails setObject:@"1" forKey:@"ssnExpiry"];
        valid = NO;
    }
    NSString *firstPass = [dataToValidate objectForKey:@"password"];
    NSString *secondPass = [dataToValidate objectForKey:@"passwordConfirmation"];
    
    if([firstPass isEqualToString:secondPass]){
        [validationDetails setObject:@"0" forKey:@"passwordsEquality"];
    }else{
        [validationDetails setObject:@"1" forKey:@"passwordsEquality"];
        valid = NO;
    }
    
    if(( firstPass.length >= 6) && ( firstPass.length <= 72 ) && ( secondPass.length >= 6) && ( secondPass.length <= 72 )){
        [validationDetails setObject:@"0" forKey:@"passwordLength"];
    }else{
        [validationDetails setObject:@"1" forKey:@"passwordLength"];
    }
    
    [validationDetails setObject:valid ? @"1" : @"0" forKey:@"isAllValid"];
    
    return validationDetails;
}

+ (NSMutableDictionary *)validateGeneralInfoData:(NSDictionary *)dataToValidate
{
    BOOL valid = YES;
    NSMutableDictionary *validationDetails = [[NSMutableDictionary alloc] init];
    
    if([HelperClass validateText:[dataToValidate objectForKey:@"city"]]){
        [validationDetails setObject:@"0" forKey:@"city"];
    }else{
        [validationDetails setObject:@"1" forKey:@"city"];
        valid = NO;
    }
    if([HelperClass validateText:[dataToValidate objectForKey:@"country"]]){
        [validationDetails setObject:@"0" forKey:@"country"];
    }else{
        [validationDetails setObject:@"1" forKey:@"country"];
        valid = NO;
    }
    
    if([HelperClass validateText:[dataToValidate objectForKey:@"dialCode"]]){
        [validationDetails setObject:@"0" forKey:@"dialCode"];
    }else{
        [validationDetails setObject:@"1" forKey:@"dialCode"];
        valid = NO;
    }
    
    if([HelperClass validateText:[dataToValidate objectForKey:@"district"]]){
        [validationDetails setObject:@"0" forKey:@"district"];
    }else{
        [validationDetails setObject:@"1" forKey:@"district"];
        valid = NO;
    }
    if([HelperClass validateText:[dataToValidate objectForKey:@"licenseExpiry"]]){
        [validationDetails setObject:@"0" forKey:@"licenseExpiry"];
    }else{
        [validationDetails setObject:@"1" forKey:@"licenseExpiry"];
        valid = NO;
    }
    if([HelperClass validateText:[dataToValidate objectForKey:@"language"]]){
        [validationDetails setObject:@"0" forKey:@"language"];
    }else{
        [validationDetails setObject:@"1" forKey:@"language"];
        valid = NO;
    }
    if([HelperClass validateText:[dataToValidate objectForKey:@"nationality"]]){
        [validationDetails setObject:@"0" forKey:@"nationality"];
    }else{
        [validationDetails setObject:@"1" forKey:@"nationality"];
        valid = NO;
    }
    if([HelperClass validateText:[dataToValidate objectForKey:@"street"]]){
        [validationDetails setObject:@"0" forKey:@"street"];
    }else{
        [validationDetails setObject:@"1" forKey:@"street"];
        valid = NO;
    }
    
    
    
    [validationDetails setObject:valid ? @"1" : @"0" forKey:@"isAllValid"];
    
    return validationDetails;
}

+ (NSMutableDictionary *) validateVehicleValidationRequest:(NSDictionary *)dataToValidate
{
    BOOL valid = YES;
    NSMutableDictionary *validationDetails = [[NSMutableDictionary alloc] init];
    
    if([HelperClass validateText:[dataToValidate objectForKey:@"manufacturer"]]){
        [validationDetails setObject:@"0" forKey:@"manufacturer"];
    }else{
        [validationDetails setObject:@"1" forKey:@"manufacturer"];
        valid = NO;
    }
    if([HelperClass validateText:[dataToValidate objectForKey:@"model"]]){
        [validationDetails setObject:@"0" forKey:@"model"];
    }else{
        [validationDetails setObject:@"1" forKey:@"model"];
        valid = NO;
    }
    
    if([HelperClass validateText:[dataToValidate objectForKey:@"year"]]){
        [validationDetails setObject:@"0" forKey:@"year"];
    }else{
        [validationDetails setObject:@"1" forKey:@"year"];
        valid = NO;
    }
    
    if([HelperClass validateText:[dataToValidate objectForKey:@"sequenceNumber"]]){
        [validationDetails setObject:@"0" forKey:@"sequenceNumber"];
    }else{
        [validationDetails setObject:@"1" forKey:@"sequenceNumber"];
        valid = NO;
    }
    
    if([HelperClass validateText:[dataToValidate objectForKey:@"plateLetters"]]){
        [validationDetails setObject:@"0" forKey:@"plateLetters"];
    }else{
        [validationDetails setObject:@"1" forKey:@"plateLetters"];
        valid = NO;
    }
    if([HelperClass validateText:[dataToValidate objectForKey:@"plateNumber"]]){
        [validationDetails setObject:@"0" forKey:@"plateNumber"];
    }else{
        [validationDetails setObject:@"1" forKey:@"plateNumber"];
        valid = NO;
    }
    if([HelperClass validatedates:[dataToValidate objectForKey:@"registrationExpiry"]]){
        [validationDetails setObject:@"0" forKey:@"registrationExpiry"];
    }else{
        [validationDetails setObject:@"1" forKey:@"registrationExpiry"];
        valid = NO;
    }
    if([HelperClass validateText:[dataToValidate objectForKey:@"sequenceNumber"]]){
        [validationDetails setObject:@"0" forKey:@"sequenceNumber"];
    }else{
        [validationDetails setObject:@"1" forKey:@"sequenceNumber"];
        valid = NO;
    }
    
    if([HelperClass validateText:[dataToValidate objectForKey:@"isOwnerSelected"]]){
        [validationDetails setObject:@"0" forKey:@"isOwnerSelected"];
    }else{
        [validationDetails setObject:@"1" forKey:@"isOwnerSelected"];
        valid = NO;
    }
    
    [validationDetails setObject:valid ? @"1" : @"0" forKey:@"isAllValid"];
    
    return validationDetails;
}

+ (NSMutableDictionary *) validateCompleteVehicleData:(NSDictionary *)dataToValidate
{
    BOOL valid = YES;
    NSMutableDictionary *validationDetails = [[NSMutableDictionary alloc] init];
    
    if([HelperClass validateText:[dataToValidate objectForKey:@"driverId"]]){
        [validationDetails setObject:@"0" forKey:@"driverId"];
    }else{
        [validationDetails setObject:@"1" forKey:@"driverId"];
        valid = NO;
    }
    
    if([HelperClass validateText:[dataToValidate objectForKey:@"insuranceExpiry"]]){
        [validationDetails setObject:@"0" forKey:@"insuranceExpiry"];
    }else{
        [validationDetails setObject:@"1" forKey:@"insuranceExpiry"];
        valid = NO;
    }
    
    if(!([[dataToValidate objectForKey:@"isOwner"] isEqualToString:@"true"])){
        if([HelperClass validatedates:[dataToValidate objectForKey:@"delegationOrLeaseExpiry"]]){
            [validationDetails setObject:@"0" forKey:@"delegationOrLeaseExpiry"];
        }else{
            [validationDetails setObject:@"1" forKey:@"delegationOrLeaseExpiry"];
            valid = NO;
        }
    }
    

    if([HelperClass validateText:[dataToValidate objectForKey:@"manufacturer"]]){
        [validationDetails setObject:@"0" forKey:@"manufacturer"];
    }else{
        [validationDetails setObject:@"1" forKey:@"manufacturer"];
        valid = NO;
    }
    if([HelperClass validatedates:[dataToValidate objectForKey:@"model"]]){
        [validationDetails setObject:@"0" forKey:@"model"];
    }else{
        [validationDetails setObject:@"1" forKey:@"model"];
        valid = NO;
    }
    if([HelperClass validateText:[dataToValidate objectForKey:@"plateLetters"]]){
        [validationDetails setObject:@"0" forKey:@"plateLetters"];
    }else{
        [validationDetails setObject:@"1" forKey:@"plateLetters"];
        valid = NO;
    }
    if([HelperClass validateText:[dataToValidate objectForKey:@"plateNumber"]]){
        [validationDetails setObject:@"0" forKey:@"plateNumber"];
    }else{
        [validationDetails setObject:@"1" forKey:@"plateNumber"];
        valid = NO;
    }
    if([HelperClass validatedates:[dataToValidate objectForKey:@"registrationExpiry"]]){
        [validationDetails setObject:@"0" forKey:@"registrationExpiry"];
    }else{
        [validationDetails setObject:@"1" forKey:@"registrationExpiry"];
        valid = NO;
    }
    if([HelperClass validateText:[dataToValidate objectForKey:@"sequenceNumber"]]){
        [validationDetails setObject:@"0" forKey:@"sequenceNumber"];
    }else{
        [validationDetails setObject:@"1" forKey:@"sequenceNumber"];
        valid = NO;
    }
    if([HelperClass validateText:[dataToValidate objectForKey:@"year"]]){
        [validationDetails setObject:@"0" forKey:@"year"];
    }else{
        [validationDetails setObject:@"1" forKey:@"year"];
        valid = NO;
    }
    
    
    [validationDetails setObject:valid ? @"1" : @"0" forKey:@"isAllValid"];
    
    return validationDetails;
}

@end
