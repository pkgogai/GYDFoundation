//
//  UIView+GYDCustomFunction.h
//  GYDFoundation
//
//  Created by gongyadong on 2022/7/5.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GYDCustomFunction)

/** 从本视图父视图或者ViewController中找到并执行方法 */
- (nullable id)gyd_inViewTreeCallFunction:(nonnull NSString *)functionName withArg:(nullable id)arg;

/** 从本视图父视图或者ViewController中找到并执行方法 */
- (nullable id)gyd_inViewTreeCallFunctionIfExists:(nonnull NSString *)functionName withArg:(nullable id)arg exist:(nullable BOOL *)exist;

@end

NS_ASSUME_NONNULL_END
