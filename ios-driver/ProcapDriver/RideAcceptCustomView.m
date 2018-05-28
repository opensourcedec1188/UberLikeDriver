//
//  RideAcceptCustomView.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 6/22/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "RideAcceptCustomView.h"

@implementation RideAcceptCustomView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self customInit:nil];
    }
    
    return self;
}

- (IBAction)acceptRideAction:(UIButton *)sender {
    [[self delegate] hideTabbar:YES];
    [self stopSound];
    [[self delegate] acceptRideRequest:[rideParameters objectForKey:@"rideId"]];
}

-(instancetype)initWithFrame:(CGRect)frame andRideParameters:(NSDictionary *)rideParameterDict{
    self = [super initWithFrame:frame];
    if(self){
        [self customInit:rideParameterDict];
    }
    
    return self;
}

-(void)customInit:(NSDictionary *)rideParams{
    [[NSBundle mainBundle] loadNibNamed:@"RideAcceptCustomView" owner:self options:nil];
    [self addSubview:self.CONTENTVIEW];
    self.CONTENTVIEW.frame = self.bounds;
    
    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_smallView edgeInset:UIEdgeInsetsMake(-1.0f, -1.0f, -1.0f, -1.0f) andShadowRadius:5.0f];
    _smallView.layer.shadowPath = shadowPath.CGPath;

    UIBezierPath *shadowPath2 = [UIHelperClass setViewShadow:_containerView edgeInset:UIEdgeInsetsMake(-1.0f, -1.0f, -1.0f, -1.0f) andShadowRadius:5.0f];
    _containerView.layer.shadowPath = shadowPath2.CGPath;
    
    long long now = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    long long expiry = [[rideParams objectForKey:@"expiry"] longValue];
    long long differ = expiry - now;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 4.0f);
    _progressView.transform = transform;
    
    differ = differ/1000.0;
    if(differ > 0){
        
        rideParameters = rideParams;
        int intDifference = [[NSNumber numberWithDouble:differ] intValue];
        
        [self startNewRideRequestTimer:intDifference];
        
        drawProgrssFloat = 0;
        drawProgressTimeLimit = intDifference;
        [progressCircleTimer invalidate];
        progressCircleTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                               target:self
                                                             selector:@selector(drawProgress)
                                                             userInfo:nil
                                                              repeats:YES];
                
        [self playSound];
        
        if([rideParams objectForKey:@"eta"])
            self.etaLabel.text = [NSString stringWithFormat:@"%@", [[rideParams objectForKey:@"eta"] stringValue]];
        
        self.vehicleCategoryLabel.text = [rideParams objectForKey:@"category"];
        self.distanceLabel.text = [NSString stringWithFormat:@"%@", [[rideParams objectForKey:@"distance"] stringValue]];
        self.surgeLabel.text = [NSString stringWithFormat:@"%@X", [[rideParams objectForKey:@"surgeFactor"] stringValue]];
    }
    [self animateView];
    
}

-(void)drawProgress{
    
    drawProgrssFloat = drawProgrssFloat + 1;
    
    [_progressView setProgress:1 - (drawProgrssFloat / drawProgressTimeLimit) animated:YES];
    if(drawProgrssFloat >= drawProgressTimeLimit){
        [progressCircleTimer invalidate];
    }
}


#pragma mark - 15 seconds timer start
-(void)startNewRideRequestTimer:(NSTimeInterval)seconds{
    newRequestTimingCounting = YES;
    [self.acceptRequestTimer invalidate];
    self.acceptRequestTimer = [NSTimer scheduledTimerWithTimeInterval:seconds
                                                               target:self
                                                             selector:@selector(finishedRequestRideTime)
                                                             userInfo:nil
                                                              repeats:NO];
}

- (void)finishedRequestRideTime
{
    [[self delegate] hideTabbar:YES];
    [self stopSound];
    
    newRequestTimingCounting = NO;
    [self removeFromSuperview];
}

-(void)playSound{
    [self stopSound];
    if((![_audioPlayer isPlaying]) && !_audioPlayer){
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"new_request_sound"
                                                                  ofType:@"mp3"];
        if(soundFilePath){
            
            NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
            _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
            _audioPlayer.numberOfLoops = -1; //Infinite
            [_audioPlayer play];
        }
    }
}
-(void)stopSound{
    [_audioPlayer stop];
    _audioPlayer = nil;
}

-(void)animateView{
    NSLog(@"animation");
    float initialY = _bigAnimationView.frame.origin.y;
    [UIView animateWithDuration:0.4f
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         _bigAnimationView.frame = CGRectMake(_bigAnimationView.frame.origin.x, _bigAnimationView.frame.origin.y - 50, _bigAnimationView.frame.size.width, _bigAnimationView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.4f
                                               delay: 0.0
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              _bigAnimationView.frame = CGRectMake(_bigAnimationView.frame.origin.x, initialY, _bigAnimationView.frame.size.width, _bigAnimationView.frame.size.height);
                                          }
                                          completion:^(BOOL finished){
                                              if(self.window)
                                                  [self animateView];
                                          }];
                     }];
}

@end
