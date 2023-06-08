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
 
 注意1：需要设置scrollView.contentSize。当没有contentSize时，[UITextField scrollTextFieldToVisibleIfNecessary]会滚到左上角，暂时不知道如何处理
 注意2：需要确保在gyd_visibleRect有值期间没有别的功能也在修改contentInset，如下拉刷新等。如果需要修改，可以这样先把 gyd_visibleRect 置 Null，如
 CGRect visibleRect = self.gyd_visibleRect;
 self.gyd_visibleRect = CGRectNull;
 self.contentInset = 新值;
 self.gyd_visibleRect = visibleRect;
 
 建议如下设置，自己控制contentInset，以防止旧机型电话、录音、定位等导致adjustedContentInset变化。
 if (@available(iOS 11.0, *)) {
     scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
 }
 */

@interface UIScrollView (GYDScrollVisible)

/// 要展示的区域，CGRectNull表示没有。如果区域比可视范围更大，则以左上角为准。
@property (nonatomic) CGRect gyd_visibleRect;

/// 加个边界，类似safeAreaInsets
@property (nonatomic) UIEdgeInsets gyd_visibleAreaInsets;

@end

NS_ASSUME_NONNULL_END
