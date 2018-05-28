//
//  NewsViewController.m
//  ProcapDriver
//
//  Created by Mahmoud Amer on 8/15/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.frame.size.width, 728);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.frame.size.width, 728);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
