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

#pragma mark - 只是检查类型是否符合

+ (nullable NSObject *)objectForKey:(nonnull)key inDictionary:(nullable)dic {
    if ([dic isKindOfClass:[NSDictionary class]]) {
        return [dic objectForKey:key];
    }
    return nil;
}
+ (nullable NSDictionary *)dictionaryForKey:(nonnull)key inDictionary:(nullable)dic {
    if ([dic isKindOfClass:[NSDictionary class]]) {
        id value = [dic objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            return value;
        }
    }
    return nil;
}
+ (nullable NSArray *)arrayForKey:(nonnull)key inDictionary:(nullable)dic {
    if ([dic isKindOfClass:[NSDictionary class]]) {
        id value = [dic objectForKey:key];
        if ([value isKindOfClass:[NSArray class]]) {
            return value;
        }
    }
    return nil;
}
+ (nullable NSString *)stringForKey:(nonnull)key inDictionary:(nullable)dic {
    if ([dic isKindOfClass:[NSDictionary class]]) {
        id value = [dic objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            return value;
        }
    }
    return nil;
}
+ (nullable NSNumber *)numberForKey:(nonnull)key inDictionary:(nullable)dic {
    if ([dic isKindOfClass:[NSDictionary class]]) {
        id value = [dic objectForKey:key];
        if ([value isKindOfClass:[NSNumber class]]) {
            return value;
        }
    }
    return nil;
}

#pragma mark - 遇到string会转换成number

+ (nullable NSNumber *)numberWithLongLongValueObjectForKey:(nonnull)key inDictionary:(nullable)dic {
    if ([dic isKindOfClass:[NSDictionary class]]) {
        id value = [dic objectForKey:key];
        if ([value isKindOfClass:[NSNumber class]]) {
            return value;
        } else if ([value respondsToSelector:@selector(longLongValue)]) {
            return @([value longLongValue]);
        }
    }
    return nil;
}
+ (nullable NSNumber *)numberWithDoubleValueObjectForKey:(nonnull)key inDictionary:(nullable)dic {
    if ([dic isKindOfClass:[NSDictionary class]]) {
        id value = [dic objectForKey:key];
        if ([value isKindOfClass:[NSNumber class]]) {
            return value;
        } else if ([value respondsToSelector:@selector(doubleValue)]) {
            return @([value doubleValue]);
        }
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
