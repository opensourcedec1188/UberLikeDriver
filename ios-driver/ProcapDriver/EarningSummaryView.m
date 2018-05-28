//
//  EarningSummaryView.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/16/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "EarningSummaryView.h"

@implementation EarningSummaryView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self customInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self customInit];
    }
    
    return self;
}

-(void)customInit{
    [[NSBundle mainBundle] loadNibNamed:@"EarningSummaryView" owner:self options:nil];
    [self addSubview:self.CONTENTVIEW];
    self.CONTENTVIEW.frame = self.bounds;
    
    driverData = [ServiceManager getDriverDataFromUserDefaults];
    _totalEarningsLabel.text = [[driverData objectForKey:@"thisDayProfit"] stringValue];
    _cashCollectedLabel.text = [[driverData objectForKey:@"thisDayCashCollected"] stringValue];
    _totalTripsLabel.text = [[driverData objectForKey:@"thisDayTotalTrips"] stringValue];
    _balanceLabel.text = [[driverData objectForKey:@"balance"] stringValue];
    [self displayQuestsData];
    
    if(_totalEarningsLabel.text.length > 0){
        if(_totalEarningsLabel.text.length <= 5)
            _totalEarningsLabel.font = [UIFont fontWithName:FONT_ROBOTO_BOLD size:60.0f];
        else
            _totalEarningsLabel.font = [UIFont fontWithName:FONT_ROBOTO_BOLD size:45.0f];
    }
}

-(void)displayQuestsData{
    NSLog(@"driver data : %@", driverData);
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
}

- (IBAction)doneAction:(UIButton *)sender {
    [[self delegate] hideEarningSummary];
}
@end
