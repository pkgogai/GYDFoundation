//
//  GYDViewController.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/29.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDViewController.h"

@interface GYDViewController ()

@end

@implementation GYDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (@available(iOS 11.0, *)) {
        [self.view gyd_setSafeAreaInsets:self.view.safeAreaInsets];
    } else {
        [self.view gyd_setSafeAreaInsets:UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.hidesBottomBarWhenPushed ? 0 : self.bottomLayoutGuide.length, 0)];
        //如果在PUSH的时候隐藏TabBar，低版本self.bottomLayoutGuide.length没有及时更新，先用hidesBottomBarWhenPushed凑合判断一下，很快就全民11时代了。
    }
}

@end
