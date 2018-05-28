//
//  CancelView.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/16/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "CancelView.h"

@implementation CancelView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self customInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)reasonsArray{
    self = [super initWithFrame:frame];
    cancelationReasonsArray = reasonsArray;
    if(self){
        [self customInit];
    }
    
    return self;
}


-(void)customInit{
    [[NSBundle mainBundle] loadNibNamed:@"CancelView" owner:self options:nil];
    [self addSubview:self.CONTENTVIEW];
    self.CONTENTVIEW.frame = self.bounds;
    NSLog(@"cancelationReasonsArray : %@", cancelationReasonsArray);
    UINib *cellNib = [UINib nibWithNibName:@"CancelationReasonsTableViewCell" bundle:nil];
    [_reasonsTableView registerNib:cellNib forCellReuseIdentifier:@"defaultCell"];
    [_reasonsTableView reloadData];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cancelationReasonsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"defaultcell";
    CancelationReasonsTableViewCell *cell = (CancelationReasonsTableViewCell *)[_reasonsTableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"CancelationReasonsTableViewCell" owner:self options:nil];
        cell = defaultCell;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.reasonLabel.text = [[cancelationReasonsArray objectAtIndex:indexPath.row] objectForKey:@"label"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedReason = [[cancelationReasonsArray objectAtIndex:indexPath.row] objectForKey:@"label"];
    CancelationReasonsTableViewCell *cell  = (CancelationReasonsTableViewCell *) [_reasonsTableView cellForRowAtIndexPath:indexPath];
    _checkImgView.center = CGPointMake(_checkImgView.center.x, cell.center.y + _reasonsTableView.frame.origin.y);
    [_checkImgView setHidden:NO];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (IBAction)submitBtnAction:(UIButton *)sender {
    if(selectedReason){
        if(selectedReason.length > 0){
            [[self delegate] cancelWithReason:selectedReason];
        }
    }
}

- (IBAction)dismissView:(UIButton *)sender {
    [self.delegate hideCancelView];
}
@end
