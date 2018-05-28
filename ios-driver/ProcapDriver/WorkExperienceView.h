//
//  WorkExperienceView.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 9/13/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WorkExperienceViewDelegate <NSObject>
@required
-(void)finishWorkExpWithAnswer:(BOOL)worked;
-(void)hideME;
@end


@interface WorkExperienceView : UIView {
    
}

@property (nonatomic, weak) id <WorkExperienceViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *CONTENTVIEW;

- (IBAction)hideMeAction:(UIButton *)sender;

- (IBAction)yesAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
- (IBAction)noAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *noBtn;
@end
