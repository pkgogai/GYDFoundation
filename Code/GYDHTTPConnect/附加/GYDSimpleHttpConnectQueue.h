//
//  GYDSimpleHttpConnectQueue.h
//  GYDHttpConnect
//
//  Created by 宫亚东 on 2017/11/28.
//  Copyright © 2017年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYDSimpleHttpConnectQueue : NSObject

@property (nonatomic, copy, readonly, nullable)   NSArray *connectArray;
/** 限制可以同时发起请求的最大数量，>0时有效，否则不限制 */
@property (nonatomic)   NSInteger maxLoadCount;

/** 暂停时，接下来不会再送出新的请求，但已经在发送中的请求还会继续 */
@property (nonatomic, getter=isPause)   BOOL pause;

/** 取消所有的请求 */
- (void)cancelAll;

@end
