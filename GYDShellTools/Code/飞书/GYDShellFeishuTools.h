//
//  GYDShellFeishuTools.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/09/07.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellFeishuTools : NSObject

#pragma mark - 小应用处理

@property (nonatomic)   NSString *appId;
@property (nonatomic)   NSString *appSecret;

//当为nil时，通过appId，appSecret获取，有了值后就直接使用，不考虑有效期了，想要让下次操作重新获取的话就设置为nil，默认nil
@property (nonatomic)   NSString *token;

/** 获取权限，也就是token就是这样获取的 */
- (NSString *)updateTokenOutput:(out NSString * _Nullable * _Nullable)output;

/** 上传图片 */
- (NSString *)uploadImageData:(NSData *)data type:(NSString *)type output:(out NSString * _Nullable * _Nullable)output;

/** 发送消息 */
- (BOOL)sendMessage:(NSDictionary *)message output:(out NSString * _Nullable * _Nullable)output;

/** 发送消息 */
- (BOOL)sendMessageToChat:(NSString *)chat withTitle:(nullable NSString *)title message:(nullable NSString *)message link:(nullable NSString *)link imageData:(nullable NSData *)imageData at:(nullable NSString *)at output:(out NSString * _Nullable * _Nullable)output;

#pragma mark - 最简单的机器人处理
/** 最简单的发消息，不支持at，不支持富媒体 */
+ (BOOL)sendTitle:(NSString *)title message:(NSString *)message toRobot:(NSString *)robot output:(out NSString * _Nullable * _Nullable)output;

@end

NS_ASSUME_NONNULL_END
