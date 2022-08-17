//
//  GYDDebugUnreadCountTreeViewItem.h
//  GYDDevelopment
//
//  Created by gongyadong on 2021/3/30.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDHorizontalTreeViewItem.h"
#import "GYDUnreadCountManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDDebugUnreadCountTreeViewItem : GYDHorizontalTreeViewItem

//临时记录一下父节点，用来排除循环
@property (nonatomic, weak) GYDDebugUnreadCountTreeViewItem *superItem;

+ (instancetype)viewItemWithManager:(nullable GYDUnreadCountManager *)manager type:(nonnull NSString *)type;

@end

NS_ASSUME_NONNULL_END
