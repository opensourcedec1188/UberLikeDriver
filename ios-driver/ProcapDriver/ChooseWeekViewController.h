//
//  ChooseWeekViewController.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/19/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseWeekTableViewCell.h"
#import "HelperClass.h"

@protocol ChooseWeekViewControllerDelegate <NSObject>
@required
-(void)chooseWeek:(NSDictionary *)week;
@end

@interface ChooseWeekViewController : UIViewController {
    
    IBOutlet ChooseWeekTableViewCell *defaultCell;
    
}
@property (nonatomic, weak) id <ChooseWeekViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *currentWeekTitle;
@property (nonatomic, strong) NSDictionary *currentWeek;
@property (nonatomic, strong) NSArray *weeksArray;

@property (weak, nonatomic) IBOutlet UILabel *selectedWeekLabelLabel;


@property (weak, nonatomic) IBOutlet UITableView *weeksTableView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImgView;


- (IBAction)dismissBtnAction:(UIButton *)sender;
@end
