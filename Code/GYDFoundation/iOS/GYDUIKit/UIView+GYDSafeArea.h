//
//  UIView+GYDSafeArea.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/2.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 2022年09月25日放弃直接取系统的值，都改为计算，因为这里对safeArea的计算规则与系统的不同。
 从父view向子view计算safeArea时，系统的safeArea只会变小不会变大，
 以safeArea.top的值为例：view1包含view2包含view3([view1 addSubview:view2]，[view2 addSubview:view3])
 相同的情况：
 view1.safeArea = 100,view2.y = 20,view3.y=20,则view2.safeArea = 80,view3.safeArea = 60
 不同的情况：
 view1.safeArea = 100,view2.y = -20,view3.y=20，（在屏幕上，view3和view1重合）
 系统的规则view2.safeArea = 100,view3.safeArea = 80
 这里的规则view2.safeArea = 120,view3.safeArea = 100
 见demo图形示意。
 */
@interface UIView (GYDSafeArea)

#pragma mark - 获取
/**
 通过gyd_setSafeAreaInsets设置，如果本view没有设置过这个属性，则根据父view计算。返回前会将结果中的负值都设置为0，所有父view都没设置过也为0。
 */
@property (nonatomic, readonly) UIEdgeInsets gyd_safeAreaInsets;
/** 可以有负值的safeArea，如view.safeArea.top=20，subview.y = 40，则subview.safeArea.top=-20 */
- (UIEdgeInsets)gyd_safeAreaInsetsAllowNegative;

#pragma mark - 设置
/**
 设置并启用safeArea，可以是负值，参考[GYDViewController viewDidLayoutSubviews]设置
 */
- (void)gyd_setSafeAreaInsets:(UIEdgeInsets)safeAreaInsets;
/** 恢复默认状态，使之重新以从父view计算的为准 */
- (void)gyd_resetSafeAreaInsets;
/** 本view禁用safeArea，其子view没独立设置的话，safeArea都是0 */
- (void)gyd_disableSafeArea;

@end
