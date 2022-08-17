//
//  GYDWeakDisplayLink.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2019/4/25.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 同GYDWeakTimer，当外部创建并引用此对象时计时开始，当外部不引用此对象时，timer停止。
 例如：
 self.timer = [GYDWeakDisplayLink displayLinkWith……] （创建并引用了此timer）开始计时
 self.timer = nil;  //或者当self被释放时，没有对此timer的引用，停止计时。
*/
@interface GYDWeakDisplayLink : NSObject

//只用来获取信息，不要做任何修改
@property (nonatomic, readonly, nonnull) CADisplayLink *displayLink;

+ (nonnull instancetype)displayLinkStartWithWeakTarget:(nonnull id)target
                                 selector:(nonnull SEL)aSelector;

+ (nonnull instancetype)displayLinkStartWithAction:(void (^ _Nonnull)(GYDWeakDisplayLink * _Nonnull displayLink))action;

- (void)invalidate; //若不手动调用，会随本对象被释放而停止。

@end

