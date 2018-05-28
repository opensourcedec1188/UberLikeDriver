//
//  GoogleServicesManager.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 9/16/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "GoogleServicesManager.h"

@implementation GoogleServicesManager

+(void)getAddressFromCoordinates:(float)latitude andLong:(float)longitude :( void (^)(NSDictionary *))completion{
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(latitude, longitude)
                                   completionHandler:^(GMSReverseGeocodeResponse * response, NSError *error){
                                       NSString *pickupString;
                                       if(![response firstResult]){
                                           NSLog(@"here should put unknown location");
                                           pickupString = @"Unnamed Road";
                                       }else{
                                           if([[response firstResult] thoroughfare]){
                                               pickupString = [[response firstResult] thoroughfare];
                                           }else{
                                               pickupString = [NSString stringWithFormat:@"%@", [[[response firstResult] lines] componentsJoinedByString:@","]];
                                           }
                                       }
                                       NSDictionary *returnDicctionary = @{
                                                                           @"address" : pickupString,
                                                                           @"latitude" : [NSNumber numberWithFloat:[[response firstResult] coordinate].latitude],
                                                                           @"longitude" : [NSNumber numberWithFloat:[[response firstResult] coordinate].longitude]
                                                                           };
                                       completion(returnDicctionary);
                                   }];
}

+(void)getRouteFrom:(CLLocationCoordinate2D)fromLocation to:(CLLocationCoordinate2D)toLocation :( void (^)(NSDictionary *))completion{
    NSString *URLString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false&mode=driving&key=%@", fromLocation.latitude, fromLocation.longitude, toLocation.latitude, toLocation.longitude, GMS_SERVICE_KEY];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[HelperClass getDeviceLanguage] forHTTPHeaderField:@"X-Ego-Language"];
    
    [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion((NSDictionary *)responseObject);
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil);
    }];
}

+(void)snapCoordinates:(NSMutableArray *)coordinatesArray :( void (^)(NSDictionary *))completion {
    NSLog(@"should snap : %@", coordinatesArray);
    if([coordinatesArray count] > 0){
        NSString *coordinatesAsString = @"";
        int index = 0;
        for (NSDictionary *loc in coordinatesArray) {
            
            NSString *separator = (index == ([coordinatesArray count] - 1))? @"" : @"|";
            coordinatesAsString = [coordinatesAsString stringByAppendingString:[NSString stringWithFormat:@"%f,%f%@", [[loc objectForKey:@"latitude"] floatValue], [[loc objectForKey:@"longitude"] floatValue], separator]];
            index ++;
            if(index == 99)
                break;
        }
        NSString *URLString = [NSString stringWithFormat:@"https://roads.googleapis.com/v1/snapToRoads?path=%@&key=%@", coordinatesAsString, GMS_SNAPTOROAD_KEY];
        NSString *stringCleanPath = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        NSLog(@"snap Coordinates URLString : %@", stringCleanPath);
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:[ServiceManager getAccessTokenFromKeychain] forHTTPHeaderField:@"X-Access-Token"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager GET:stringCleanPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"snap Coordinates responseObject : %@", responseObject);
            BOOL done = YES;
            if(responseObject){
                if([responseObject objectForKey:@"snappedPoints"]){
                    NSArray *snappedPoints = [responseObject objectForKey:@"snappedPoints"];
                    if([snappedPoints count] > 0){
                        snappedPoints = [snappedPoints valueForKey:@"location"];
                        NSLog(@"final snap response : %@", snappedPoints);
                        float getAngle = 0;
                        if([snappedPoints count] > 1){
                            //add stable heading
                            CLLocationCoordinate2D firstCoordi = CLLocationCoordinate2DMake([[[snappedPoints lastObject] objectForKey:@"latitude"] floatValue], [[[snappedPoints lastObject] objectForKey:@"longitude"] floatValue]);
                            CLLocationCoordinate2D secondCoordi = CLLocationCoordinate2DMake([[[snappedPoints objectAtIndex:[snappedPoints count]-2] objectForKey:@"latitude"] floatValue], [[[snappedPoints objectAtIndex:[snappedPoints count]-2] objectForKey:@"longitude"] floatValue]);
                            getAngle = [HelperClass angleFromCoordinate:firstCoordi toCoordinate:secondCoordi];
                        }
                        completion(@{@"locations" : snappedPoints, @"heading" : [NSString stringWithFormat:@"%f", getAngle]});
                    }else
                        done = NO;
                }else
                    done = NO;
            }else
                done = NO;
            
            if(!done){
                completion(nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"snap Coordinates -- error: %@", error.localizedDescription);
            completion(nil);
        }];
    }else
        completion(nil);
    
}

@end
