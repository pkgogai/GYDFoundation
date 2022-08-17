//
//  NSObject+GYDCustomFunction.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/11/24.
//  Copyright © 2018 宫亚东. All rights reserved.
//

#import "NSObject+GYDCustomFunction.h"
#import "GYDFoundationPrivateHeader.h"

#import "objc/runtime.h"

@implementation NSObject (GYDCustomFunction)

- (NSMutableDictionary *)gyd_customFunctionActionBlockDictionary {
    static char blockDictionaryKey;
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &blockDictionaryKey);
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &blockDictionaryKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dic;
}

/** 通过key-value的方式设置block */
- (void)gyd_setFunction:(nonnull NSString *)functionName withAction:(nonnull GYDCustomFunctionActionBlock)action {
    if (!action) {
        GYDFoundationError(@"GYDCustomFunctionActionBlock 不能为空");
        return;
    }
    if (!functionName) {
        GYDFoundationError(@"functionName 不能为空");
        return;
    }
    
    [self gyd_customFunctionActionBlockDictionary][functionName] = action;
}

- (GYDCustomFunctionActionBlock)gyd_ActionForFunction:(nonnull NSString *)functionName {
    if (!functionName) {
        GYDFoundationError(@"functionName 不能为空");
        return nil;
    }
    return [self gyd_customFunctionActionBlockDictionary][functionName];
}

/** 通过key找到block并执行 */
- (id)gyd_callFunction:(nonnull NSString *)functionName withArg:(nullable id)arg {
    if (!functionName) {
        GYDFoundationError(@"functionName 不能为空");
        return nil;
    }
    
    GYDCustomFunctionActionBlock action = [self gyd_customFunctionActionBlockDictionary][functionName];
    if (!action) {
        GYDFoundationError(@"必须先设置，后调用");
        return nil;
    }
    return action(self, arg);
}

/** 通过key查找block，如果有就执行 */
- (nullable id)gyd_callFunctionIfExists:(nonnull NSString *)functionName withArg:(nullable id)arg exist:(BOOL *)exist {
    if (!functionName) {
        GYDFoundationError(@"functionName 不能为空");
        return nil;
    }
    
    GYDCustomFunctionActionBlock action = [self gyd_customFunctionActionBlockDictionary][functionName];
    if (exist) {
        *exist = action ? YES : NO;
    }
    if (!action) {
        return nil;
    }
    return action(self, arg);
}

@end
