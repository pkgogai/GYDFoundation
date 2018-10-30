//
//  GYDOtherWindowRootViewController.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/9/22.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDOtherWindowRootViewController.h"

@interface GYDOtherWindowRootViewController ()

@end

@implementation GYDOtherWindowRootViewController
{
    BOOL _isBusy;
}

static NSMutableSet *ViewControllerSet;
+ (void)addViewController:(UIViewController *)viewController{
    if (!ViewControllerSet) {
        ViewControllerSet = [NSMutableSet set];
    }
    [ViewControllerSet addObject:viewController];
}
+ (void)removeViewController:(UIViewController *)viewController{
    [ViewControllerSet removeObject:viewController];
}

+ (void)setNeedsStatusBarAppearanceUpdate{
    for (UIViewController *viewController in ViewControllerSet) {
        [viewController setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setNeedsStatusBarAppearanceUpdate{
    if (!_isBusy) {
        _isBusy = YES;
        [super setNeedsStatusBarAppearanceUpdate];
        _isBusy = NO;
    }
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}
- (UIViewController *)childViewControllerForStatusBarHidden{
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

@end
