//
//  GYDHorizontalTreeView.h
//  GYDDevelopment
//
//  Created by gongyadong on 2021/3/31.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYDHorizontalTreeViewItem.h"

NS_ASSUME_NONNULL_BEGIN
/**
 绘制树形图，根节点在左边，子节点在右边，线条是{样式
 */
@interface GYDHorizontalTreeView : UIView

/** 设置线条颜色 */
@property (nonatomic) UIColor *lineColor;

@property (nonatomic, strong) GYDHorizontalTreeViewItem *rootItem;

/** 更新布局，根据内容大小改变size */
- (void)layoutAndChangeSize;

////可视范围，超出可视范围的view会被回收并复用
//@property (nonatomic) CGRect visibleRect;

@end

NS_ASSUME_NONNULL_END
