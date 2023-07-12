//
//  GYDFoundation.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/11.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - array,dictionary

#import "GYDDictionary.h"
#import "NSDictionary+GYDDictionary.h"
#import "NSArray+GYDArray.h"

#pragma mark - string,data,number

#import "GYDStringSearch.h"
#import "NSString+GYDString.h"
#import "NSString+GYDEscape.h"
#import "GYDMd5.h"
//base64，md5
#import "NSData+GYDEscape.h"
//json
#import "GYDJSONSerialization.h"
//date
#import "NSDate+GYDDateFormat.h"

#pragma mark - 其它
#import "GYDTypes.h"
#import "GYDValueTools.h"
//创建文件等
#import "GYDFile.h"
//阻塞，设置block内代码延后执行
#import "GYDMultiObstacleActionQueueManager.h"
//扩展block作为属性，方便调用，但是名字可能要改一下，不要叫function，避免被人误以为是修改方法
#import "NSObject+GYDCustomFunction.h"
//KVO 改成block形式，避免多次KVO混到一起处理麻烦
#import "GYDKeyValueObserver.h"
//通知 block形式，随self而释放
#import "NSObject+GYDNotificationAutoRemove.h"
//日志
#import "GYDLog.h"
//url的简单处理
#import "GYDUrl.h"
//objc
#import "NSObject+GYDObject.h"
#include "gyd_class_property.h"

//计时器避免互相引用
#import "GYDWeakTimer.h"
#import "GYDWeakTarget.h"

#pragma mark - 其它模块

/*
//iOS相关
#import "GYDUIKit.h"
 */

//数据库
#if GYD_FOUNDATION_USED_DATABASE == 1
#import "GYDDatabasePublishHeader.h"
#endif

//简单的网络请求
#if GYD_FOUNDATION_USED_HTTPCONNECT == 1
#import "GYDSimpleHttpConnect.h"
#endif

//json-model互转
#if GYD_FOUNDATION_USED_JSON_OBJECT == 1
#import "NSObject+GYDJSONObject.h"
#endif

//组件化接口
#if GYD_FOUNDATION_USED_MODULE_INTERFACE == 1
#import "GYDModuleInterfaceDelegate.h"
#endif



@protocol GYDFoundationLogDelegate <NSObject>

@optional
/**
 函数发生了错误，应该立刻解决。
 如果不实现则是：NSAssert(0, @"** GYDFoundation Error ** %s %zd %@", fun, line, errorString);
 */
- (void)function:(nonnull const char *)fun line:(NSInteger)line makeError:(nonnull NSString *)errorString;

/**
 函数发出了警告，需要注意
 如果不实现则是：NSLog(@"** GYDFoundation Warning ** %s %zd %@", fun, line, warningString);
 */
- (void)function:(nonnull const char *)fun line:(NSInteger)line makeWarning:(nonnull NSString *)warningString;

/**
 打印信息，默认关闭，如需开启，subspec 加上 Development
 如果不实现则是：NSLog(@"** GYDFoundation Info ** %s %zd %@", fun, line, infoString);
 */
- (void)function:(nonnull const char *)fun line:(NSInteger)line makeInfo:(nonnull NSString *)infoString;

@end

@interface GYDFoundation : NSObject

/** 用来处理错误 */
@property (nonatomic, class, nullable) id<GYDFoundationLogDelegate>delegate;


@end
