//
//  GYDDebugViewHierarchyItem.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/08/09.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDDebugViewHierarchyItemView.h"
#import "GYDDebugViewHierarchyItemConfig.h"

NS_ASSUME_NONNULL_BEGIN

/** 用于记录每一个view的信息，暂时用view，以后考虑是否替换成layer */
@interface GYDDebugViewHierarchyItem : NSObject

/** 视图次序，只保证同一层级的次序，不同层级的无所谓 */
@property (nonatomic)   NSInteger orderNumber;
/** 视图组织结构的层次，随显示效果变化 */
@property (nonatomic)   NSInteger hierarchyIndex;
/** 视图深度，window从1开始，每一层子视图+1 */
@property (nonatomic)   NSInteger level;

/** 父节点 */
@property (nonatomic, nullable, weak) GYDDebugViewHierarchyItem *parentItem;
/** 子节点 */
@property (nonatomic, nonnull, strong)   NSMutableArray<GYDDebugViewHierarchyItem *> *childItems;

/** 原view */
@property (nonatomic, weak) UIView *targetView;

/** 原始view是否隐藏 */
@property (nonatomic) BOOL isHidden;

/** 坐标 */
@property (nonatomic) CGRect viewFrame;

/** 视图类型 */
@property (nonatomic, nonnull) NSString *viewClass;

@property (nonatomic, nonnull) NSString *viewControllerClass;

/** 视图描述 */
@property (nonatomic, nullable) NSString *viewDesc;

/** 截图 */
@property (nonatomic, nonnull) UIImage *viewCompleteImage;
/** 隐藏子视图后的截图（要不要再分成是否显示系统视图的截图???） */
@property (nonatomic, nonnull) UIImage *viewPartImage;
/** 截图的坐标 */
@property (nonatomic) CGRect imageFrame;

#pragma mark - 视图和视图的配置

/** 视图 */
@property (nonatomic, nullable) GYDDebugViewHierarchyItemView *displayView;

/** 对于视图的设置 */
@property (nonatomic, nullable) GYDDebugViewHierarchyItemConfig *displayConfig;


/** 获取指定view的视图层级，root节点本身没有意义 */
+ (instancetype)rootItemWithViewArray:(NSArray<UIView *> *)viewArray;

/** 重置视图的显隐 */
- (void)resetHiddenItemsShowIgnoreView:(BOOL)showIgnore showHiddenView:(BOOL)showHidden isSuperViewHidden:(BOOL)isSuperViewHidden ignoreClassNameSet:(NSSet<NSString *> *)ignoreClassNameArray;

/** 加载图片，这个比较耗时，改为延后 */
- (void)asyncLoadImageWithIgnoreClassNameSet:(NSSet<NSString *> *)ignoreClassNameArray;

/** 并重新调整层级 */
- (NSInteger)resetViewHierarchyReturnTopLevel;

- (void)enumerateChildItemsUsingBlock:(void (^)(GYDDebugViewHierarchyItem *item, BOOL *stop))block;

- (NSDictionary<NSString *, NSNumber *> *)viewClassCount;

@end

NS_ASSUME_NONNULL_END
