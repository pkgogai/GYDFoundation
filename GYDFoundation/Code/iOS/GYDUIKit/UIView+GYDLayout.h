//
//  UIView+GYDLayout.h
//  GYDDevelopment
//
//  Created by 宫亚东 on 2018/7/2.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GYDLayout)

/**
 if (view && !view.hidden) {}
 ↓
 if (view.gyd_noHidden) {}
 */
@property (nonatomic, readonly) BOOL gyd_noHidden;

#pragma mark - 子视图操作父视图的setNeedsLayout 和 layoutIfNeeded
/**
 打个标记，以便下面的方法找到这个view。UIViewController.view 默认YES，其它默认NO
 */
@property (nonatomic) BOOL gyd_isLayoutView;

/**
 在本视图、父视图链中找到 gyd_isLayoutView == YES 的view，执行它的 setNeedsLayout 方法
 */
- (void)gyd_layoutViewSetNeedsLayout;
/**
 在本视图、父视图链中找到 gyd_isLayoutView == YES 的view，执行它的 layoutIfNeeded 方法
 */
- (void)gyd_layoutViewLayoutIfNeeded;

@end

NS_ASSUME_NONNULL_END
