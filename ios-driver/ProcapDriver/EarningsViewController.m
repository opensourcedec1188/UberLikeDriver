//
//  EarningsViewController.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/15/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "EarningsViewController.h"

@interface EarningsViewController ()

@end

@implementation EarningsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    driverData = [ServiceManager getDriverDataFromUserDefaults];
    _mainSegment.layer.cornerRadius = 9.0;
    _mainSegment.layer.borderColor = [UIColor whiteColor].CGColor;
    _mainSegment.layer.borderWidth = 1.0f;
    _mainSegment.layer.masksToBounds = YES;
    
    CGRect frame= _mainSegment.frame;
    [_mainSegment setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 35.0f)];

}

-(void)viewWillAppear:(BOOL)animated{
    [self displayData:0];
    [self displayQuestsData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.frame.size.width, 649);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayData:(int)selectedIndex{
    _balanceLabel.text = [NSString stringWithFormat:@"%@", [[driverData objectForKey:@"balance"] stringValue]];
    if(selectedIndex == 0){
        _profitValueLabel.text = [NSString stringWithFormat:@"%.2f", [[driverData objectForKey:@"thisDayProfit"] floatValue]];
        _cashCollectedLabel.text = [NSString stringWithFormat:@"%@", [[driverData objectForKey:@"thisDayCashCollected"] stringValue]];
        _totalTripsLabel.text = [NSString stringWithFormat:@"%@", [[driverData objectForKey:@"thisDayTotalTrips"] stringValue]];
    }else{
        _profitValueLabel.text = [NSString stringWithFormat:@"%.2f", [[driverData objectForKey:@"thisWeekProfit"] floatValue]];
        _cashCollectedLabel.text = [NSString stringWithFormat:@"%@", [[driverData objectForKey:@"thisWeekCashCollected"] stringValue]];
        _totalTripsLabel.text = [NSString stringWithFormat:@"%@", [[driverData objectForKey:@"thisWeekTotalTrips"] stringValue]];
    }
}

-(void)displayQuestsData{
    float questsProgress = ([[driverData objectForKey:@"thisWeekTotalTrips"] doubleValue] / [[NSNumber numberWithInt:30] doubleValue])*100;
    _completedTripsLabel.text = [NSString stringWithFormat:@"%i %@", [[driverData objectForKey:@"thisWeekTotalTrips"] intValue], NSLocalizedString(@"x_trips_completed", @"")];
    if([[driverData objectForKey:@"thisWeekTotalTrips"] intValue] < 30)
        _remainingTripsLabel.text = [NSString stringWithFormat:@"%i %@", (30 - [[driverData objectForKey:@"thisWeekTotalTrips"] intValue]), NSLocalizedString(@"x_trips", @"")];
    else
        _remainingTripsLabel.text = @"";
    
    [UIView animateWithDuration:1.0 delay: 0.0 options: UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         _questsProgressView.frame = CGRectMake(0, 0, (questsProgress/30)*100, _questsContainerView.frame.size.height);
                     } completion:^(BOOL finished){}];
    _questsContainerView.clipsToBounds = YES;
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

- (IBAction)ToggleMainSegment:(UISegmentedControl *)sender {
    selectedProfitType = [[NSNumber numberWithInteger:sender.selectedSegmentIndex] intValue];
    [self displayData:[[NSNumber numberWithInteger:sender.selectedSegmentIndex] intValue]];
    if(selectedProfitType == 0)
        _profitTitleLabel.text = NSLocalizedString(@"this_day_profit", @"");
    else
        _profitTitleLabel.text = NSLocalizedString(@"this_week_profit", @"");
}

- (IBAction)invitationsBtnAction:(UIButton *)sender {
    [self.delegate goToInvitation];
}

- (IBAction)openProfitDetailsAction:(UIButton *)sender {
    [self.delegate goToProfitSummary:selectedProfitType];
}

- (IBAction)openBalanceDetailsAction:(UIButton *)sender {
    [self.delegate goToBalance];
}

@end
