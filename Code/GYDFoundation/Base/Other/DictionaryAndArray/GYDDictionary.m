//
//  GYDDictionary.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/8/29.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDDictionary.h"
#import "NSDictionary+GYDDictionary.h"

@implementation GYDDictionary

#pragma mark - 从字典取值，key为nil则返回nil，dic非字典则返回nil

/** 无类型检查 */
+ (nullable NSObject *)objectForKey:(nonnull)key inDictionary:(nullable)dic {
    if (!key) {
        return nil;
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [dic objectForKey:key];
}

#pragma mark - 检查值是否符合类型，不符合返回nil

+ (nullable NSObject *)objectOfClass:(nonnull Class)cla forKey:(nonnull)key inDictionary:(nullable)dic {
    if (!key) {
        return nil;
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id value = [dic objectForKey:key];
    if (!cla) {
        return value;
    }
    if ([value isKindOfClass:cla]) {
        return value;
    }
    return nil;
}

+ (nullable NSDictionary *)dictionaryForKey:(nonnull)key inDictionary:(nullable)dic {
    if (!key) {
        return nil;
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}
+ (nullable NSArray *)arrayForKey:(nonnull)key inDictionary:(nullable)dic {
    if (!key) {
        return nil;
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}
+ (nullable NSString *)stringForKey:(nonnull)key inDictionary:(nullable)dic {
    if (!key) {
        return nil;
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    return nil;
}
+ (nullable NSNumber *)numberForKey:(nonnull)key inDictionary:(nullable)dic {
    if (!key) {
        return nil;
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    }
    return nil;
}

#pragma mark - 遇到string会转换成number

/** 如果不是NSNumber，则取longLongValue的值后转成NSNumber，当类型不符时返回 nil */
+ (nullable NSNumber *)numberWithLongLongValueObjectForKey:(nonnull)key inDictionary:(nullable)dic {
    if (!key) {
        return nil;
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    }
    if ([value respondsToSelector:@selector(longLongValue)]) {
        return @([value longLongValue]);
    }
    return nil;
}
/** 如果不是NSNumber，则取doubleValue的值后转成NSNumber，当类型不符时返回 nil */
+ (nullable NSNumber *)numberWithDoubleValueObjectForKey:(nonnull)key inDictionary:(nullable)dic {
    if (!key) {
        return nil;
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    }
    if ([value respondsToSelector:@selector(doubleValue)]) {
        return @([value doubleValue]);
    }
    return nil;
}

#pragma mark - 字典内部处理

+ (nullable NSMutableDictionary *)recursiveMutableCopyIfNeedWithDictionary:(nullable NSDictionary *)dic {
    if ([dic isKindOfClass:[NSDictionary class]]) {
        return [dic gyd_recursiveMutableCopyIfNeed];
    }
    return nil;
}

@end
