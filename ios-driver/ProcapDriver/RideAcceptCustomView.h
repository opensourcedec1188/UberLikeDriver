//
//  RideAcceptCustomView.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 6/22/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GMSGeocoder.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "RideClass.h"
#import "UIHelperClass.h"

@protocol RideAcceptCustomViewDelegate <NSObject>

@required
- (void)acceptRideRequest:(NSString *)rideID;
-(void)hideTabbar:(BOOL)show;
@end

@interface RideAcceptCustomView : UIView <GMSMapViewDelegate>{
    
    float drawProgrssFloat;
    int drawProgressTimeLimit;
    NSTimer *progressCircleTimer;
    
    BOOL newRequestTimingCounting;
    NSDictionary *rideParameters;
    
}
@property (nonatomic, weak) id <RideAcceptCustomViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *CONTENTVIEW;

@property (weak, nonatomic) IBOutlet UIView *bigAnimationView;
@property (weak, nonatomic) IBOutlet UIView *smallView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (strong, nonatomic) NSTimer *acceptRequestTimer;

@property (weak, nonatomic) IBOutlet UILabel *etaLabel;
@property (weak, nonatomic) IBOutlet UILabel *vehicleCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *surgeLabel;

- (IBAction)acceptRideAction:(UIButton *)sender;

-(instancetype)initWithFrame:(CGRect)frame andRideParameters:(NSDictionary *)rideParameters;

-(void)playSound;
-(void)stopSound;
- (void)finishedRequestRideTime;


@end
