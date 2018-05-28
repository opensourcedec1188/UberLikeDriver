//
//  BalanceTransactionsViewController.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/20/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "BalanceTransactionsViewController.h"

@interface BalanceTransactionsViewController ()

@end

@implementation BalanceTransactionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_headerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _headerView.layer.shadowPath = shadowPath.CGPath;
    [self showLoadingView:YES];
    [self performSelectorInBackground:@selector(getTransactionsBG) withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  Transactions Request
-(void)getTransactionsBG{
    @autoreleasepool {
        [EarningsServiceManager getTransactions :^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishGetTransactions:) withObject:response waitUntilDone:NO];
        }];
    }
}

-(void)finishGetTransactions:(NSDictionary *)response{
    [self showLoadingView:NO];
    if(response){
        if([response objectForKey:@"balance"]){
            _balanceLabel.text = [NSString stringWithFormat:@"%.2f", [[response objectForKey:@"balance"] floatValue]];
        }

        if([response objectForKey:@"data"]){
            transactionsArray = [response objectForKey:@"data"];
            [_balanceTableView reloadData];
        }
    }
}

#pragma mark - Tableview
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [transactionsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"profitRideCell";
    BalanceCustomTableViewCell *cell = (BalanceCustomTableViewCell *)[_balanceTableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"BalanceCustomTableViewCell" owner:self options:nil];
        cell = defaultCell;
    }
    [cell.rightArrowImageView setHidden:NO];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tripFareLabel.layer.cornerRadius = 6;
    if([[[transactionsArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"ride"]){
        cell.tripDateLabel.text = [[transactionsArray objectAtIndex:indexPath.row] objectForKey:@"time"];
        cell.categoryLabel.text = [[transactionsArray objectAtIndex:indexPath.row] objectForKey:@"category"];
        cell.tripFareLabel.text = [[[transactionsArray objectAtIndex:indexPath.row] objectForKey:@"profit"] stringValue];
        cell.settlmentLabel.text = [[[transactionsArray objectAtIndex:indexPath.row] objectForKey:@"settlement"] stringValue];
        [cell.rightArrowImageView setHidden:NO];
    }else{
        cell.tripDateLabel.text = [[transactionsArray objectAtIndex:indexPath.row] objectForKey:@"time"];
        cell.tripFareLabel.text = [[[transactionsArray objectAtIndex:indexPath.row] objectForKey:@"amount"] stringValue];
        cell.categoryLabel.text = [[transactionsArray objectAtIndex:indexPath.row] objectForKey:@"type"];
        [cell.rightArrowImageView setHidden:YES];
    }
    
    
    if([[NSNumber numberWithInteger:indexPath.row] intValue] == (transactionsArray.count - 1))
        [cell.separatorView setHidden:YES];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[[transactionsArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"ride"]){
        RideProfitDetailsViewController *controller = [[RideProfitDetailsViewController alloc] init];
        controller.RideID = [[transactionsArray objectAtIndex:indexPath.row] objectForKey:@"_id"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma mark - LoadingView
-(void)showLoadingView:(BOOL)show{
    if(show){
        loadingView = [[UIView alloc] initWithFrame:self.parentViewController.view.bounds];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.alpha = 0.5;
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
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
