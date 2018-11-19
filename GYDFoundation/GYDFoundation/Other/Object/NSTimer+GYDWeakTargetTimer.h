//
//  NSTimer+GYDWeakTargetTimer.h
//  FMDB
//
//  Created by 宫亚东 on 2018/11/19.
//

#import <Foundation/Foundation.h>

@interface NSTimer (GYDWeakTargetTimer)

+ (instancetype)gyd_timerStartWithTimeInterval:(NSTimeInterval)ti
                                    weakTarget:(id)target
                                      selector:(SEL)aSelector
                                       repeats:(BOOL)repeats;

@end
