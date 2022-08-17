//
//  GYDShellGitCommitConfig.h
//  GYDFoundation
//
//  Created by gongyadong on 2022/1/18.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+GYDJSONObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellGitCommitConfig : NSObject

- (instancetype)initWithFileAtPath:(NSString *)filePath;

- (NSInteger)weeks;

/** 分支是否符合记录条件 */
- (BOOL)matchBrach:(NSString *)brach;

- (BOOL)containsCommit:(NSString *)commit;

- (void)addCommit:(NSString *)commit forBrach:(NSString *)brach;

/** 判断文件是否需要检查 */
- (BOOL)matchFilePath:(NSString *)filePath;

- (void)saveIfNeeded;

@end

NS_ASSUME_NONNULL_END
