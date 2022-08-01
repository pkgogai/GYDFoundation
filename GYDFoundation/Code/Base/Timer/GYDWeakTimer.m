//
//  GYDWeakTimer.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/12/12.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDWeakTimer.h"
#import "GYDWeakTarget.h"

@implementation GYDWeakTimer
{
    NSTimer *_timer;
}
+ (instancetype)timerStartWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo {
    GYDWeakTimer *weakTimer = [[self alloc] init];
    
    GYDWeakTarget *weakTarget = [[GYDWeakTarget alloc] init];
    [weakTarget setWeakTarget:aTarget selector:aSelector];
    weakTarget.selectorObject = weakTimer;
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:ti target:weakTarget selector:@selector(callOnce) userInfo:nil repeats:yesOrNo];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    weakTimer->_timer = timer;
    
    return weakTimer;
}

+ (instancetype)timerStartWithTimeInterval:(NSTimeInterval)ti userInfo:(id)userInfo repeats:(BOOL)yesOrNo action:(void (^)(GYDWeakTimer * _Nonnull timer))action {
    GYDWeakTimer *weakTimer = [[self alloc] init];
    
    GYDWeakTarget *weakTarget = [[GYDWeakTarget alloc] init];
    weakTarget.action = action;
    weakTarget.selectorObject = weakTimer;
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:ti target:weakTarget selector:@selector(callOnce) userInfo:nil repeats:yesOrNo];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    weakTimer->_timer = timer;
    
    return weakTimer;
}


- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}
- (void)invalidate {
    [_timer invalidate];
    _timer = nil;
}

- (id)userInfo {
    return [_timer userInfo];
}


@end
