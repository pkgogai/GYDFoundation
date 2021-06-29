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
@property (nonatomic, class, nullable) id<className##protocolSuffix> delegate; \
@end \
@protocol className##protocolSuffix <NSObject>

#define GYDModuleInterfaceRegister(name) _GYDModuleInterfaceRegister(name, Protocol)


#pragma mark - 接口实现文件缩写

#define GYDModuleInterfaceImplementation(className, delegateName) \
@implementation className \
static id Delegate = nil; \
+ (void)initialize { \
    if (self == [className class]) { \
        Class class = NSClassFromString(@#delegateName); \
        if (class) { \
            Delegate = [[class alloc] init]; \
        } \
    } \
} \
+ (void)setDelegate:(id)delegate { \
    Delegate = delegate; \
} \
+ (id)delegate { \
    if (!Delegate) { \
        GYDFoundationWarning(@"[缺少接口]%@", NSStringFromClass([self class])); \
    } \
    return Delegate; \
} \
@end


@interface GYDModuleInterfaceDelegate : NSObject

- (nonnull instancetype)initWithInterfaceName:(nullable NSString *)interfaceName;

@end
