//
//  GYDDebugViewHierarchyWindowControl.h
//  GYDFoundation
//
//  Created by gongyadong on 2022/6/23.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 GYDDebugViewHierarchyItem - (void)resetHiddenItemsShowIgnoreView:(BOOL)showIgnore showHiddenView:(BOOL)showHidden isSuperViewHidden:(BOOL)isSuperViewHidden ignoreClassNameSet:(NSSet<NSString *> *)ignoreClassNameArray;
 方法改到 GYDDebugViewHierarchyRootView 或 GYDDebugViewHierarchyDisplayView 中，showIgnore和showHidden作为参数
 */

NS_ASSUME_NONNULL_BEGIN
/**
 展示视图层级结构窗口的控制
 */
@interface GYDDebugViewHierarchyWindowControl : NSObject

/**
 show则创建，否则隐藏
 */
@property (nonatomic, class, getter=isShow) BOOL show;

/*
 不提供每个view单独判断了，至少目前没必要，所以也删除了 GYDDebugViewHierarchyInterface，整体在这里设置
 
 系统界面经常会填充一些中间层的视图，用于作为容器或做出阴影，动画效果等，如_UITextLayoutCanvasView，_UIBarBackgroundShadowView，我们通常不关注这些视图，但是会继续关注其子视图
 而hidden或者alpha≈0的视图，其本身和子视图都不关注。
 因此提供两种设置，前者用词“系统视图（system）”，后者用词“隐藏（hide）”。
 
 系统视图被隐藏时，其子视图依然可以显示。
 如：UIWindow包含子视图UITransitionView，UITransitionView包含子视图UIButton，如果将UITransitionView判定为系统视图，则隐藏系统视图的情况下展示的效果是UIWindow包含UIButton。
 
 下面两个的区别只是在对父视图单独截图的情况，不包含systemContainerView，包含systemTailView。
 如对window单独截图时，不会包含内部的VC等，显示成空白透明效果，
 而对textView单独截图时，会把内部_UITextContainerView等显示的内容一同截图，显示成有文本的效果。
 */

/**
 容器类的系统视图。
 如 UINavigationTransitionView
 */
@property (nonatomic, class) NSSet<NSString *> *systemContainerViewClassNames;
/**
 末端的系统视图。
 如 _UITextContainerView
 */
@property (nonatomic, class) NSSet<NSString *> *systemTailViewClassNames;

@end

NS_ASSUME_NONNULL_END
