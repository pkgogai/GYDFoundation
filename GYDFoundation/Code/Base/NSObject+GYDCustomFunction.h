//
//  NSObject+GYDCustomFunction.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/11/24.
//  Copyright © 2018 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id _Nullable (^GYDCustomFunctionActionBlock)(id _Nonnull obj, id _Nullable arg);

/**
 为NSObject对象扩展自定义的方法
 其实就是key-value的结构设置block，之后再通过key来找到block并调用
 与OC本身的方法没任何关系，可不要误会了！！！
 
 只为了方便很小并且逻辑很集中，又不方便去修改原类的特殊处理。凡是时间充裕，逻辑较多都应建新类开发，以避免代码臃肿。
 
 小用怡情，大用伤和气，滥用等开除。
 */
@interface NSObject (GYDCustomFunction)

/** 通过key-value的方式设置block，别忘了block中要用到对象自身时一定要weak */
- (void)gyd_setFunction:(nonnull NSString *)functionName withAction:(nonnull GYDCustomFunctionActionBlock)action;

/** 通过key找到block并执行，找不到会报错，下面的方法找不到会跳过 */
- (nullable id)gyd_callFunction:(nonnull NSString *)functionName withArg:(nullable id)arg;

/** 通过key查找block，如果有就执行 */
- (nullable id)gyd_callFunctionIfExists:(nonnull NSString *)functionName withArg:(nullable id)arg;

@end
