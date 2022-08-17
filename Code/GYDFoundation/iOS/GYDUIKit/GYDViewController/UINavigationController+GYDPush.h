//
//  UINavigationController+GYDPush.h
//  GYDFoundation
//
//  Created by gongyadong on 2022/8/17.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (GYDPush)

+ (UINavigationController *)gyd_rootNavigationController;

+ (void)gyd_pushViewController:(UIViewController *)vc animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
