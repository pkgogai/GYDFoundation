//
//  GYDDebugViewHierarchyItemListView.h
//  GYDFoundation
//
//  Created by gongyadong on 2022/7/4.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYDDebugViewHierarchyItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDDebugViewHierarchyItemListView : UIView

@property (nonatomic, nullable) NSArray<GYDDebugViewHierarchyItem *> *list;

@end

NS_ASSUME_NONNULL_END
