//
//  GYDSafeAreaExampleViewController.m
//  iOSExample
//
//  Created by 宫亚东 on 2018/10/31.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDSafeAreaExampleViewController.h"
#import "UIView+GYDSafeArea.h"

@interface GYDSafeAreaExampleViewController ()

@end

@implementation GYDSafeAreaExampleViewController
{
    UIView *_view1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _view1 = nil;//懒得写了
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (@available(iOS 11.0, *)) {
    } else {
        [self.view gyd_setSafeAreaInsets:UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0)];
        //如果在PUSH的时候隐藏TabBar，低版本self.bottomLayoutGuide.length没有及时更新，所以可以改用 bottom = self.hidesBottomBarWhenPushed ? 0 : self.bottomLayoutGuide.length
    }
    
    //这样所有子view布局时都使用gyd_safeAreaInsets获取自己的安全区。
    UIEdgeInsets view1SafeArea = _view1.gyd_safeAreaInsets;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
