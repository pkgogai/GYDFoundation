//
//  NSTimer+GYDWeakTargetTimer.m
//  FMDB
//
//  Created by 宫亚东 on 2018/11/19.
//

#import "NSTimer+GYDWeakTargetTimer.h"
#import "GYDWeakTarget.h"

@implementation NSTimer (GYDWeakTargetTimer)

+ (instancetype)gyd_timerStartWithTimeInterval:(NSTimeInterval)ti
                                    weakTarget:(id)target
                                      selector:(SEL)aSelector
                                       repeats:(BOOL)repeats {
    GYDWeakTarget *weakTarget = [[GYDWeakTarget alloc] init];
    [weakTarget setWeakTarget:target selector:aSelector];
    NSTimer *timer = [NSTimer timerWithTimeInterval:ti target:weakTarget selector:@selector(callOnceWithSelectorObject:) userInfo:nil repeats:repeats];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    return timer;
}

@end
