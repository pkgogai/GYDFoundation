//
//  UIView+GYDCustomFunction.m
//  GYDFoundation
//
//  Created by gongyadong on 2022/7/5.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "UIView+GYDCustomFunction.h"
#import "NSObject+GYDCustomFunction.h"
#import "GYDFoundationPrivateHeader.h"

@implementation UIView (GYDCustomFunction)

/** 从本视图父视图或者ViewController中找到并执行方法 */
- (nullable id)gyd_inViewTreeCallFunction:(nonnull NSString *)functionName withArg:(nullable id)arg {
    for (UIView *view = self; view; view = view.superview) {
        GYDCustomFunctionActionBlock action = [view gyd_ActionForFunction:functionName];
        if (action) {
            return action(view, arg);
        }
        if ([view.nextResponder isKindOfClass:[UIViewController class]]) {
            GYDCustomFunctionActionBlock action = [view.nextResponder gyd_ActionForFunction:functionName];
            if (action) {
                return action(view.nextResponder, arg);
            }
        }
    }
    NSMutableString *msg = [[NSMutableString alloc] init];
    for (UIView *view = self; view; view = view.superview) {
        if ([view.nextResponder isKindOfClass:[UIViewController class]]) {
            [msg appendFormat:@"%@(%@),", NSStringFromClass([view.nextResponder class]), NSStringFromClass([view class])];
        } else {
            [msg appendFormat:@"%@,", NSStringFromClass([view class])];
        }
    }
    GYDFoundationError(@"为设置方法：%@\n%@", functionName, msg);
    return nil;
}

/** 从本视图父视图或者ViewController中找到并执行方法 */
- (nullable id)gyd_inViewTreeCallFunctionIfExists:(nonnull NSString *)functionName withArg:(nullable id)arg exist:(BOOL *)exist {
    for (UIView *view = self; view; view = view.superview) {
        GYDCustomFunctionActionBlock action = [view gyd_ActionForFunction:functionName];
        if (action) {
            if (exist) {
                *exist = YES;
            }
            return action(view, arg);
        }
        if ([view.nextResponder isKindOfClass:[UIViewController class]]) {
            GYDCustomFunctionActionBlock action = [view.nextResponder gyd_ActionForFunction:functionName];
            if (action) {
                if (exist) {
                    *exist = YES;
                }
                return action(view.nextResponder, arg);
            }
        }
    }
    if (exist) {
        *exist = NO;
    }
    return nil;
}

@end
