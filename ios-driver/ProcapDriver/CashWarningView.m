//
//  CashWarningView.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/16/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "CashWarningView.h"

@implementation CashWarningView

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
    [[NSBundle mainBundle] loadNibNamed:@"CashWarningView" owner:self options:nil];
    [self addSubview:self.CONTENTVIEW];
    self.CONTENTVIEW.frame = self.bounds;
}

- (IBAction)doneBtnAction:(UIButton *)sender {
    [[self delegate] hideWarningView];
}
@end
