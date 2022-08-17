//
//  GYDModuleInterfaceDelegate.h
//  GYDDevelopment
//
//  Created by gongyadong on 2019/6/9.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 接口头文件缩写

#define _GYDModuleInterfaceRegister(className, protocolSuffix) \
protocol className##protocolSuffix; \
@interface className : NSObject \
@property (atomic, class, nullable, readonly) id<className##protocolSuffix> delegate; \
@end \
@protocol className##protocolSuffix <NSObject>

#define GYDModuleInterfaceRegister(name) _GYDModuleInterfaceRegister(name, Protocol)


#pragma mark - 接口实现文件缩写

#define GYDModuleInterfaceImplementation(className, delegateName) \
@implementation className \
+ (id)delegate { \
    static id Delegate = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        Class class = NSClassFromString(@#delegateName); \
        if (class) { \
            Delegate = [[class alloc] init]; \
        } \
    }); \
    if (!Delegate) { \
        GYDFoundationWarning(@"[缺少接口]%@", @#delegateName); \
    } \
    return Delegate; \
} \
@end


@interface GYDModuleInterfaceDelegate : NSObject

- (nonnull instancetype)initWithInterfaceName:(nullable NSString *)interfaceName;

@end
