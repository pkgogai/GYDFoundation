//
//  GYDFoundation.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/11.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDLog.h"
#import "NSObject+GYDObject.h"
#import "GYDDictionary.h"
#import "NSDictionary+GYDDictionary.h"
#import "NSArray+GYDArray.h"
#import "GYDJSONSerialization.h"
#import "GYDFile.h"
#import "NSObject+GYDJSONObject.h"
#import "GYDStringSearch.h"
#import "NSString+GYDString.h"



@protocol GYDFoundationLogDelegate <NSObject>

@optional
/**
 函数发生了错误，应该立刻解决。
 如果不实现则是：NSAssert(0, @"** GYDFoundation Error **\n%s %zd %@", fun, line, errorString);
 */
- (void)function:(nonnull const char *)fun line:(NSInteger)line makeError:(nonnull NSString *)errorString;

/**
 函数发出了警告，需要注意
 如果不实现则是：NSLog(@"** GYDFoundation Warning **\n%s %zd %@", fun, line, warningString);
 */
- (void)function:(nonnull const char *)fun line:(NSInteger)line makeWarning:(nonnull NSString *)warningString;


@end

@interface GYDFoundation : NSObject

/** 用来处理错误 */
@property (nonatomic, class, nullable) id<GYDFoundationLogDelegate>delegate;


@end
