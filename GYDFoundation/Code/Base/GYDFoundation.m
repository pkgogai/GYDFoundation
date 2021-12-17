//
//  GYDFoundation.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/11.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDFoundation.h"
#import "GYDFoundationPrivateHeader.h"

@implementation GYDFoundation

static id<GYDFoundationLogDelegate> _Delegate;
+ (void)setDelegate:(id<GYDFoundationLogDelegate>)delegate {
    _Delegate = delegate;
}

+ (id<GYDFoundationLogDelegate>)delegate {
    return _Delegate;
}

/** 函数发生了错误，应该立刻解决 */
+ (void)function:(const char *)fun line:(NSInteger)line makeError:(NSString *)errorString {
    if ([_Delegate respondsToSelector:@selector(function:line:makeError:)]) {
        [_Delegate function:fun line:line makeError:errorString];
    } else {
        NSAssert(0, @"** GYDFoundation Error ** %s %zd %@", fun, line, errorString);
    }
}

/** 函数发出了警告，需要注意 */
+ (void)function:(nonnull const char *)fun line:(NSInteger)line makeWarning:(nonnull NSString *)warningString {
    if ([_Delegate respondsToSelector:@selector(function:line:makeWarning:)]) {
        [_Delegate function:fun line:line makeWarning:warningString];
    } else {
        NSLog(@"** GYDFoundation Warning ** %s %zd %@", fun, line, warningString);
    }
}

/** 打印信息 */
+ (void)function:(const char *)fun line:(NSInteger)line makeInfo:(NSString *)infoString {
    if ([_Delegate respondsToSelector:@selector(function:line:makeInfo:)]) {
        [_Delegate function:fun line:line makeInfo:infoString];
    } else {
        NSLog(@"** GYDFoundation Info ** %s %zd %@", fun, line, infoString);
    }
}

@end
