//
//  GYDAccelerateVelocityTimeValuePath.m
//  GYDTimeValuePath
//
//  Created by 宫亚东 on 2018/4/27.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDAccelerateVelocityTimeValuePath.h"

@implementation GYDAccelerateVelocityTimeValuePath

#pragma mark - 创建方法

/**
 通过固定点的时间、速度、加速度，计算路径，注意有可能为nil。
 nil的情况：acceleration==0 && velocity!=0
 */
+ (nullable instancetype)timeValuePathWithTime:(NSTimeInterval)time value:(CGFloat)value velocity:(CGFloat)velocity acceleration:(CGFloat)acceleration {
    GYDAccelerateVelocityTimeValuePath *path = [[self alloc] init];
    path.acceleration = acceleration;
    
    if (acceleration == 0) {
        if (velocity == 0) {
            path.originTime = time;
            path.originValue = value;
        } else {
            return nil;
        }
    } else {
        NSTimeInterval tmpTime = velocity / acceleration;
        path.originTime = time - tmpTime;
        path.originValue = value - 0.5 * velocity * tmpTime;
    }
    return path;
    
}

/**
 通过固定点的时间、速度、顶点位置，计算路径，注意有可能为nil。
 特殊情况：value==originValue && velocity==0，没有加速度信息，指定加速度为0
 nil的情况：
 value==originValue && velocity!=0；
 value!=originValue && velocity==0；
 */
+ (nullable instancetype)timeValuePathWithTime:(NSTimeInterval)time value:(CGFloat)value velocity:(CGFloat)velocity originValue:(CGFloat)originValue {
    GYDAccelerateVelocityTimeValuePath *path = [[self alloc] init];
    path.originValue = originValue;
    if (value == originValue) {
        if (velocity == 0) {
            path.acceleration = 0;
            path.originTime = time; //静止不动的，originTime是多少都无所谓了
        } else {
            return nil;
        }
    } else {
        if (velocity == 0) {
            return nil;
        }
        path.acceleration = 0.5 * velocity * velocity / (value - originValue);
        if (path.acceleration == 0) {   //如果velocity太小乘积后变成0，就反过来把velocity作为除数计算
            CGFloat offsetTime = 2 * (value - originValue) / velocity;
            path.originTime = time - offsetTime;
            path.acceleration = velocity / offsetTime;
        } else {
            path.originTime = time - velocity / path.acceleration;
        }
    }
    return path;
}

#pragma mark - 计算方法

//基类的方法， 必须实现
- (CGFloat)valueAtTime:(NSTimeInterval)time {
    return _originValue + [self offsetValueAtOffsetTime:time - _originTime];
}

- (CGFloat)velocityAtTime:(NSTimeInterval)time {
    return (time - _originTime) * _acceleration;
}

/** 通过距离顶点的时间计算距离顶点的距离，其它的距离计算都是在此基础上进行 */
- (CGFloat)offsetValueAtOffsetTime:(NSTimeInterval)offsetTime {
    return 0.5 * _acceleration * offsetTime * offsetTime;
}

/** 通过与顶点的距离差来计算与顶点的时间差，withDirection 表示是否判断方向，判断方向则距离必须与加速度符号相同才会有解 */
- (BOOL)getOffsetTime:(nonnull NSTimeInterval *)offsetTime atOffsetValue:(CGFloat)offsetValue withDirection:(BOOL)withDirection {
    if (_acceleration == 0) {
        if (offsetValue == 0) {
            *offsetTime = 0;
            return YES;
        } else {
            return NO;
        }
    }
    //s = 1/2 * a * t^2,
    CGFloat t_2 = offsetValue * 2 / _acceleration;
    if (t_2 < 0) {
        if (withDirection) {    //要求方向则无解
            return NO;
        } else {
            t_2 = - t_2;        //忽略方向
        }
    }
    *offsetTime = sqrt(t_2);
    return YES;
}

#pragma mark - 描述

- (NSString *)description {
    NSString *string = [NSString stringWithFormat:@"a:o=(%@,%@),a=%@", [GYDTimeValuePath descriptionValue:_originTime], [GYDTimeValuePath descriptionValue:_originValue], [GYDTimeValuePath descriptionValue:_acceleration]];
    return string;
}
- (NSString *)debugDescription {
    NSString *string = [NSString stringWithFormat:@"匀加速：顶点=(%@,%@)，加速度=%@", [GYDTimeValuePath descriptionValue:_originTime], [GYDTimeValuePath descriptionValue:_originValue], [GYDTimeValuePath descriptionValue:_acceleration]];
    return string;
}


@end
