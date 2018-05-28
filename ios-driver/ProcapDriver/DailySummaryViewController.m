//
//  DailySummaryViewController.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/17/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "DailySummaryViewController.h"

@interface DailySummaryViewController ()

@end

@implementation DailySummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_headerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _headerView.layer.shadowPath = shadowPath.CGPath;
    
    _satDayBtn.layer.cornerRadius = _satDayBtn.frame.size.height/2;
    _satDayBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _sunDayBtn.layer.cornerRadius = _sunDayBtn.frame.size.height/2;
    _sunDayBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _monDayBtn.layer.cornerRadius = _monDayBtn.frame.size.height/2;
    _monDayBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _tuDayBtn.layer.cornerRadius = _tuDayBtn.frame.size.height/2;
    _tuDayBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _wedDayBtn.layer.cornerRadius = _wedDayBtn.frame.size.height/2;
    _wedDayBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _thurDayBtn.layer.cornerRadius = _thurDayBtn.frame.size.height/2;
    _thurDayBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _friDayBtn.layer.cornerRadius = _friDayBtn.frame.size.height/2;
    _friDayBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UINib *cellNib = [UINib nibWithNibName:@"ProfitRidesTableViewCell" bundle:nil];
    [_ridesTableView registerNib:cellNib forCellReuseIdentifier:@"profitRideCell"];
    
    UINib *cellNib2 = [UINib nibWithNibName:@"FirstTableViewCell" bundle:nil];
    [_ridesTableView registerNib:cellNib2 forCellReuseIdentifier:@"firstCell"];
    
    darkColor = [UIColor colorWithRed:35.0/255.0f green:46.0/255.0f blue:66.0/255.0f alpha:1.0];
    whiteColor = [UIColor whiteColor];
    
    [self showLoadingView:YES];
    [self performSelectorInBackground:@selector(getDailyProfitBG:) withObject:_parametersFromWeekly ? _parametersFromWeekly : nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Requests
-(void)getDailyProfitBG:(NSDictionary *)parameters{
    @autoreleasepool {
        [EarningsServiceManager getDailyProfit:parameters ? parameters : nil :^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishGetDailyProfit:) withObject:response waitUntilDone:NO];
        }];
    }
}

-(void)finishGetDailyProfit:(NSDictionary *)response{
    [self showLoadingView:NO];
    NSLog(@"finishGetDailyProfit response : %@", response);
    if(response){
        if([response objectForKey:@"data"]){
            NSDictionary *fullDataDictionary = [response objectForKey:@"data"];
            currentWeekDictionary = [fullDataDictionary objectForKey:@"currentWeek"];
            if([fullDataDictionary objectForKey:@"weeks"])
                weeksArray = [fullDataDictionary objectForKey:@"weeks"];
            if([fullDataDictionary objectForKey:@"days"]){
                weekDays = [fullDataDictionary objectForKey:@"days"];
                [self displayDatesOnDays];
                [self displayDaysSignalOnOff];
            }
            if([fullDataDictionary objectForKey:@"currentDay"]){
                currentDayDataDictionary = [fullDataDictionary objectForKey:@"currentDay"];
                currentDayIndex = [[currentDayDataDictionary objectForKey:@"index"] intValue];
                [self displayCurrentDayData];
            }
            if([fullDataDictionary objectForKey:@"currentDayRides"]){
                currentRidesArray = [fullDataDictionary objectForKey:@"currentDayRides"];
                [_ridesTableView reloadData];
                if([currentRidesArray count] > 0){
                    [_noRidesLabel setHidden:YES];
                }else
                    [_noRidesLabel setHidden:NO];
            }
            if([fullDataDictionary objectForKey:@"currentWeek"]){
                currentWeekDictionary = [fullDataDictionary objectForKey:@"currentWeek"];
                [_periodBtn setTitle:[currentWeekDictionary objectForKey:@"label"] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - Get Rides
-(void)getDayRidesBG:(NSDictionary *)params{
    @autoreleasepool {
        [EarningsServiceManager getDayRides:params :^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishGetDayRides:) withObject:response waitUntilDone:NO];
        }];
    }
}

-(void)finishGetDayRides:(NSDictionary *)response{
    [self showLoadingView:NO];
    NSLog(@"finishGetDayRides : %@", response);
    if(response){
        if([response objectForKey:@"data"]){
            [self displayCurrentDayData];
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
-(void)displayDatesOnDays{
    [_sunDayBtn setTitle:[[[weekDays objectAtIndex:0] objectForKey:@"value"] stringValue] forState:UIControlStateNormal];
    [_monDayBtn setTitle:[[[weekDays objectAtIndex:1] objectForKey:@"value"] stringValue] forState:UIControlStateNormal];
    [_tuDayBtn setTitle:[[[weekDays objectAtIndex:2] objectForKey:@"value"] stringValue] forState:UIControlStateNormal];
    [_wedDayBtn setTitle:[[[weekDays objectAtIndex:3] objectForKey:@"value"] stringValue] forState:UIControlStateNormal];
    [_thurDayBtn setTitle:[[[weekDays objectAtIndex:4] objectForKey:@"value"] stringValue] forState:UIControlStateNormal];
    [_friDayBtn setTitle:[[[weekDays objectAtIndex:5] objectForKey:@"value"] stringValue] forState:UIControlStateNormal];
    [_satDayBtn setTitle:[[[weekDays objectAtIndex:6] objectForKey:@"value"] stringValue] forState:UIControlStateNormal];
}

-(void)displayDaysSignalOnOff{
    if([[[weekDays objectAtIndex:0] objectForKey:@"profit"] doubleValue] < 1)
        [_suSignalView setBackgroundColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f]];
    else
        [_suSignalView setBackgroundColor:[UIColor colorWithRed:17.0/255.0f green:255.0/255.0f blue:189.0/255.0f alpha:1.0f]];
    
    if([[[weekDays objectAtIndex:1] objectForKey:@"profit"] doubleValue] < 1)
        [_monSignalView setBackgroundColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f]];
    else
        [_monSignalView setBackgroundColor:[UIColor colorWithRed:17.0/255.0f green:255.0/255.0f blue:189.0/255.0f alpha:1.0f]];
    
    if([[[weekDays objectAtIndex:2] objectForKey:@"profit"] doubleValue] < 1)
        [_tuSignalView setBackgroundColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f]];
    else
        [_tuSignalView setBackgroundColor:[UIColor colorWithRed:17.0/255.0f green:255.0/255.0f blue:189.0/255.0f alpha:1.0f]];
    
    if([[[weekDays objectAtIndex:3] objectForKey:@"profit"] doubleValue] < 1)
        [_wedSignalView setBackgroundColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f]];
    else
        [_wedSignalView setBackgroundColor:[UIColor colorWithRed:17.0/255.0f green:255.0/255.0f blue:189.0/255.0f alpha:1.0f]];
    
    if([[[weekDays objectAtIndex:4] objectForKey:@"profit"] doubleValue] < 1)
        [_thurSignalView setBackgroundColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f]];
    else
        [_thurSignalView setBackgroundColor:[UIColor colorWithRed:17.0/255.0f green:255.0/255.0f blue:189.0/255.0f alpha:1.0f]];
    
    if([[[weekDays objectAtIndex:5] objectForKey:@"profit"] doubleValue] < 1)
        [_friSignalView setBackgroundColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f]];
    else
        [_friSignalView setBackgroundColor:[UIColor colorWithRed:17.0/255.0f green:255.0/255.0f blue:189.0/255.0f alpha:1.0f]];
    
    if([[[weekDays objectAtIndex:6] objectForKey:@"profit"] doubleValue] < 1)
        [_satSignalView setBackgroundColor:[UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f]];
    else
        [_satSignalView setBackgroundColor:[UIColor colorWithRed:17.0/255.0f green:255.0/255.0f blue:189.0/255.0f alpha:1.0f]];
}

-(void)displayCurrentDayData{
    switch (currentDayIndex) {
        case 0:
            [self disableAllDaysExcept:_sunDayBtn];
            break;
        case 1:
            [self disableAllDaysExcept:_monDayBtn];
            break;
        case 2:
            [self disableAllDaysExcept:_tuDayBtn];
            break;
        case 3:
            [self disableAllDaysExcept:_wedDayBtn];
            break;
        case 4:
            [self disableAllDaysExcept:_thurDayBtn];
            break;
        case 5:
            [self disableAllDaysExcept:_friDayBtn];
            break;
        case 6:
            [self disableAllDaysExcept:_satDayBtn];
            break;
        default:
            break;
    }
}

-(void)disableAllDaysExcept:(UIButton *)btn{
    
    [_sunDayBtn setBackgroundColor:[UIColor clearColor]];
    [_sunDayBtn setTitleColor:whiteColor forState:UIControlStateNormal];
    
    [_monDayBtn setBackgroundColor:[UIColor clearColor]];
    [_monDayBtn setTitleColor:whiteColor forState:UIControlStateNormal];
    
    [_tuDayBtn setBackgroundColor:[UIColor clearColor]];
    [_tuDayBtn setTitleColor:whiteColor forState:UIControlStateNormal];
    
    [_wedDayBtn setBackgroundColor:[UIColor clearColor]];
    [_wedDayBtn setTitleColor:whiteColor forState:UIControlStateNormal];
    
    [_thurDayBtn setBackgroundColor:[UIColor clearColor]];
    [_thurDayBtn setTitleColor:whiteColor forState:UIControlStateNormal];
    
    [_friDayBtn setBackgroundColor:[UIColor clearColor]];
    [_friDayBtn setTitleColor:whiteColor forState:UIControlStateNormal];
    
    [_satDayBtn setBackgroundColor:[UIColor clearColor]];
    [_satDayBtn setTitleColor:whiteColor forState:UIControlStateNormal];
    
    [btn setBackgroundColor:whiteColor];
    [btn setTitleColor:darkColor forState:UIControlStateNormal];
}


#pragma mark - Actions

- (IBAction)periodBtnAction:(UIButton *)sender {
    ChooseWeekViewController *controller = [[ChooseWeekViewController alloc] init];
    controller.weeksArray = weeksArray;
    controller.delegate = self;
    
    NSLog(@"llllabel : %@", currentWeekDictionary);
    controller.currentWeekTitle = [currentWeekDictionary objectForKey:@"label"];
    controller.currentWeek = currentWeekDictionary;
    [self presentViewController:controller animated:YES completion:nil];
}
#pragma mark - Come with new week
-(void)chooseWeek:(NSDictionary *)week{
    NSLog(@"will choose week : %@", week);
    NSString *day = [[week objectForKey:@"day"] stringValue];
    NSString *month = [[week objectForKey:@"month"] stringValue];
    NSString *year = [[week objectForKey:@"year"] stringValue];
    NSDictionary *params = @{@"day" : day, @"month" : month, @"year" : year};
    [self showLoadingView:YES];
    [self performSelectorInBackground:@selector(getDailyProfitBG:) withObject:params];
}

#pragma mark - Choose Day Btns Action
- (IBAction)sunDayBtnAction:(UIButton *)sender {
    currentDayIndex = 0;
    currentDayDataDictionary = [weekDays objectAtIndex:0];
    NSString *day = [[[weekDays objectAtIndex:0] objectForKey:@"value"] stringValue];
    NSString *month = [[currentWeekDictionary objectForKey:@"month"] stringValue];
    NSString *year = [[currentWeekDictionary objectForKey:@"year"] stringValue];
    NSDictionary *params = @{@"day" : day, @"month" : month, @"year" : year};
    [self requestDayDataAndRides:params];
}
- (IBAction)monDayBtnAction:(UIButton *)sender {
    currentDayIndex = 1;
    currentDayDataDictionary = [weekDays objectAtIndex:1];
    NSString *day = [[[weekDays objectAtIndex:1] objectForKey:@"value"] stringValue];
    NSString *month = [[currentWeekDictionary objectForKey:@"month"] stringValue];
    NSString *year = [[currentWeekDictionary objectForKey:@"year"] stringValue];
    NSDictionary *params = @{@"day" : day, @"month" : month, @"year" : year};
    [self requestDayDataAndRides:params];
}
- (IBAction)tuDayBtnAction:(UIButton *)sender {
    currentDayIndex = 2;
    currentDayDataDictionary = [weekDays objectAtIndex:2];
    NSString *day = [[[weekDays objectAtIndex:2] objectForKey:@"value"] stringValue];
    NSString *month = [[currentWeekDictionary objectForKey:@"month"] stringValue];
    NSString *year = [[currentWeekDictionary objectForKey:@"year"] stringValue];
    NSDictionary *params = @{@"day" : day, @"month" : month, @"year" : year};
    [self requestDayDataAndRides:params];
}
- (IBAction)wedDayBtnAction:(UIButton *)sender {
    currentDayIndex = 3;
    currentDayDataDictionary = [weekDays objectAtIndex:3];
    NSString *day = [[[weekDays objectAtIndex:3] objectForKey:@"value"] stringValue];
    NSString *month = [[currentWeekDictionary objectForKey:@"month"] stringValue];
    NSString *year = [[currentWeekDictionary objectForKey:@"year"] stringValue];
    NSDictionary *params = @{@"day" : day, @"month" : month, @"year" : year};
    [self requestDayDataAndRides:params];
}
- (IBAction)thurDayBtnAction:(UIButton *)sender {
    currentDayIndex = 4;
    currentDayDataDictionary = [weekDays objectAtIndex:4];
    NSString *day = [[[weekDays objectAtIndex:4] objectForKey:@"value"] stringValue];
    NSString *month = [[currentWeekDictionary objectForKey:@"month"] stringValue];
    NSString *year = [[currentWeekDictionary objectForKey:@"year"] stringValue];
    NSDictionary *params = @{@"day" : day, @"month" : month, @"year" : year};
    [self requestDayDataAndRides:params];
}
- (IBAction)friDayBtnAction:(UIButton *)sender  {
    currentDayIndex = 5;
    currentDayDataDictionary = [weekDays objectAtIndex:5];
    NSString *day = [[[weekDays objectAtIndex:5] objectForKey:@"value"] stringValue];
    NSString *month = [[currentWeekDictionary objectForKey:@"month"] stringValue];
    NSString *year = [[currentWeekDictionary objectForKey:@"year"] stringValue];
    NSDictionary *params = @{@"day" : day, @"month" : month, @"year" : year};
    [self requestDayDataAndRides:params];
}
- (IBAction)satDayBtnAction:(UIButton *)sender {
    currentDayIndex = 6;
    currentDayDataDictionary = [weekDays objectAtIndex:6];
    NSString *day = [[[weekDays objectAtIndex:6] objectForKey:@"value"] stringValue];
    NSString *month = [[currentWeekDictionary objectForKey:@"month"] stringValue];
    NSString *year = [[currentWeekDictionary objectForKey:@"year"] stringValue];
    NSDictionary *params = @{@"day" : day, @"month" : month, @"year" : year};
    [self requestDayDataAndRides:params];
}

-(void)requestDayDataAndRides:(NSDictionary *)params{
    [self showLoadingView:YES];
    [self performSelectorInBackground:@selector(getDayRidesBG:) withObject:params];
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
        cell.categoryLabel.text = [[currentRidesArray objectAtIndex:indexPath.row - 1] objectForKey:@"category"];
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

        cell.dayProfitLabel.text = [[[weekDays objectAtIndex:currentDayIndex] objectForKey:@"profit"] stringValue];
        
        cell.collectedCashLabel.text = [[[weekDays objectAtIndex:currentDayIndex] objectForKey:@"cashCollected"] stringValue];
        
        cell.totalTripsLabel.text = [[[weekDays objectAtIndex:currentDayIndex] objectForKey:@"totalTrips"] stringValue];
        
        if(([[weekDays objectAtIndex:currentDayIndex] objectForKey:@"timeOnline"]) && !([[[weekDays objectAtIndex:currentDayIndex] objectForKey:@"timeOnline"] isKindOfClass:[NSNull class]]))
            cell.dayTimeOnlineLabel.text = [NSString stringWithFormat:@"%@:%@", [[[weekDays objectAtIndex:currentDayIndex] objectForKey:@"timeOnline"] objectForKey:@"hours"], [[[weekDays objectAtIndex:currentDayIndex] objectForKey:@"timeOnline"] objectForKey:@"minutes"]];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row > 0){
        RideProfitDetailsViewController *controller = [[RideProfitDetailsViewController alloc] init];
        controller.RideID = [[currentRidesArray objectAtIndex:indexPath.row - 1] objectForKey:@"_id"];
        [self.navigationController pushViewController:controller animated:YES];
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
