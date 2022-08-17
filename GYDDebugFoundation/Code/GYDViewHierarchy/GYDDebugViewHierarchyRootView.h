//
//  GYDDebugViewHierarchyRootView.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/08/09.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYDDebugViewHierarchyItem.h"
#import "GYDDebugViewHierarchyDisplayView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDDebugViewHierarchyRootView : UIView

@property (nonatomic, readonly) GYDDebugViewHierarchyItem *rootItem;

@property (nonatomic, readonly) GYDDebugViewHierarchyDisplayView *displayView;

/** 显示被忽略的系统视图 */
@property (nonatomic) BOOL showIgnoreView;

/** 显示被隐藏的视图 */
@property (nonatomic) BOOL showHiddenView;

/** 显示用于选择操作的视图 */
@property (nonatomic) BOOL showSelectView;

/** 显示详情视图 */
@property (nonatomic) BOOL showListView;


- (void)reloadViewHierarchyWithAllWindows;

- (void)reloadViewHierarchyWithViewArray:(NSArray<UIView *> *)viewArray;







@end

NS_ASSUME_NONNULL_END
