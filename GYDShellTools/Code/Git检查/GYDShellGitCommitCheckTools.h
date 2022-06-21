//
//  GYDShellGitCommitCheckTools.h
//  GYDFoundation
//
//  Created by gongyadong on 2022/1/18.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellGitCommitCheckTools : NSObject

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
