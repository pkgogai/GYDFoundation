//
//  UIScrollView+GYDScrollVisible.h
//  GYDDevelopment
//
//  Created by gongyadong on 2021/12/10.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 针对键盘遮挡情况，
 触发时机：在设置这里的2个属性，或者键盘高度改变时
 效果：通过修改contentOffset和contentInset，确保指定位置滚动到可视区域。
 
 需要确保在gyd_visibleRect有值期间没有别的功能也在修改gyd_visibleRect，如下拉刷新等
 
 //按需要设置好contentInset后，adjustedContentInset一变就不准了，所以必须禁用
 if (@available(iOS 11.0, *)) {
     scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
 }
 */
@interface UIScrollView (GYDScrollVisible)

/// 要展示的区域，CGRectNull表示没有。如果区域比可视范围更大，则以左上角为准。
@property (nonatomic) CGRect gyd_visibleRect;

/// UIScrollView本身展示区域，类似gyd_safeArea的反向区域
//@property (nonatomic) CGRect gyd_visibleArea;

/// 将gyd_visibleArea区域反过来设置，参考gyd_safeArea，更容易理解
@property (nonatomic) UIEdgeInsets gyd_visibleSafeArea;

@end

NS_ASSUME_NONNULL_END
