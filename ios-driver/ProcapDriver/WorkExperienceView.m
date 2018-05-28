//
//  WorkExperienceView.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 9/13/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "WorkExperienceView.h"

@implementation WorkExperienceView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self customInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self customInit];
    }
    
    return self;
}

-(void)customInit{
    [[NSBundle mainBundle] loadNibNamed:@"WorkExperienceView" owner:self options:nil];
    [self addSubview:self.CONTENTVIEW];
    self.CONTENTVIEW.frame = self.bounds;
    
    _yesBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _noBtn.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (IBAction)noAction:(UIButton *)sender {
    [[self delegate] finishWorkExpWithAnswer:YES];
}

- (IBAction)hideMeAction:(UIButton *)sender {
    [self.delegate hideME];
}

- (IBAction)yesAction:(UIButton *)sender {
    [[self delegate] finishWorkExpWithAnswer:NO];
}
@end
