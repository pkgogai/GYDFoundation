//
//  GYDShellCodeAnalysisConfig.h
//  GYDFoundation
//
//  Created by gongyadong on 2021/11/16.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+GYDJSONObject.h"

NS_ASSUME_NONNULL_BEGIN

/** 查找无用代码的额外参数 */
@interface GYDShellCodeAnalysisCleanCodeConfig : NSObject

GYDJSONPropertyArray(NSString, *, whiteList);

@end


@interface GYDShellCodeAnalysisCleanImageConfig : NSObject

@end

@interface GYDShellCodeAnalysisCleanPBConfig : NSObject

@end

@interface GYDShellCodeAnalysisRouteConfig : NSObject

@end

/** 代码分析参数配置 */
@interface GYDShellCodeAnalysisConfig : NSObject

/** 根路径，其它路径都是相对这里而言 */
GYDJSONProperty(NSString *, basePath);

/** 用来存储生成信息的缓存目录 */
GYDJSONProperty(NSString *, cachePath);

/** 要处理的文件目录，深度遍历 */
GYDJSONPropertyArray(NSString, *, codePaths);

/** 存放分析结果的目录 */
GYDJSONProperty(NSString *, resultPath);

GYDJSONProperty(GYDShellCodeAnalysisCleanCodeConfig *, cleanCode);

+ (instancetype)loadModelFromFile:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
