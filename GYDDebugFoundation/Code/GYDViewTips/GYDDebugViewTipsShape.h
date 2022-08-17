//
//  GYDDebugViewTipsShape.h
//  GYDDevelopment
//
//  Created by gongyadong on 2021/1/4.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDShape.h"

NS_ASSUME_NONNULL_BEGIN
/**
 两个矩形，4个点相连
 颜色根据 colorRGBValue 强行设置
 */
@interface GYDDebugViewTipsShape : GYDShape

@property (nonatomic) CGRect locationRect;

@property (nonatomic) CGRect tipsRect;

@property (nonatomic) uint32_t colorRGBValue;

@end

NS_ASSUME_NONNULL_END
