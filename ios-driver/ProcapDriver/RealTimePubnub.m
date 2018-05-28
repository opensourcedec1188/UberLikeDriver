//
//  RealTimePubnub.m
//  Procap
//
//  Created by MacBookPro on 5/15/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "RealTimePubnub.h"

@implementation RealTimePubnub

+(id)sharedManager:(BOOL)publishObject
{
    NSLog(@"sharedManager initialized");
    static RealTimePubnub *sharedMyManager;
    @synchronized(self) {
        if (sharedMyManager == nil){
            NSString *subscribeKey = PUBNUB_SUBSCRIBE_ONLY_SUB_KEY;
            NSString *publishKey = PUBNUB_SUBSCRIBE_ONLY_PUB_KEY;
            if(publishObject){
                subscribeKey = PUBNUB_PUBLISH_ONLY_SUB_KEY;
                publishKey = PUBNUB_PUBLISH_ONLY_PUB_KEY;
            }
            NSLog(@"sharedManager Keys : %@ /// %@", publishKey, subscribeKey);
            sharedMyManager = [[self alloc] init:subscribeKey andPublishKey:publishKey];
        }
    }
    return sharedMyManager;
}
    
- (id)init:(NSString *)subscribeKey andPublishKey:(NSString *)publishKey {
    if (self = [super init]) {
        self.configuration = [PNConfiguration configurationWithPublishKey:publishKey subscribeKey:subscribeKey];
        self.configuration.uuid = [NSString stringWithFormat:@"driver-%@", [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]];//[NSUUID UUID].UUIDString.lowercaseString;
        
        NSLog(@"(Pusher replacement )accesstoke : %@", [ServiceManager getAccessTokenFromKeychain]);
        self.configuration.authKey = [ServiceManager getAccessTokenFromKeychain];
        self.client = [PubNub clientWithConfiguration:self.configuration];
        [self.client addListener:self];
        [self.client subscribeToChannels: @[[NSString stringWithFormat:@"drivers-%@", [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]]] withPresence:NO];
    }
    return self;
}

- (id)initManager:(BOOL)publishObject {
    if (self = [super init]) {
        NSString *subscribeKey = PUBNUB_SUBSCRIBE_ONLY_SUB_KEY;
        NSString *publishKey = PUBNUB_SUBSCRIBE_ONLY_PUB_KEY;
        if(publishObject){
            subscribeKey = PUBNUB_PUBLISH_ONLY_SUB_KEY;
            publishKey = PUBNUB_PUBLISH_ONLY_PUB_KEY;
        }
        NSLog(@"initManager Keys : %@ /// %@", publishKey, subscribeKey);
        
        self.configuration = [PNConfiguration configurationWithPublishKey:publishKey subscribeKey:subscribeKey];
        self.configuration.uuid = [NSString stringWithFormat:@"driver-%@", [[ServiceManager getDriverDataFromUserDefaults] objectForKey:@"_id"]];//[NSUUID UUID].UUIDString.lowercaseString;
        self.configuration.authKey = [ServiceManager getAccessTokenFromKeychain];
        self.client = [PubNub clientWithConfiguration:self.configuration];
    }
    return self;
}

-(void)listenToChannelName:(NSString *)channelName{
    NSLog(@"will listen to channel %@", channelName);
    [self.client subscribeToChannels: @[channelName] withPresence:NO];
    [self.client addListener:self];
}


-(void)endListening{
    [self.client unsubscribeFromAll];
}

- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
    NSLog(@"-- Pubnub -- message received : %@", message);
    NSLog(@"-- Pubnub -- message received / Data : %@", message.data);
    // Handle new message stored in message.data.message
    if (![message.data.channel isEqualToString:message.data.subscription]) {
        
        // Message has been received on channel group stored in message.data.subscription.
    }
    else {
        
        // Message has been received on channel stored in message.data.channel.
    }
    
    [[self listnerDelegate] receivedMessageOnPupnub:message.data.message];
    
}

-(void)endListeningToChannel:(NSString *)channelName{
    [self.client unsubscribeFromChannels:@[channelName] withPresence:NO];
}

-(void)publishLocation:(NSDictionary *)parameters andChannelName:(NSString *)channelName{
    NSLog(@"publishLocation : %@ on channel name : %@", parameters, channelName);
    [self.client publish:parameters toChannel:channelName storeInHistory:YES
          withCompletion:^(PNPublishStatus *status) {
              if (!status.isError) {
                  NSLog(@"Publish Location Message Sent :)");
                  // Message successfully published to specified channel.
              }else {
                  NSLog(@"Publish Location Message Not Sent :(((");
                  PNErrorStatus *errorStatus = (PNErrorStatus *)status;
                  NSLog(@"errorStatue : %@", errorStatus.description.localizedUppercaseString);
                  if (errorStatus.category == PNAccessDeniedCategory) {
                      NSLog(@"PNAccessDeniedCategory");
                      /**
                       This means that PAM does allow this client to subscribe to this channel and channel group
                       configuration. This is another explicit error.
                       */
                  }else {
                      NSLog(@"NOT PNAccessDeniedCategory");
                      /**
                       More errors can be directly specified by creating explicit cases for other error categories
                       of `PNStatusCategory` such as: `PNDecryptionErrorCategory`,
                       `PNMalformedFilterExpressionCategory`, `PNMalformedResponseCategory`, `PNTimeoutCategory`
                       or `PNNetworkIssuesCategory`
                       */
                  }
              }
          }];
}

@end
