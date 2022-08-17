//
//  GYDAccelerateVelocityTimeValuePath.h
//  GYDTimeValuePath
//
//  Created by 宫亚东 on 2018/4/27.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTimeValuePath.h"

/**
 匀加速改变的路径，s = s0 + 0.5 * a * (t - t0)^2
 */
@interface GYDAccelerateVelocityTimeValuePath : GYDTimeValuePath

#pragma mark - 属性

/** 加速度 */
@property (nonatomic)   CGFloat acceleration;

/** 顶点的值 */
@property (nonatomic)   CGFloat originValue;
/** 顶点时候的时间点 */
@property (nonatomic)   NSTimeInterval originTime;

#pragma mark - 创建方法

/**
 通过固定点的时间、速度、加速度，计算路径，注意有可能为nil。
 nil的情况：acceleration==0 && velocity!=0
 */
+ (nullable instancetype)timeValuePathWithTime:(NSTimeInterval)time value:(CGFloat)value velocity:(CGFloat)velocity acceleration:(CGFloat)acceleration;

/**
 通过固定点的时间、速度、顶点位置，计算路径，注意有可能为nil。
 特殊情况：value==originValue && velocity==0，没有加速度信息，指定加速度为0
 nil的情况：
 value==originValue && velocity!=0；
 value!=originValue && velocity==0（或者太接近0，计算时就变成了0）；
 */
+ (nullable instancetype)timeValuePathWithTime:(NSTimeInterval)time value:(CGFloat)value velocity:(CGFloat)velocity originValue:(CGFloat)originValue;

#pragma mark - 计算方法

/** 通过距离顶点的时间计算距离顶点的距离，其它的距离计算都是在此基础上进行 */
- (CGFloat)offsetValueAtOffsetTime:(NSTimeInterval)offsetTime;

/** 通过与顶点的距离差来计算与顶点的时间差，withDirection 表示是否判断方向，判断方向则距离必须与加速度符号相同才会有解 */
- (BOOL)getOffsetTime:(nonnull NSTimeInterval *)offsetTime atOffsetValue:(CGFloat)offsetValue withDirection:(BOOL)withDirection;

@end
