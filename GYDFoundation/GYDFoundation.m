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

static id<GYDFoundationDelegate> _Delegate;
+ (void)setDelegate:(id<GYDFoundationDelegate>)delegate {
    _Delegate = delegate;
}

+ (id<GYDFoundationDelegate>)delegate {
    return _Delegate;
}

/** 函数发生了错误，应该立刻解决 */
+ (void)function:(const char *)fun makeError:(NSString *)errorString {
    if ([_Delegate respondsToSelector:@selector(function:makeError:)]) {
        [_Delegate function:fun makeError:errorString];
    } else {
        NSAssert(0, @"** GYDFoundation Error **\n%s %@", fun, errorString);
    }
}

/** 函数发出了警告，需要注意 */
+ (void)function:(const char *)fun makeWarning:(NSString *)warningString {
    if ([_Delegate respondsToSelector:@selector(function:makeWarning:)]) {
        [_Delegate function:fun makeWarning:warningString];
    } else {
        NSLog(@"** GYDFoundation Warning **\n%s %@", fun, warningString);
    }
}


@end
