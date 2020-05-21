//
//  GYDDictionary.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/8/29.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 对dic对象类型，以及返回值类型进行了检查，没有对key检查
 */
@interface GYDDictionary : NSObject

#pragma mark - 从字典取值，key为nil则返回nil，dic非字典则返回nil

/** 无类型检查 */
+ (nullable NSObject *)objectForKey:(nonnull)key inDictionary:(nullable)dic;

#pragma mark - 检查值是否符合类型，不符合返回nil

+ (nullable NSObject *)objectOfClass:(nonnull Class)cla forKey:(nonnull)key inDictionary:(nullable)dic;

+ (nullable NSDictionary *)dictionaryForKey:(nonnull)key inDictionary:(nullable)dic;
+ (nullable NSArray *)arrayForKey:(nonnull)key inDictionary:(nullable)dic;
+ (nullable NSString *)stringForKey:(nonnull)key inDictionary:(nullable)dic;
+ (nullable NSNumber *)numberForKey:(nonnull)key inDictionary:(nullable)dic;

#pragma mark - 遇到string会转换成number

/** 如果不是NSNumber，则取longLongValue的值后转成NSNumber，当类型不符时返回 nil */
+ (nullable NSNumber *)numberWithLongLongValueObjectForKey:(nonnull)key inDictionary:(nullable)dic;
/** 如果不是NSNumber，则取doubleValue的值后转成NSNumber，当类型不符时返回 nil */
+ (nullable NSNumber *)numberWithDoubleValueObjectForKey:(nonnull)key inDictionary:(nullable)dic;

#pragma mark - 字典内部处理

/** 见类别方法 gyd_recursiveMutableCopyIfNeed */
+ (nullable NSMutableDictionary *)recursiveMutableCopyIfNeedWithDictionary:(nullable NSDictionary *)dic;

@end

