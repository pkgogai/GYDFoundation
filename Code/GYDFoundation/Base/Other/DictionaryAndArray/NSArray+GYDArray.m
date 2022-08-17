//
//  NSArray+GYDArray.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/9/4.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "NSArray+GYDArray.h"
#import "NSDictionary+GYDDictionary.h"
#import "GYDJSONSerialization.h"

@implementation NSArray (GYDArray)

- (nonnull NSMutableArray *)gyd_recursiveMutableCopyIfNeed {
    if ([self isKindOfClass:[NSMutableArray class]]) {
        for (NSInteger i = 0; i < self.count; i++) {
            id value = [self objectAtIndex:i];
            id newValue = nil;
            if ([value isKindOfClass:[NSDictionary class]]) {
                newValue = [(NSDictionary *)value gyd_recursiveMutableCopyIfNeed];
            } else if ([value isKindOfClass:[NSArray class]]) {
                newValue = [(NSArray *)value gyd_recursiveMutableCopyIfNeed];
            } else {
                newValue = value;
            }
            if (value != newValue) {
                [(NSMutableArray *)self replaceObjectAtIndex:i withObject:newValue];
            }
        }
        return (NSMutableArray *)self;
    } else {
        NSMutableArray *arr = [NSMutableArray array];
        for (id value in self) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                [arr addObject:[(NSDictionary *)value gyd_recursiveMutableCopyIfNeed]];
            } else if ([value isKindOfClass:[NSArray class]]) {
                [arr addObject:[(NSArray *)value gyd_recursiveMutableCopyIfNeed]];
            } else {
                [arr addObject:value];
            }
        }
        return arr;
    }
}

- (nonnull NSArray *)gyd_arrayLeftJsonObjectIfNeed {
    if ([GYDJSONSerialization isValidJSONObject:self]) {
        return self;
    } else {
        NSMutableArray *arr = [NSMutableArray array];
        for (id value in self) {
            id newValue = value;
            if ([GYDJSONSerialization isValidJSONObject:value]) {
                //不用处理
            } else if ([value isKindOfClass:[NSDictionary class]]){
                newValue = [value gyd_dictionaryLeftJsonObjectIfNeed];
            } else if ([value isKindOfClass:[NSArray class]]) {
                newValue = [value gyd_arrayLeftJsonObjectIfNeed];
            } else if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSNull class]]) {
                //不用处理
            } else {
                //不支持的类型
                newValue = nil;
            }
            if (newValue) {
                [arr addObject:newValue];
            }
        }
        return arr;
    }
}

@end
