//
//  GYDShellFeishuTools.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/09/07.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDShellFeishuMessageItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellFeishuTools : NSObject

#pragma mark - 小应用处理

@property (nonatomic)   NSString *appId;
@property (nonatomic)   NSString *appSecret;

//当为nil时，通过appId，appSecret获取，有了值后就直接使用，不考虑有效期了，想要让下次操作重新获取的话就设置为nil，默认nil
@property (nonatomic)   NSString *token;

/** 获取权限，也就是更新token */
- (BOOL)updateTokenOutput:(out NSString * _Nullable * _Nullable)output;

/** 上传图片，返回Key，失败为nil。type是飞书的参数，当图片用在消息中时，type是message */
- (nullable NSString *)imageKeyForUploadImageData:(NSData *)data type:(NSString *)type output:(out NSString * _Nullable * _Nullable)output;

/** 发送消息 */
- (BOOL)sendMessageToChat:(NSString *)chat withTitle:(NSString *)title messageItemArray:(NSArray<GYDShellFeishuMessageItem *> *)messageItemArray output:(out NSString * _Nullable * _Nullable)output;

#pragma mark - 最简单的机器人处理
/** 最简单的发消息，不支持at，不支持富媒体 */
+ (BOOL)sendSimpleMessageToRobot:(NSString *)robot withTitle:(NSString *)title message:(NSString *)message output:(out NSString * _Nullable * _Nullable)output;

@end

NS_ASSUME_NONNULL_END
