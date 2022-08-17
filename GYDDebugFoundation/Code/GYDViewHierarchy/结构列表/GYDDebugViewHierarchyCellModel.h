//
//  GYDDebugViewHierarchyCellModel.h
//  GYDFoundation
//
//  Created by gongyadong on 2022/7/5.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDTableViewCellModel.h"
#import "GYDDebugViewHierarchyItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDDebugViewHierarchyCellModel : GYDTableViewCellModel

@property (nonatomic) GYDDebugViewHierarchyItem *data;

@end

NS_ASSUME_NONNULL_END
