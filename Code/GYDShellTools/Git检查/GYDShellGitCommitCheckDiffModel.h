//
//  GYDShellGitCommitCheckDiffModel.h
//  GYDFoundation
//
//  Created by gongyadong on 2022/1/18.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellGitCommitCheckDiffModel : NSObject

//文件路径
@property (nonatomic) NSString *filePath;

//变动的行号
@property (nonatomic) NSMutableArray *changedLineNumbers;

+ (NSArray<GYDShellGitCommitCheckDiffModel *> *)diffModelArrayWithContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
