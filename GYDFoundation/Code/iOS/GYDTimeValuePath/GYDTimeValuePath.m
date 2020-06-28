//
//  GYDTimeValuePath.m
//  GYDTimeValuePath
//
//  Created by 宫亚东 on 2018/4/26.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTimeValuePath.h"

@implementation GYDTimeValuePath

/** 获取指定时间点对应的数值，由子类实现 */
- (CGFloat)valueAtTime:(NSTimeInterval)time {
    NSAssert(0, @"%s:子类必须实现", __func__);
    return 0;
}

#pragma mark - 工具方法
/** 对数字的描述，整数或.2f？ */
+ (NSString *)descriptionValue:(CGFloat)value {
    if (value == (long long)value) {
        return [NSString stringWithFormat:@"%.0f", value];
    } else {
        return [NSString stringWithFormat:@"%.2f", value];
    }
}

@end
