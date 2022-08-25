//
//  GYDSafeAreaExampleViewController.m
//  iOSExample
//
//  Created by 宫亚东 on 2018/10/31.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDSafeAreaExampleViewController.h"
#import "UIView+GYDSafeArea.h"
#import "GYDDebugViewTipsDisplayView.h"
#import "GYDDemoMenu.h"

@interface GYDSafeAreaExampleViewController ()

@end

@implementation GYDSafeAreaExampleViewController
{
    UIView *_demoView[4];
    
    UIImageView *_safeAreaBorderView;
    
    GYDDebugViewTipsDisplayViewModel *_tipsModel[4];
    GYDDebugViewTipsDisplayView *_displayView;
    
    //11系统早已经普及，demo也懒得写了
    UIView *_view1;
}

+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"安全区" desc:@"给11一下系统的view加上安全区，忽略几何变换" order:40 vcClass:self];
    [menu addToMenu:GYDDemoMenuOtherName];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (NSInteger i = 0; i < 4; i++) {
        _demoView[i] = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_demoView[i]];
    }
    
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
    NSLog(@"%@", NSStringFromUIEdgeInsets(view1SafeArea));
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
