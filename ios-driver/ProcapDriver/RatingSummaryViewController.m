//
//  RatingSummaryViewController.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/20/17.
//  Copyright © 2017 Amer. All rights reserved.
//
#import "RatingSummaryViewController.h"

@interface RatingSummaryViewController ()

@end

@implementation RatingSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    driverData = [ServiceManager getDriverDataFromUserDefaults];
    
    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_headerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _headerView.layer.shadowPath = shadowPath.CGPath;
    
    [self displayData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self displayRatingPercentageWithGradient];
}

-(void)displayData{
    _totalTripsLabel.text = [[driverData objectForKey:@"totalTrips"] stringValue];
    _tripsRatedLabel.text = [[driverData objectForKey:@"tripsRated"] stringValue];
    _canceledTripLabel.text = [[driverData objectForKey:@"canceledTrips"] stringValue];
    _acceptedTripsLabel.text = [[driverData objectForKey:@"acceptedTrips"] stringValue];
}

-(void)displayRatingPercentageWithGradient{
    NSLog(@"driverData : %@", driverData);
    fiveStarRated = ([[driverData objectForKey:@"ratingsWith5Stars"] doubleValue] / [[driverData objectForKey:@"tripsRated"] doubleValue])*100;
    fourStarRated = ([[driverData objectForKey:@"ratingsWith4Stars"] doubleValue] / [[driverData objectForKey:@"tripsRated"] doubleValue])*100;
    threeStarRated = ([[driverData objectForKey:@"ratingsWith3Stars"] doubleValue] / [[driverData objectForKey:@"tripsRated"] doubleValue])*100;
    twoStarRated = ([[driverData objectForKey:@"ratingsWith2Stars"] doubleValue] / [[driverData objectForKey:@"tripsRated"] doubleValue])*100;
    onseStarRated = ([[driverData objectForKey:@"ratingsWith1Stars"] doubleValue] / [[driverData objectForKey:@"tripsRated"] doubleValue])*100;
    
    [UIView animateWithDuration:1.0 delay: 0.0 options: UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         if([[driverData objectForKey:@"ratingsWith5Stars"] doubleValue] > 0){
                             _fiveStarView.frame = CGRectMake(0, 0, (fiveStarRated/100)*_fiveStarContainerView.frame.size.width, _fiveStarContainerView.frame.size.height);
                             CAGradientLayer *fiveGradient = [self createGradient];
                             fiveGradient.frame = _fiveStarView.bounds;
                             [_fiveStarView.layer insertSublayer:fiveGradient atIndex:0];
                             _fiveStarPercentageLabel.text = [NSString stringWithFormat:@"%i%@", [[NSNumber numberWithFloat:fiveStarRated] intValue], @"%"];
                         }
                         
                         if([[driverData objectForKey:@"ratingsWith4Stars"] doubleValue] > 0){
                             _fourStarView.frame = CGRectMake(0, 0, (fourStarRated/100)*_fourStarContainerView.frame.size.width, _fourStarContainerView.frame.size.height);
                             CAGradientLayer *fourGradient = [self createGradient];
                             fourGradient.frame = _fourStarView.bounds;
                             [_fourStarView.layer insertSublayer:fourGradient atIndex:0];
                             _fourStarPercentageLabel.text = [NSString stringWithFormat:@"%i%@", [[NSNumber numberWithFloat:fourStarRated] intValue], @"%"];
                         }
                         
                         if([[driverData objectForKey:@"ratingsWith3Stars"] doubleValue] > 0){
                             _threeStarView.frame = CGRectMake(0, 0, (threeStarRated/100)*_threeStarContainerView.frame.size.width, _threeStarContainerView.frame.size.height);
                             CAGradientLayer *threeGradient = [self createGradient];
                             threeGradient.frame = _threeStarView.bounds;
                             [_threeStarView.layer insertSublayer:threeGradient atIndex:0];
                             _threeStarPercentageLabel.text = [NSString stringWithFormat:@"%i%@", [[NSNumber numberWithFloat:threeStarRated] intValue], @"%"];
                         }
                         
                         if([[driverData objectForKey:@"ratingsWith2Stars"] doubleValue] > 0){
                             _twoStarView.frame = CGRectMake(0, 0, (twoStarRated/100)*_twoStarContainerView.frame.size.width, _twoStarContainerView.frame.size.height);
                             CAGradientLayer *twoGradient = [self createGradient];
                             twoGradient.frame = _twoStarView.bounds;
                             [_twoStarView.layer insertSublayer:twoGradient atIndex:0];
                             _twoStarPercentageLabel.text = [NSString stringWithFormat:@"%i%@", [[NSNumber numberWithFloat:twoStarRated] intValue], @"%"];
                         }
                         
                         if([[driverData objectForKey:@"ratingsWith1Stars"] doubleValue] > 0){
                             _oneStarView.frame = CGRectMake(0, 0, (onseStarRated/100)*_oneStarContainerView.frame.size.width, _oneStarContainerView.frame.size.height);
                             CAGradientLayer *oneGradient = [self createGradient];
                             oneGradient.frame = _oneStarView.bounds;
                             [_oneStarView.layer insertSublayer:oneGradient atIndex:0];
                             _onseStarPercentageLabel.text = [NSString stringWithFormat:@"%i%@", [[NSNumber numberWithFloat:onseStarRated] intValue], @"%"];
                         }
                     } completion:^(BOOL finished){}];
}

-(CAGradientLayer *)createGradient{
    CAGradientLayer *mainGradient = [CAGradientLayer layer];
    mainGradient.colors = [NSArray arrayWithObjects: (id)[UIColor colorWithRed:17.0/255.0f green:255.0/255.0f blue:189.0/255.0f alpha:1.0f].CGColor, (id)[UIColor colorWithRed:177.0/255.0f green:255.0/255.0f blue:169.0/255.0f alpha:1.0f].CGColor, nil];
    mainGradient.startPoint = CGPointMake(0.0, 0.5);
    mainGradient.endPoint = CGPointMake(1.0, 0.5);
    
    NSArray *fromColors = mainGradient.colors;
    NSArray *toColors = [NSArray arrayWithObjects: (id)[UIColor colorWithRed:17.0/255.0f green:255.0/255.0f blue:189.0/255.0f alpha:1.0f].CGColor, (id)[UIColor colorWithRed:177.0/255.0f green:255.0/255.0f blue:169.0/255.0f alpha:1.0f].CGColor, nil];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    
    animation.fromValue             = fromColors;
    animation.toValue               = toColors;
    animation.duration              = 3.00;
    animation.removedOnCompletion   = YES;
    animation.fillMode              = kCAFillModeForwards;
    animation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    animation.delegate              = self;
    
    // Add the animation to our layer
    
    [mainGradient addAnimation:animation forKey:@"animateGradient"];
    return mainGradient;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
