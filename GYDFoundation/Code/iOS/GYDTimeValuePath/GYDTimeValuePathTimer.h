//
//  GYDTimeValuePathTimer.h
//  GYDTimeValuePath
//
//  Created by 宫亚东 on 2018/4/26.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDTimeValuePath.h"

@class GYDTimeValuePathTimer;

@protocol GYDTimeValuePathTimerDelegate<NSObject>

@optional

- (void)timeValuePathTimer:(GYDTimeValuePathTimer *)timer didUpdateValue:(CGFloat)value;

- (void)timeValuePathTimer:(GYDTimeValuePathTimer *)timer didStopAtValue:(CGFloat)value;

@end

@interface GYDTimeValuePathTimer : NSObject

@property (nonatomic, weak) id<GYDTimeValuePathTimerDelegate> delegate;

@property (nonatomic)   GYDTimeValuePath    *timeValuePath;

/** 指定或获取当前的时间，时间是实时变动的，不指定的话，就以systemUptime为准 */
@property (nonatomic)   NSTimeInterval time;

/** 此刻是否在有效范围内（timeValuePath的startTime<= now <=stopTime） */
@property (nonatomic, readonly) BOOL isValidNow;

/** 这个时间是否有效（timeValuePath的startTime<= time <=stopTime） */
- (BOOL)isValidAtTime:(NSTimeInterval)time;

/** 系统运行时间， */
+ (NSTimeInterval)systemUptime;

/** 开始计时回调代理，直到超过timeValuePath的stopTime为止，没有timeValuePath则立刻停止，停止后回调timeValuePathTimerDidStop */
- (void)startCallback;
/** 停止计时回调 */
- (void)stopCallback;


@end
