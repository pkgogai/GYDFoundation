//
//  UIView+GYDSafeArea.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/2.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GYDSafeArea)

/**
 11系统及以上直接取系统值，
 11系统以下取 gyd_setSafeAreaInsets 设置的值，如果本view没有设置过这个属性，则根据父view计算。返回前会将结果中的负值都设置0，所有父view都没设置过也为0。
 */
@property (nonatomic, readonly) UIEdgeInsets gyd_safeAreaInsets;

/**
 11系统以下需要自己指定safeArea，可以是负值
 建议在 ViewController 的 viewDidLayoutSubviews 中将topLayoutGuide和bottomLayoutGuide设置到这里，
 
 - (void)viewDidLayoutSubviews {
     [super viewDidLayoutSubviews];
     if (@available(iOS 11.0, *)) {
     } else {
         [self.view gyd_setSafeAreaInsets:UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0)];
         //如果在PUSH的时候隐藏TabBar，低版本self.bottomLayoutGuide.length没有及时更新，所以可以改用 bottom = self.hidesBottomBarWhenPushed ? 0 : self.bottomLayoutGuide.length
     }
 }
 */
- (void)gyd_setSafeAreaInsets:(UIEdgeInsets)safeAreaInsets API_DEPRECATED("11以下有效，11及以上直接使用系统方法", ios(7.0,11.0));

/** 11系统一下，清除设置过的safeArea */
- (void)gyd_resetSafeAreaInsets API_DEPRECATED("11以下有效，11及以上直接使用系统方法", ios(7.0,11.0));

@end
