//
//  GYDDebugViewHierarchyDisplayView.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/08/09.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYDDebugViewHierarchyItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDDebugViewHierarchyDisplayView : UIView

/** 显示被忽略的系统视图 */
@property (nonatomic) BOOL showIgnoreView;

/** 显示被隐藏的视图 */
@property (nonatomic) BOOL showHiddenView;

/** 总深度 */
@property (nonatomic, readonly) NSInteger maxLevel;

/** 显示的层数深度 */
@property (nonatomic) NSInteger bottomLevel;

/** 显示的层数深度 */
@property (nonatomic) NSInteger topLevel;

@property (nonatomic, readonly)   NSArray<GYDDebugViewHierarchyItemView *> *itemViewArray;


- (void)reloadRootViewHierarchyItem:(GYDDebugViewHierarchyItem *)root;

- (void)changeSlipOffset:(CGPoint)slipOffset;

- (void)layoutHierarchyItemViews;

/** 根据选中区域获取数据 */
- (NSArray<GYDDebugViewHierarchyItem *> *)itemArrayInSelectFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
