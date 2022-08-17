//
//  UINavigationController+GYDPush.m
//  GYDFoundation
//
//  Created by gongyadong on 2022/8/17.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "UINavigationController+GYDPush.h"

@implementation UINavigationController (GYDPush)

+ (UINavigationController *)gyd_rootNavigationController {
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    while (1) {
        if ([vc isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)vc;
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [(UITabBarController *)vc selectedViewController];
        } else {
            return vc.navigationController;
        }
    }
}

+ (void)gyd_pushViewController:(UIViewController *)vc animated:(BOOL)animated {
    UINavigationController *nav = [self gyd_rootNavigationController];
    [nav pushViewController:vc animated:animated];
}


@end
