//
//  GYDDebugViewHierarchyItemConfig.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/08/09.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYDDebugViewHierarchyItemConfig : NSObject

/** 是否显示 */
@property (nonatomic) BOOL show;

/** 是否显示边线 */
@property (nonatomic) BOOL showBorderLine;

/** 是否显示图片 */
@property (nonatomic) BOOL showImage;

/** 是否显示坐标 */
@property (nonatomic) BOOL showFrame;

/** 是否显示类型 */
@property (nonatomic) BOOL showClass;

/** 是否显示描述 */
@property (nonatomic) BOOL showDesc;

/** 是否是选中状态 */
//@property (nonatomic) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
