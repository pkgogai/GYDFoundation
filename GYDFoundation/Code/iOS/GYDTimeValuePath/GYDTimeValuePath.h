//
//  GYDTimeValuePath.h
//  GYDTimeValuePath
//
//  Created by 宫亚东 on 2018/4/26.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreGraphics/CGBase.h>    //CGFloat

/** 数值随着时间而改变的路径 */
@interface GYDTimeValuePath : NSObject
{
    NSTimeInterval _startTime;
    NSTimeInterval _stopTime;
}
//每个路径有对应的时间段，这样不同的路径就可以组合在一起作为一个更大的路径

/** 起始时间，从此时间点开始使用此路径 */
@property (nonatomic) NSTimeInterval startTime;

/** 结束时间，使用此路径到此时间点截止 */
@property (nonatomic) NSTimeInterval stopTime;


/** 获取指定时间点对应的数值，由子类实现 */
- (CGFloat)valueAtTime:(NSTimeInterval)time;

#pragma mark - 工具方法
/** 对数字的描述，整数或.2f？ */
+ (NSString *)descriptionValue:(CGFloat)value;

@end
