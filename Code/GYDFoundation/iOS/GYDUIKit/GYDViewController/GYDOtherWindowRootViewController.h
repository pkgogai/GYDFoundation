//
//  GYDOtherWindowRootViewController.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/9/22.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDViewController.h"

/**
 状态栏的效果是在viewController中设置的，
 如果创建了更上层的新window，那么状态栏的样式也会随着新window的viewController变化，
 所以不想状态栏改变的话，就专门写了一个viewController，内部将状态栏设置成和AppDelegate的window的效果一样。
 */
@interface GYDOtherWindowRootViewController : GYDViewController

/** 将其它window的GYDOtherWindowRootViewController 添加进来，使其即使刷新效果 */
+ (void)addViewController:(UIViewController *)viewController;

+ (void)removeViewController:(UIViewController *)viewController;

/**
 刷新状态栏样式，需要在AppDelegate的window的rootViewController中手动调用
 - (void)setNeedsStatusBarAppearanceUpdate {
    [super setNeedsStatusBarAppearanceUpdate];
    [GYDOtherWindowRootViewController setNeedsStatusBarAppearanceUpdate];
 }
 */
+ (void)setNeedsStatusBarAppearanceUpdate;

@end
