//
//  GYDJSONSerialization.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/11.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDJSONSerialization.h"

@implementation GYDJSONSerialization


#pragma mark - JSON <-> NSData

+ (nullable NSData *)dataWithJSONObject:(nullable id)obj {
    if (!obj) {
        return nil;
    }
    return [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
}
+ (nullable id)JSONObjectWithData:(nullable NSData *)data {
    if (!data) {
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

+ (nullable NSDictionary *)JSONDictionaryWithData:(nullable NSData *)data {
    if (!data) {
        return nil;
    }
    id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return obj;
    }
    return nil;
}
+ (nullable NSMutableDictionary *)JSONMutableDictionaryWithData:(nullable NSData *)data {
    if (!data) {
        return nil;
    }
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if ([obj isKindOfClass:[NSMutableDictionary class]]) {
        return obj;
    }
    return nil;
}

+ (nullable NSArray *)JSONArrayWithData:(nullable NSData *)data {
    if (!data) {
        return nil;
    }
    id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([obj isKindOfClass:[NSArray class]]) {
        return obj;
    }
    return nil;
}
+ (nullable NSMutableArray *)JSONMutableArrayWithData:(nullable NSData *)data {
    if (!data) {
        return nil;
    }
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if ([obj isKindOfClass:[NSMutableArray class]]) {
        return obj;
    }
    return nil;
}


#pragma mark - JSON <-> NSString

+ (nullable NSString *)stringWithJSONObject:(nullable id)obj {
    NSData *data = [self dataWithJSONObject:obj];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}
+ (nullable id)JSONObjectWithString:(nullable NSString *)string {
    if (!string) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self JSONObjectWithData:data];
}

+ (nullable NSDictionary *)JSONDictionaryWithString:(nullable NSString *)string {
    if (!string) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self JSONDictionaryWithData:data];
}
+ (nullable NSMutableDictionary *)JSONMutableDictionaryWithString:(nullable NSString *)string {
    if (!string) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self JSONMutableDictionaryWithData:data];
}

+ (nullable NSArray *)JSONArrayWithString:(nullable NSString *)string {
    if (!string) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self JSONArrayWithData:data];
}
+ (nullable NSMutableArray *)JSONMutableArrayWithString:(nullable NSString *)string {
    if (!string) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self JSONMutableArrayWithData:data];
}

/** 验证是否是JSON对象：
 第一层必须是：NSArray, NSDictionary
 内部支持的对象有：NSString, NSNumber, NSArray, NSDictionary, or NSNull
 NSDictionary的key必须是：NSString，
 NSNumber 必须有效，不能是NaN或infinity
 */
+ (BOOL)isValidJSONObject:(nullable id)obj {
    if (!obj) {
        return NO;
    }
    return [NSJSONSerialization isValidJSONObject:obj];
}

@end
