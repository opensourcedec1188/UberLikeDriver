//
//  CancelView.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/16/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CancelationReasonsTableViewCell.h"

@protocol  CancelViewDelegate <NSObject>
@required
-(void)cancelWithReason:(NSString *)reason;
-(void)hideCancelView;
@end

@interface CancelView : UIView {
    NSArray *cancelationReasonsArray;
    IBOutlet CancelationReasonsTableViewCell *defaultCell;
    NSString *selectedReason;
}


@property (nonatomic, weak) id <CancelViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *CONTENTVIEW;

@property (weak, nonatomic) IBOutlet UITableView *reasonsTableView;
@property (weak, nonatomic) IBOutlet UIImageView *checkImgView;

-(instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)reasonsArray;
- (IBAction)submitBtnAction:(UIButton *)sender;
- (IBAction)dismissView:(UIButton *)sender;

@end
