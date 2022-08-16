//
//  GYDUniformVelocityTimeValuePath.m
//  GYDTimeValuePath
//
//  Created by 宫亚东 on 2018/4/27.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDUniformVelocityTimeValuePath.h"

@implementation GYDUniformVelocityTimeValuePath

#pragma mark - 创建方法

/** 通过某个点对应的 时间、速度 来获取路径 */
+ (nonnull instancetype)timeValuePathWithTime:(NSTimeInterval)time value:(CGFloat)value velocity:(CGFloat)velocity {
    GYDUniformVelocityTimeValuePath *path = [[self alloc] init];
    path.velocity = velocity;
    path.originValue = value - velocity * time;
    return path;
}

/** 通过两个点来计算路径，当 time1==time2 时，当做速度为0，并且value1和value2取最大值作为位移  */
+ (nullable instancetype)timeValuePathWithTime1:(NSTimeInterval)time1 value1:(CGFloat)value1 time2:(NSTimeInterval)time2 value2:(CGFloat)value2 {
    if (time1 != time2) {
        GYDUniformVelocityTimeValuePath *path = [[self alloc] init];
        path.velocity = (value2 - value1) / (time2 - time1);
        path.originValue = value1 - path.velocity * time1;
        return path;
    } else {
        return nil;
    }
}

#pragma mark - 计算方法

- (CGFloat)valueAtTime:(NSTimeInterval)time {
    return self.originValue + self.velocity * time;
}

- (CGFloat)velocityAtTime:(NSTimeInterval)time {
    return self.velocity;
}

#pragma mark - 描述

- (NSString *)description {
    NSString *string = [NSString stringWithFormat:@"v:o=%@,v=%@", [GYDTimeValuePath descriptionValue:_originValue], [GYDTimeValuePath descriptionValue:_velocity]];
    return string;
}

- (NSString *)debugDescription {
    NSString *string = [NSString stringWithFormat:@"匀速路径：初始值=%@, 速度=%@", [GYDTimeValuePath descriptionValue:_originValue], [GYDTimeValuePath descriptionValue:_velocity]];
    return string;
}

@end
