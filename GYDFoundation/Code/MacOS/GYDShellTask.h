//
//  GYDShellTask.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2019/8/10.
//

#import <Foundation/Foundation.h>

/*
 todo: 先不分割输出，只要收到通知就解析成字符串并回调，稍后如果发现乱码，就按\n分割解析，余下的用NSData记录凑到下一条消息上。
 */

typedef void(^GYDShellTaskProgressBlock)(NSString * _Nullable outputItem, NSString * _Nullable errorItem);

/**
 使用 /bin/sh 执行命令
 shellPath默认/bin/zsh
 */
@interface GYDShellTask : NSObject

/** 每次执行command时创建，之后输出都积累到这里 */
@property (nonatomic, readonly, strong, nullable) NSMutableString * standardOutput;
@property (nonatomic, readonly, strong, nullable) NSMutableString * standardError;

/** 同步执行，有输出或错误信息时通过 progress 回调 */
- (int)executeShellPath:(nullable NSString *)shellPath command:(nonnull NSString *)command progress:(nullable GYDShellTaskProgressBlock)progress;

/** 执行结束后统一返回，没有中间的过程回调 */
+ (int)executeShellPath:(nullable NSString *)shellPath command:(nonnull NSString *)command standardOutput:(out NSString * _Nullable * _Nullable)output standardError:(out NSString * _Nullable * _Nullable)error;

@end
