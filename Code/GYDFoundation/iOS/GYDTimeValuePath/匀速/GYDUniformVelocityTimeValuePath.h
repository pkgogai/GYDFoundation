//
//  GYDUniformVelocityTimeValuePath.h
//  GYDTimeValuePath
//
//  Created by 宫亚东 on 2018/4/27.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTimeValuePath.h"

/**
 匀速改变的路径，s = s0 + v * t
 */
@interface GYDUniformVelocityTimeValuePath : GYDTimeValuePath

#pragma mark - 属性

/** 速度（别忘了可以是负数） */
@property (nonatomic)   CGFloat velocity;

/** 初始值，即 time=0 的value */
@property (nonatomic)   CGFloat originValue;


#pragma mark - 创建方法

/** 通过某个点对应的 时间、速度 来获取路径 */
+ (nonnull instancetype)timeValuePathWithTime:(NSTimeInterval)time value:(CGFloat)value velocity:(CGFloat)velocity;

/**
 通过两个点来计算路径，
 nil的情况：time1==time2
 */
+ (nullable instancetype)timeValuePathWithTime1:(NSTimeInterval)time1 value1:(CGFloat)value1 time2:(NSTimeInterval)time2 value2:(CGFloat)value2;


@end
