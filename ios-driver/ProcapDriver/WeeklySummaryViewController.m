//
//  WeeklySummaryViewController.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/19/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "WeeklySummaryViewController.h"

@interface WeeklySummaryViewController ()

@end

@implementation WeeklySummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_headerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _headerView.layer.shadowPath = shadowPath.CGPath;
    [self showLoadingView:YES];
    [self performSelectorInBackground:@selector(getWeeklyProfitBG:) withObject:nil];
    
    _firstWeekDayBtn.layer.cornerRadius = _firstWeekDayBtn.frame.size.height/2;
    _firstWeekDayBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _secondWeekBtn.layer.cornerRadius = _secondWeekBtn.frame.size.height/2;
    _secondWeekBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _thirdWeekBtn.layer.cornerRadius = _thirdWeekBtn.frame.size.height/2;
    _thirdWeekBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _forthWeekBtn.layer.cornerRadius = _forthWeekBtn.frame.size.height/2;
    _forthWeekBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UINib *cellNib = [UINib nibWithNibName:@"ProfitRidesTableViewCell" bundle:nil];
    [_ridesTableView registerNib:cellNib forCellReuseIdentifier:@"profitRideCell"];
    
    UINib *cellNib2 = [UINib nibWithNibName:@"FirstTableViewCell" bundle:nil];
    [_ridesTableView registerNib:cellNib2 forCellReuseIdentifier:@"firstCell"];
    
    darkColor = [UIColor colorWithRed:35.0/255.0f green:46.0/255.0f blue:66.0/255.0f alpha:1.0];
    whiteColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Requests
-(void)getWeeklyProfitBG:(NSDictionary *)parameters{
    @autoreleasepool {
        if(parameters){
            [EarningsServiceManager getWeeklyProfitWithParameters:parameters :^(NSDictionary *response){
                [self performSelectorOnMainThread:@selector(finishGetWeklyProfit:) withObject:response waitUntilDone:NO];
            }];
        }else{
            [EarningsServiceManager getWeeklyProfit :^(NSDictionary *response){
                [self performSelectorOnMainThread:@selector(finishGetWeklyProfit:) withObject:response waitUntilDone:NO];
            }];
        }
        
    }
}

-(void)finishGetWeklyProfit:(NSDictionary *)response{
    [self showLoadingView:NO];
    NSLog(@"finishGetWeklyProfit response : %@", response);
    if(response){
        if([response objectForKey:@"data"]){
            if([[response objectForKey:@"data"] objectForKey:@"months"])
                monthsArray = [[response objectForKey:@"data"] objectForKey:@"months"];
            if([[response objectForKey:@"data"] objectForKey:@"weeks"]){
                weeksArray = [[response objectForKey:@"data"] objectForKey:@"weeks"];
                [self displayDatesOnWeeks];
                [self displayWeeksSignalOnOff];
            }
            
            if([[response objectForKey:@"data"] objectForKey:@"currentMonth"]){
                currentMonthDictionary = [[response objectForKey:@"data"] objectForKey:@"currentMonth"];
                [_periodBtn setTitle:[currentMonthDictionary objectForKey:@"label"] forState:UIControlStateNormal];
            }
            
            if([[response objectForKey:@"data"] objectForKey:@"currentWeek"]){
                currentWeekDictionary = [[response objectForKey:@"data"] objectForKey:@"currentWeek"];
                currentWeekIndex = [[currentWeekDictionary objectForKey:@"index"] intValue];
                [self displayCurrentWeekData];
            }
            
            if([[response objectForKey:@"data"] objectForKey:@"currentWeekRides"]){
                currentRidesArray = [[response objectForKey:@"data"] objectForKey:@"currentWeekRides"];
                [_ridesTableView reloadData];
                if([currentRidesArray count] > 0){
                    [_noRidesLabel setHidden:YES];
                }else
                    [_noRidesLabel setHidden:NO];
            }
        }
    }
}

#pragma mark - Get Rides
-(void)getWeekRidesBG:(NSDictionary *)params{
    @autoreleasepool {
        [EarningsServiceManager getWeeklyRides:params ? params : nil :^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishGetWeekRides:) withObject:response waitUntilDone:NO];
        }];
    }
}

-(void)finishGetWeekRides:(NSDictionary *)response{
    [self showLoadingView:NO];
    NSLog(@"finishGetWeekRides : %@", response);
    if(response){
        if([response objectForKey:@"data"]){
            [self displayCurrentWeekData];
            currentRidesArray = [response objectForKey:@"data"];
            [_ridesTableView reloadData];
            if([currentRidesArray count] > 0){
                [_noRidesLabel setHidden:YES];
            }else
                [_noRidesLabel setHidden:NO];
        }
    }
}

#pragma mark - Data Display Functions
-(void)displayDatesOnWeeks{
    [_firstWeekDayBtn setTitle:[[weeksArray objectAtIndex:0] objectForKey:@"value"] forState:UIControlStateNormal];
    _firstWeekLabel.text = [[weeksArray objectAtIndex:0] objectForKey:@"label"];
    [_secondWeekBtn setTitle:[[weeksArray objectAtIndex:1] objectForKey:@"value"] forState:UIControlStateNormal];
    _secondWeekLabel.text = [[weeksArray objectAtIndex:1] objectForKey:@"label"];
    [_thirdWeekBtn setTitle:[[weeksArray objectAtIndex:2] objectForKey:@"value"] forState:UIControlStateNormal];
    _thirdWeekLabel.text = [[weeksArray objectAtIndex:2] objectForKey:@"label"];
    [_forthWeekBtn setTitle:[[weeksArray objectAtIndex:3] objectForKey:@"value"] forState:UIControlStateNormal];
    _forthWeekLabel.text = [[weeksArray objectAtIndex:3] objectForKey:@"label"];
}

-(void)displayWeeksSignalOnOff{
    if([[[weeksArray objectAtIndex:0] objectForKey:@"profit"] doubleValue] < 1)
        [_firstWeekSignalView setBackgroundColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f]];
    else
        [_firstWeekSignalView setBackgroundColor:[UIColor colorWithRed:17.0/255.0f green:255.0/255.0f blue:189.0/255.0f alpha:1.0f]];
    
    if([[[weeksArray objectAtIndex:1] objectForKey:@"profit"] doubleValue] < 1)
        [_secondWeekSignalView setBackgroundColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f]];
    else
        [_secondWeekSignalView setBackgroundColor:[UIColor colorWithRed:17.0/255.0f green:255.0/255.0f blue:189.0/255.0f alpha:1.0f]];
    
    if([[[weeksArray objectAtIndex:2] objectForKey:@"profit"] doubleValue] < 1)
        [_thirdWeekSignalView setBackgroundColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f]];
    else
        [_thirdWeekSignalView setBackgroundColor:[UIColor colorWithRed:17.0/255.0f green:255.0/255.0f blue:189.0/255.0f alpha:1.0f]];
    
    if([[[weeksArray objectAtIndex:3] objectForKey:@"profit"] doubleValue] < 1)
        [_forthWeekSignalView setBackgroundColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f]];
    else
        [_forthWeekSignalView setBackgroundColor:[UIColor colorWithRed:17.0/255.0f green:255.0/255.0f blue:189.0/255.0f alpha:1.0f]];
}

-(void)displayCurrentWeekData{
    switch (currentWeekIndex) {
        case 0:
            [self disableAllWeeksExcept:_firstWeekDayBtn];
            break;
        case 1:
            [self disableAllWeeksExcept:_secondWeekBtn];
            break;
        case 2:
            [self disableAllWeeksExcept:_thirdWeekBtn];
            break;
        case 3:
            [self disableAllWeeksExcept:_forthWeekBtn];
            break;
        default:
            break;
    }
}

-(void)disableAllWeeksExcept:(UIButton *)btn{
    
    [_firstWeekDayBtn setBackgroundColor:[UIColor clearColor]];
    [_firstWeekDayBtn setTitleColor:whiteColor forState:UIControlStateNormal];
    
    [_secondWeekBtn setBackgroundColor:[UIColor clearColor]];
    [_secondWeekBtn setTitleColor:whiteColor forState:UIControlStateNormal];
    
    [_thirdWeekBtn setBackgroundColor:[UIColor clearColor]];
    [_thirdWeekBtn setTitleColor:whiteColor forState:UIControlStateNormal];
    
    [_forthWeekBtn setBackgroundColor:[UIColor clearColor]];
    [_forthWeekBtn setTitleColor:whiteColor forState:UIControlStateNormal];
    
    [btn setBackgroundColor:whiteColor];
    [btn setTitleColor:darkColor forState:UIControlStateNormal];
}


#pragma mark - Actions

- (IBAction)periodBtnAction:(UIButton *)sender {
    ChooseWeekViewController *controller = [[ChooseWeekViewController alloc] init];
    controller.weeksArray = monthsArray;
    controller.delegate = self;
    controller.currentWeekTitle = [currentMonthDictionary objectForKey:@"label"];
    controller.currentWeek = currentMonthDictionary;
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)chooseWeek:(NSDictionary *)week{
    NSLog(@"will choose week : %@", week);
    NSString *day = [[week objectForKey:@"day"] stringValue];
    NSString *month = [[week objectForKey:@"month"] stringValue];
    NSString *year = [[week objectForKey:@"year"] stringValue];
    NSDictionary *params = @{@"day" : day, @"month" : month, @"year" : year};
    [self showLoadingView:YES];
    [self performSelectorInBackground:@selector(getWeeklyProfitBG:) withObject:params];
//    [self getWeeklyProfitBG:params];
}


- (IBAction)firstWeekBtnAction:(UIButton *)sender {
    currentWeekIndex = 0;
    currentWeekDictionary = [weeksArray objectAtIndex:0];
    NSString *day = [[[weeksArray objectAtIndex:0] objectForKey:@"day"] stringValue];
    NSString *month = [[[weeksArray objectAtIndex:0] objectForKey:@"month"] stringValue];
    NSString *year = [[[weeksArray objectAtIndex:0] objectForKey:@"year"] stringValue];
    NSDictionary *params = @{@"day" : day, @"month" : month, @"year" : year};
    [self requestWeekDataAndRides:params];
}
- (IBAction)secondWeekBtnAction:(UIButton *)sender {
    currentWeekIndex = 1;
    currentWeekDictionary = [weeksArray objectAtIndex:1];
    NSString *day = [[[weeksArray objectAtIndex:1] objectForKey:@"day"] stringValue];
    NSString *month = [[[weeksArray objectAtIndex:1] objectForKey:@"month"] stringValue];
    NSString *year = [[[weeksArray objectAtIndex:1] objectForKey:@"year"] stringValue];
    NSDictionary *params = @{@"day" : day, @"month" : month, @"year" : year};
    [self requestWeekDataAndRides:params];
}
- (IBAction)thirdWeekBtnAction:(UIButton *)sender {
    currentWeekIndex = 2;
    currentWeekDictionary = [weeksArray objectAtIndex:2];
    NSString *day = [[[weeksArray objectAtIndex:2] objectForKey:@"day"] stringValue];
    NSString *month = [[[weeksArray objectAtIndex:2] objectForKey:@"month"] stringValue];
    NSString *year = [[[weeksArray objectAtIndex:2] objectForKey:@"year"] stringValue];
    NSDictionary *params = @{@"day" : day, @"month" : month, @"year" : year};
    [self requestWeekDataAndRides:params];
}
- (IBAction)forthWeekBtnAction:(UIButton *)sender {
    currentWeekIndex = 3;
    currentWeekDictionary = [weeksArray objectAtIndex:3];
    NSLog(@"currentWeekDictionary : %@", currentWeekDictionary);
    NSString *day = [[[weeksArray objectAtIndex:3] objectForKey:@"day"] stringValue];
    NSString *month = [[[weeksArray objectAtIndex:3] objectForKey:@"month"] stringValue];
    NSString *year = [[[weeksArray objectAtIndex:3] objectForKey:@"year"] stringValue];
    NSDictionary *params = @{@"day" : day, @"month" : month, @"year" : year};
    [self requestWeekDataAndRides:params];
}

-(void)requestWeekDataAndRides:(NSDictionary *)params{
    [self showLoadingView:YES];
    [self performSelectorInBackground:@selector(getWeekRidesBG:) withObject:params];
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Tableview
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row > 0)
        return 61;
    else
        return 238;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([currentRidesArray count] > 0)
        return ([currentRidesArray count]) + 1;
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row > 0){
        static NSString *MyIdentifier = @"profitRideCell";
        ProfitRidesTableViewCell *cell = (ProfitRidesTableViewCell *)[_ridesTableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if(cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ProfitRidesTableViewCell" owner:self options:nil];
            cell = defaultCell;
        }
        [cell.separatorView setHidden:NO];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.timeLabel.text = [[currentRidesArray objectAtIndex:indexPath.row - 1] objectForKey:@"time"];
        cell.categoryLabel.text = [NSString stringWithFormat:@"%@ %@", [[[currentRidesArray objectAtIndex:indexPath.row - 1] objectForKey:@"totalTrips"] stringValue], NSLocalizedString(@"x_trips", @"")];
        if(!([[[currentRidesArray objectAtIndex:indexPath.row - 1] objectForKey:@"profit"] isKindOfClass:[NSNull class]]))
            cell.fareLabel.text = [[[currentRidesArray objectAtIndex:indexPath.row - 1] objectForKey:@"profit"] stringValue];
        
        if([[NSNumber numberWithInteger:indexPath.row - 1] intValue] == (currentRidesArray.count - 1))
            [cell.separatorView setHidden:YES];
        
        return cell;
    }else{
        static NSString *MyIdentifier = @"firstCell";
        FirstTableViewCell *cell = (FirstTableViewCell *)[_ridesTableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if(cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"FirstTableViewCell" owner:self options:nil];
            cell = firstCell;
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"currentWeekIndex : %i", currentWeekIndex);
        cell.profitTitleLabel.text = NSLocalizedString(@"this_week_profit_sar", @"");
        
        cell.dayProfitLabel.text = [[[weeksArray objectAtIndex:currentWeekIndex] objectForKey:@"profit"] stringValue];
        
        cell.collectedCashLabel.text = [[[weeksArray objectAtIndex:currentWeekIndex] objectForKey:@"cashCollected"] stringValue];
        
        cell.totalTripsLabel.text = [[[weeksArray objectAtIndex:currentWeekIndex] objectForKey:@"totalTrips"] stringValue];
        
        
        if(([[weeksArray objectAtIndex:currentWeekIndex] objectForKey:@"timeOnline"]) && !([[[weeksArray objectAtIndex:currentWeekIndex] objectForKey:@"timeOnline"] isKindOfClass:[NSNull class]]))
            cell.dayTimeOnlineLabel.text = [NSString stringWithFormat:@"%@:%@", [[[weeksArray objectAtIndex:currentWeekIndex] objectForKey:@"timeOnline"] objectForKey:@"hours"], [[[weeksArray objectAtIndex:currentWeekIndex] objectForKey:@"timeOnline"] objectForKey:@"minutes"]];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row > 0){
        NSLog(@"will select row : %@", [currentRidesArray objectAtIndex:indexPath.row - 1]);
        NSDictionary *selectedDayRides = [currentRidesArray objectAtIndex:indexPath.row - 1];
        if(selectedDayRides){
            if(([selectedDayRides objectForKey:@"day"]) && ([selectedDayRides objectForKey:@"month"]) && ([selectedDayRides objectForKey:@"year"])){
                DailySummaryViewController *controller = [[DailySummaryViewController alloc] init];
                NSDictionary *params = @{@"day" : [selectedDayRides objectForKey:@"day"], @"month" : [selectedDayRides objectForKey:@"month"],@"year" : [selectedDayRides objectForKey:@"year"]};
                controller.parametersFromWeekly = params;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }
}

#pragma mark - LoadingView
-(void)showLoadingView:(BOOL)show{
    if(show){
        loadingView = [[UIView alloc] initWithFrame:self.parentViewController.view.bounds];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.alpha = 0.9;
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
        indicator.center = loadingView.center;
        [indicator startAnimating];
        indicator.color = [UIColor whiteColor];
        [loadingView addSubview:indicator];
        [self.view addSubview:loadingView];
        [self.view bringSubviewToFront:loadingView];
    }else{
        [loadingView removeFromSuperview];
    }
}
@end
