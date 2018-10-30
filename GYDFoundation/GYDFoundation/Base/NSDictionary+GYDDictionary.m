//
//  NSDictionary+GYDDictionary.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/9/4.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "NSDictionary+GYDDictionary.h"
#import "NSArray+GYDArray.h"
#import "GYDJSONSerialization.h"

@implementation NSDictionary (GYDDictionary)

- (nonnull NSMutableDictionary *)gyd_recursiveMutableCopyIfNeed {
    if ([self isKindOfClass:[NSMutableDictionary class]]) {
        NSArray *allKeys = [self allKeys];
        for (NSString *key in allKeys) {
            id value = [self objectForKey:key];
            id newValue = nil;
            if ([value isKindOfClass:[NSDictionary class]]) {
                newValue = [(NSDictionary *)value gyd_recursiveMutableCopyIfNeed];
            } else if ([value isKindOfClass:[NSArray class]]) {
                newValue = [(NSArray *)value gyd_recursiveMutableCopyIfNeed];
            } else {
                newValue = value;
            }
            if (value != newValue) {
                [(NSMutableDictionary *)self setObject:newValue forKey:key];
            }
        }
        return (NSMutableDictionary *)self;
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSString *key in self) {
            id value = [self objectForKey:key];
            if ([value isKindOfClass:[NSDictionary class]]) {
                [dic setObject:[(NSDictionary *)value gyd_recursiveMutableCopyIfNeed] forKey:key];
            } else if ([value isKindOfClass:[NSArray class]]) {
                [dic setObject:[(NSArray *)value gyd_recursiveMutableCopyIfNeed] forKey:key];
            } else {
                [dic setObject:value forKey:key];
            }
        }
        return dic;
    }
}

- (nonnull NSDictionary *)gyd_dictionaryLeftJsonObjectIfNeed {
    if ([GYDJSONSerialization isValidJSONObject:self]) {
        return self;
    } else {
        NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
        for (NSString *key in self) {
            if ([key isKindOfClass:[NSString class]]) {
                id value = [self objectForKey:key];
                if ([GYDJSONSerialization isValidJSONObject:value]) {
                    //不用处理
                } else if ([value isKindOfClass:[NSDictionary class]]){
                    value = [value gyd_dictionaryLeftJsonObjectIfNeed];
                } else if ([value isKindOfClass:[NSArray class]]) {
                    value = [value gyd_arrayLeftJsonObjectIfNeed];
                } else if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSNull class]]) {
                    //不用处理
                } else {
                    //不支持的类型
                    value = nil;
                }
                if (value) {
                    [newDic setObject:value forKey:key];
                }
            }
        }
        return newDic;
    }
}

@end
