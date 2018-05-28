//
//  AttachmentsView.h
//  ProcapDriver
//
//  Created by Mahmoud Amer on 9/13/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachmentsView : UIView

@property (strong, nonatomic) IBOutlet UIView *CONTENTVIEW;

@property (weak, nonatomic) IBOutlet UIView *dashedView;
@property (strong, nonatomic) CAShapeLayer *dashedViewBorder;
@end
