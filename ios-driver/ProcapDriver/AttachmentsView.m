//
//  AttachmentsView.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 9/13/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "AttachmentsView.h"

@implementation AttachmentsView

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
    [[NSBundle mainBundle] loadNibNamed:@"AttachmentsView" owner:self options:nil];
    [self addSubview:self.CONTENTVIEW];
    self.CONTENTVIEW.frame = self.bounds;
    
    _dashedViewBorder = [CAShapeLayer layer];
    _dashedViewBorder.strokeColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:0.5f].CGColor;
    _dashedViewBorder.lineDashPattern = @[@4, @3];
    _dashedViewBorder.cornerRadius = 4;
    CGRect shapeRect = _dashedView.bounds;
    [_dashedViewBorder setBounds:shapeRect];
    [_dashedViewBorder setPosition:CGPointMake( _dashedView.frame.size.width/2,_dashedView.frame.size.height/2)];
    _dashedViewBorder.path = [UIBezierPath bezierPathWithRect:shapeRect].CGPath;
    _dashedViewBorder.fillColor = [UIColor clearColor].CGColor;
    [_dashedView.layer addSublayer:_dashedViewBorder];
    
}

- (void)layoutSubviews {
    [super layoutSubviews]; //if you want superclass's behaviour...  (and lay outing of children)
    // resize your layers based on the view's new frame
    _dashedViewBorder.frame = _dashedView.bounds;
}

@end
