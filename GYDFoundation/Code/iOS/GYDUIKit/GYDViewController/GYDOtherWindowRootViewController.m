//
//  GYDOtherWindowRootViewController.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/9/22.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDOtherWindowRootViewController.h"
#import "GYDWeakTarget.h"

@interface GYDOtherWindowRootViewController ()

@end

@implementation GYDOtherWindowRootViewController
{
    BOOL _isBusy;
}

- (void)dealloc
{
    [GYDOtherWindowRootViewController removeViewController:self];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [GYDOtherWindowRootViewController addViewController:self];
    }
    return self;
}

static NSMutableDictionary *ViewControllerDictionary;
+ (void)addViewController:(UIViewController *)viewController{
    if (!ViewControllerDictionary) {
        ViewControllerDictionary = [NSMutableDictionary dictionary];
    }
    GYDWeakTarget *weakTarget = [[GYDWeakTarget alloc] init];
    weakTarget.target = viewController;
    NSString *key = [NSString stringWithFormat:@"%p", viewController];
    ViewControllerDictionary[key] = weakTarget;
}
+ (void)removeViewController:(UIViewController *)viewController{
    NSString *key = [NSString stringWithFormat:@"%p", viewController];
    [ViewControllerDictionary removeObjectForKey:key];
}

+ (void)setNeedsStatusBarAppearanceUpdate{
    for (NSString *key in ViewControllerDictionary) {
        GYDWeakTarget *target = ViewControllerDictionary[key];
        UIViewController *viewController = target.target;
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
