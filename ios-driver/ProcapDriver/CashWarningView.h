//
//  CashWarningView.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/16/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CashWarningViewDelegate <NSObject>
@required
-(void)hideWarningView;
@end

@interface CashWarningView : UIView {
    
}
@property (nonatomic, weak) id <CashWarningViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *CONTENTVIEW;

- (IBAction)doneBtnAction:(UIButton *)sender;
@end
