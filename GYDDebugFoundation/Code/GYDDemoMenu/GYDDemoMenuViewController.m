//
//  GYDDemoMenuViewController.m
//  GYDDevelopment
//
//  Created by gongyadong on 2022/8/16.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDDemoMenuViewController.h"
#import "GYDDemoMenuTreeView.h"
#import "GYDUIKit.h"

@implementation GYDDemoMenuViewController
{
    GYDDemoMenuTreeView *_menuView;
}

+ (UINavigationController *)createRootViewController {
    return [[UINavigationController alloc] initWithRootViewController:[[self alloc] init]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _menuView = [[GYDDemoMenuTreeView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_menuView];
    
    if (@available(iOS 11.0, *)) {
        _menuView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _menuView.frame = self.view.bounds;
    _menuView.contentInset = self.view.gyd_safeAreaInsets;
}

@end
