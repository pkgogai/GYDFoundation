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



@protocol GYDFoundationDelegate <NSObject>

@optional
/**
 函数发生了错误，应该立刻解决。
 如果不实现则是：NSAssert(0, @"** GYDFoundation Error **\n%s %@", fun, errorString);
 */
- (void)function:(const char *)fun makeError:(NSString *)errorString;

/**
 函数发出了警告，需要注意
 如果不实现则是：NSLog(@"** GYDFoundation Warning **\n%s %@", fun, warningString);
 */
- (void)function:(const char *)fun makeWarning:(NSString *)warningString;


@end

@interface GYDFoundation : NSObject

/** 用来处理错误 */
@property (nonatomic, class) id<GYDFoundationDelegate>delegate;


@end
