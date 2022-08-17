//
//  GYDShellCodeAnalysisConfig.m
//  GYDFoundation
//
//  Created by gongyadong on 2021/11/16.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDShellCodeAnalysisConfig.h"

@implementation GYDShellCodeAnalysisCleanCodeConfig

@end

@implementation GYDShellCodeAnalysisCleanImageConfig

@end

@implementation GYDShellCodeAnalysisCleanPBConfig

@end

@implementation GYDShellCodeAnalysisRouteConfig

@end

@implementation GYDShellCodeAnalysisConfig

+ (instancetype)loadModelFromFile:(NSString *)filePath {
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return [self gyd_modelWithJSONDictionary:dic];
}

@end
