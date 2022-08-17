//
//  GYDShellCodeAnalysisTools.h
//  GYDFoundation
//
//  Created by gongyadong on 2021/10/19.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellCodeAnalysisTools : NSObject

@property (nonatomic) NSString *configPath;

/** 默认处理 */
- (void)defaultAction;

/** 根据 configPath 读取配置 */
- (void)loadConfig;

/** 解析文件，会clear */
- (void)analysisFiles;

/** 根据上次解析文件的结果查找没使用的类 */
- (void)findUnusedClass;

/** 根据上次解析文件的结果尝试分析路径 */
- (void)planRoute;

@end

NS_ASSUME_NONNULL_END
