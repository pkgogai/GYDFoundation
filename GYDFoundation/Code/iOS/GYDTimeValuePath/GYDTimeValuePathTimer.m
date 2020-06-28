//
//  GYDTimeValuePathTimer.m
//  GYDTimeValuePath
//
//  Created by 宫亚东 on 2018/4/26.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTimeValuePathTimer.h"
#import <sys/sysctl.h>  //NSProcessInfo
#import <UIKit/UIKit.h>
#import "GYDWeakDisplayLink.h"

@implementation GYDTimeValuePathTimer
{
    GYDWeakDisplayLink *_displayTimer;
    NSTimeInterval  _offsetTime;
}

- (void)dealloc
{
    [self stopCallback];
}

- (void)setTime:(NSTimeInterval)time {
    _offsetTime = time - [GYDTimeValuePathTimer systemUptime];
}
- (NSTimeInterval)time {
    return [GYDTimeValuePathTimer systemUptime] + _offsetTime;
}

- (BOOL)isValidNow {
    NSTimeInterval time = self.time;
    if (time < self.timeValuePath.startTime || time > self.timeValuePath.stopTime) {
        return NO;
    }
    return YES;
}

/** 这个时间是否有效（timeValuePath的startTime<= time <=stopTime） */
- (BOOL)isValidAtTime:(NSTimeInterval)time {
    if (time < self.timeValuePath.startTime || time > self.timeValuePath.stopTime) {
        return NO;
    }
    return YES;
}

/** 系统运行时间， */
+ (NSTimeInterval)systemUptime {
    return [NSProcessInfo processInfo].systemUptime;
}

/** 开始计时回调代理，直到超过timeValuePath的stopTime为止，没有timeValuePath则立刻停止，停止后回调timeValuePathTimerDidStop */
- (void)startCallback {
    if (!_displayTimer) {
        _displayTimer = [GYDWeakDisplayLink displayLinkWithWeakTarget:self selector:@selector(timeUpOnce)];
    }
}

/** 停止计时回调 */
- (void)stopCallback {
    _displayTimer = nil;
}

- (void)timeUpOnce {
    if (self.isValidNow) {
        if ([self.delegate respondsToSelector:@selector(timeValuePathTimer:didUpdateValue:)]) {
            CGFloat value = [self.timeValuePath valueAtTime:self.time];
            [self.delegate timeValuePathTimer:self didUpdateValue:value];
        }
    } else {
        [self stopCallback];
        if ([self.delegate respondsToSelector:@selector(timeValuePathTimer:didStopAtValue:)]) {
            CGFloat value = [self.timeValuePath valueAtTime:self.time];
            [self.delegate timeValuePathTimer:self didStopAtValue:value];
        }
    }
}


@end
