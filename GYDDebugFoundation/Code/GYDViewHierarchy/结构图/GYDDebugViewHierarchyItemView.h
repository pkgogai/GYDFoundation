//
//  GYDDebugViewHierarchyItemView.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/08/09.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYDDebugViewHierarchyItem;

@interface GYDDebugViewHierarchyItemView : UIView

@property (nonatomic, weak) GYDDebugViewHierarchyItem *model;

@property (nonatomic) BOOL isSelected;
/** 是否使用完整图片 */
@property (nonatomic) BOOL useCompleteImage;

/** 更新显隐设置后的刷新 */
- (void)updateConfig;
/** 更新图片 */
- (void)updateImage;

@end

NS_ASSUME_NONNULL_END
