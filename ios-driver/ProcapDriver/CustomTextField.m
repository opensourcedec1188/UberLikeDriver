//
//  CustomTextField.m
//  ProcapDriver
//
//  Created by MacBookPro on 4/15/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (void)deleteBackward
{
    NSLog(@"delete");
    NSLog(@"Length: %d", (int)self.text.length);
    [self.customTFDelegate handleDelete:self];
    [super deleteBackward];
}

@end
