//
//  GYDWeakTimer.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/12/12.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 timer不直接引用target，当外部创建并引用此对象时计时开始，当外部不引用此对象时，timer停止。
 例如：
 self.timer = [GYDWeakTimer timerStartWith……] （创建并引用了此timer）开始计时
 self.timer = nil;  //或者self被释放时，此后没有对此timer的引用，停止计时
 */
@interface GYDWeakTimer : NSObject

//注意：2019年12月26日这里已经将aSelector的参数改为GYDWeakTimer。还是尽量使用无参数的aSelector。
+ (nonnull instancetype)timerStartWithTimeInterval:(NSTimeInterval)ti target:(nonnull id)aTarget selector:(nonnull SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;

- (void)invalidate; //若不手动调用，会随timer被释放而停止。

@property (nullable, readonly) id userInfo;


@end
