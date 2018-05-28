//
//  ChooseWeekViewController.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/19/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "ChooseWeekViewController.h"

@interface ChooseWeekViewController ()

@end

@implementation ChooseWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"ChooseWeekTableViewCell" bundle:nil];
    [_weeksTableView registerNib:cellNib forCellReuseIdentifier:@"weekCell"];
    NSLog(@"weeksArray : %@", _weeksArray);
    _selectedWeekLabelLabel.text = _currentWeekTitle;
    [_weeksTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_weeksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *MyIdentifier = @"profitRideCell";
    ChooseWeekTableViewCell *cell = (ChooseWeekTableViewCell *)[_weeksTableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ChooseWeekTableViewCell" owner:self options:nil];
        cell = defaultCell;
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.weekLabel.text = [[_weeksArray objectAtIndex:indexPath.row] objectForKey:@"label"];
    
    if([[NSNumber numberWithInteger:indexPath.row] intValue] == (_weeksArray.count - 1))
        [cell.separatorView setHidden:YES];
    
    NSLog(@"_currentWeek : %@", _currentWeek);
    NSLog(@"_currentWeekTitle : %@", [_weeksArray objectAtIndex:indexPath.row]);
    if([[[_currentWeek objectForKey:@"day"] stringValue] isEqualToString:[[[_weeksArray objectAtIndex:indexPath.row] objectForKey:@"day"] stringValue]]){
        if([[[_currentWeek objectForKey:@"month"] stringValue] isEqualToString:[[[_weeksArray objectAtIndex:indexPath.row] objectForKey:@"month"] stringValue]]){
            if([[[_currentWeek objectForKey:@"year"] stringValue] isEqualToString:[[[_weeksArray objectAtIndex:indexPath.row] objectForKey:@"year"] stringValue]]){
                float x = _selectedImgView.center.x;
                if([[HelperClass getDeviceLanguage] isEqualToString:@"ar"])
                    x = 27;

                _selectedImgView.center = CGPointMake(x, ((47)*([[NSNumber numberWithInteger:indexPath.row] intValue] + 1)) + _weeksTableView.frame.origin.y - (47/2));
                [_selectedImgView setHidden:NO];
            }
        }
    }
    NSLog(@"cell.center.y + _weeksTableView.frame.origin.y : %f", cell.center.y + _weeksTableView.frame.origin.y);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseWeekTableViewCell *cell  = (ChooseWeekTableViewCell *) [_weeksTableView cellForRowAtIndexPath:indexPath];
    _selectedImgView.center = CGPointMake(_selectedImgView.center.x, cell.center.y + _weeksTableView.frame.origin.y);
    [_selectedImgView setHidden:NO];
    
    _currentWeekTitle = [[_weeksArray objectAtIndex:indexPath.row] objectForKey:@"label"];
    _selectedWeekLabelLabel.text = _currentWeekTitle;
    [[self delegate] chooseWeek:[_weeksArray objectAtIndex:indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
