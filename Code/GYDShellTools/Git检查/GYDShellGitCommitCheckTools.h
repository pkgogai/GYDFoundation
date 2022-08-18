//
//  GYDShellGitCommitCheckTools.h
//  GYDFoundation
//
//  Created by gongyadong on 2022/1/18.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDShellFeishuMessageItem.h"

NS_ASSUME_NONNULL_BEGIN
//先临时加个delegate让pod通过检查
@protocol GYDShellGitCommitCheckToolsDelegate <NSObject>

- (NSString *)feishuUserForGitAuther:(NSString *)author;

- (NSString *)feishuUserIDForUserName:(NSString *)name;

- (BOOL)sendMessageToUser:(NSString *)user withTitle:(NSString *)title messageArray:(NSArray<GYDShellFeishuMessageItem *> *)messages output:(out NSString * _Nullable * _Nullable)output;

@end

@interface GYDShellGitCommitCheckTools : NSObject

@property (nonatomic, weak) id<GYDShellGitCommitCheckToolsDelegate> delegate;
/** 配置文件 */
@property (nonatomic) NSString *notesPath;

/** git路径 */
@property (nonatomic) NSString *gitRootPath;

/** 飞书发给谁 */
@property (nonatomic) NSString *sendTo;

/** 进行检查 */
- (int)check;

@end

NS_ASSUME_NONNULL_END
