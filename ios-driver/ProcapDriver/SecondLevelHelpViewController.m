//
//  SecondLevelHelpViewController.m
//  Procap
//
//  Created by Mahmoud Amer on 8/3/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "SecondLevelHelpViewController.h"

@interface SecondLevelHelpViewController ()

@end

@implementation SecondLevelHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"SecondLevelHelpViewController with rideID : %@", _rideID);
    [_helpTableView reloadData];

    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_headerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _headerView.layer.shadowPath = shadowPath.CGPath;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_rideID.length > 0)
        _titleLabel.text = @"Report Trip";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_optionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"defaultcell";
    HelpTableViewCell *cell = (HelpTableViewCell *)[_helpTableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"HelpTableViewCell" owner:self options:nil];
        cell = defaultCell;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.reasonLabel.text = [[_optionArray objectAtIndex:indexPath.row] objectForKey:@"label"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == (_optionArray.count - 1))
        [cell.separatorView setHidden:YES];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[_optionArray objectAtIndex:indexPath.row] objectForKey:@"subitems"]){
        SecondLevelHelpViewController *controller = [[SecondLevelHelpViewController alloc] init];
        controller.optionArray = [[_optionArray objectAtIndex:indexPath.row] objectForKey:@"subitems"];
        if(_rideID && (_rideID.length > 0))
            controller.rideID = _rideID;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        SubmitHelpRequestViewController *controller = [[SubmitHelpRequestViewController alloc] init];
        controller.requestData = [_optionArray objectAtIndex:indexPath.row];
        if(_rideID && (_rideID.length > 0))
            controller.rideID = _rideID;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
