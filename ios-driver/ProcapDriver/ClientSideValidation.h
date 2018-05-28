//
//  ClientSideValidation.h
//  ProcapDriver
//
//  Created by MacBookPro on 3/27/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientSideValidation : NSObject {
    
}


+ (NSMutableDictionary *)validateFirstPersonalInfoData:(NSDictionary *)dataToValidate;

+ (NSMutableDictionary *)validateGeneralInfoData:(NSDictionary *)dataToValidate;

+ (NSMutableDictionary *) validateVehicleValidationRequest:(NSDictionary *)dataToValidate;

+ (NSMutableDictionary *) validateCompleteVehicleData:(NSDictionary *)dataToValidate;

@end
