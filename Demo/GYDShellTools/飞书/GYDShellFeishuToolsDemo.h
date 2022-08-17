//
//  GYDShellFeishuToolsDemo.h
//  GYDDevelopment
//
//  Created by gongyadong on 2022/2/10.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDShellFeishuMessageItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellFeishuToolsDemo : NSObject

+ (int)exampleMainArgc:(int)argc argv:(const char * _Nonnull * _Nonnull)argv;

+ (instancetype)sharedInstance;

- (BOOL)setConfigFilePath:(NSString *)path;

- (NSString *)feishuUserWithGitAuthor:(NSString *)author;

/** 获取飞书用户id，可用于消息里的@操作 */
- (NSString *)idForUserName:(NSString *)userName;

/** 发送消息 */
- (BOOL)sendMessageToUser:(NSString *)user withTitle:(NSString *)title messageItemArray:(NSArray<GYDShellFeishuMessageItem *> *)messageItemArray output:(out NSString * _Nullable * _Nullable)output;

@end

NS_ASSUME_NONNULL_END
