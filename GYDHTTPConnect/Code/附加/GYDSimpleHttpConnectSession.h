//
//  GYDSimpleHttpConnectSession.h
//  GYDHttpConnect
//
//  Created by 宫亚东 on 2017/11/28.
//  Copyright © 2017年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYDSimpleHttpConnectSession : NSObject

/** 等同于 - initWithConfiguration:nil delegateQueue:nil */
- (nonnull instancetype)init;

/** configuration默认使用 [NSURLSessionConfiguration defaultSessionConfiguration]，queue默认使用当前线程队列 */
- (nonnull instancetype)initWithConfiguration:(nullable NSURLSessionConfiguration *)configuration delegateQueue:(nullable NSOperationQueue *)queue NS_DESIGNATED_INITIALIZER;

@end
