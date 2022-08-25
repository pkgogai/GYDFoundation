//
//  GYDDebugAppInterface.h
//  Pods
//
//  Created by gongyadong on 2022/8/10.
//Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDModuleInterfaceDelegate.h"

/*
 需对本接口进行实现，例：
 
 #import "GYDModuleInterfaceDelegate.h"
 #import "GYDDebugAppInterface.h"

 @interface GYDDebugAppInterfaceDelegate : GYDModuleInterfaceDelegate<GYDDebugAppInterfaceProtocol>

 @end

 @implementation GYDDebugAppInterfaceDelegate

 - (NSArray<UIView *> *)viewHierarchyControlWillAddViewArray:(NSArray<UIView *> *)array {
     return array;
 }
 
 @end
 
 */

#import "GYDDebugRootView.h"

@GYDModuleInterfaceRegister(GYDDebugAppInterface)

/**
 调整控制条上的view，默认的几个view可以通过tag来区分
 */
- (nullable NSArray<UIView *> *)viewHierarchyRootView:(nonnull GYDDebugRootView *)view willAddControlViewArray:(nonnull NSArray<UIView *> *)array;

- (nullable NSArray<UIView *> *)logRootView:(nonnull GYDDebugRootView *)view willAddControlViewArray:(nonnull NSArray<UIView *> *)array;


@end

typedef enum : NSInteger {
    GYDViewHierarchyControlViewSpaceTag = 100,
    GYDViewHierarchyControlViewListTag,
    GYDViewHierarchyControlViewMoveSelectChangeTag,
    GYDViewHierarchyControlViewSystemTag,
    GYDViewHierarchyControlViewHiddenTag,
    GYDViewHierarchyControlViewLevelTag,
    GYDViewHierarchyControlViewDetailTag,
    
    GYDDebugControlViewLogTouchTag,
    GYDDebugControlViewLogFoldTag,
    GYDDebugControlViewLogClearTag,
    GYDDebugControlViewLogLineTag,
    
} GYDDebugControlViewTag;
