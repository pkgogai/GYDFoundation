//
//  NSDictionary+GYDDictionary.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/9/4.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (GYDDictionary)

/** 递归内部元素，将 字典 和 数组 都变成 Mutable 形式，如果不可变的就会建立新的可变字典来处理并返回，否则还是返回self */
- (nonnull NSMutableDictionary *)gyd_recursiveMutableCopyIfNeed;

/** 递归内部元素，只保留支持json格式的内容，如果是不可变又需要修改的就会建立新的可变字典来处理并返回，否则还是返回self。注意，可以有[NSNull null] */
- (nonnull NSDictionary *)gyd_dictionaryLeftJsonObjectIfNeed;

@end
