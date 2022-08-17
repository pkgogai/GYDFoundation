//
//  GYDDebugWindow.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/24.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDDebugWindow.h"
#import "GYDOtherWindowRootViewController.h"

@implementation GYDDebugWindow

- (instancetype)initWithRootView:(UIView *)view
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelNormal + 1; //选中菜单和放大镜有时不出现，可能会随着使用而改变。某次测试时大概是10
        UIViewController *vc = [[GYDOtherWindowRootViewController alloc] init];
        vc.view = view;
        self.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UINavigationController *nav = (UINavigationController *)self.rootViewController;
    return [nav.topViewController.view pointInside:point withEvent:event];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
