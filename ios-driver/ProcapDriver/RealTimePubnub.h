//
//  RealTimePubnub.h
//  Procap
//
//  Created by MacBookPro on 5/15/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <PubNub/PubNub.h>

#import "ServiceManager.h"
#import "HelperClass.h"


@protocol RealTimePubnubDelegate <NSObject>
@required
-(void)receivedMessageOnPupnub:(NSDictionary *)message;
@end

#define PUBNUB_SUBSCRIBE_ONLY_SUB_KEY @"sub-c-10e14b18-3947-11e7-b310-0619f8945a4f"     //SUBSCRIBE ONLY
#define PUBNUB_SUBSCRIBE_ONLY_PUB_KEY @"pub-c-69acf532-b740-4cb4-8ce0-deb7a2c57ca4"

#define PUBNUB_PUBLISH_ONLY_SUB_KEY @"sub-c-a64d88be-2fde-11e7-8f36-0619f8945a4f"      //PUBLISH ONLY
#define PUBNUB_PUBLISH_ONLY_PUB_KEY @"pub-c-79b1311e-caae-4dab-aba0-6a9c6edc8c24"


@interface RealTimePubnub : NSObject <PNObjectEventListener> {
    
}

@property (nonatomic, weak) id <RealTimePubnubDelegate> listnerDelegate;

@property (strong) PNConfiguration *configuration;
@property (nonatomic, strong) PubNub *client;

+(id)sharedManager:(BOOL)isOnRide;

- (id)initManager:(BOOL)isOnRide;

-(void)listenToChannelName:(NSString *)channelName;

-(void)endListening;
-(void)endListeningToChannel:(NSString *)channelName;

-(void)publishLocation:(NSDictionary *)parameters andChannelName:(NSString *)channelName;

@end
