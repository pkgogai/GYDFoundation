//
//  GYDShellCodeAnalysisUnusedCodeTools.h
//  GYDFoundation
//
//  Created by gongyadong on 2021/11/16.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDShellCodeAnalysisResultItem.h"
#import "GYDShellCodeAnalysisConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellCodeAnalysisUnusedCodeTools : NSObject


@property (nonatomic) GYDShellCodeAnalysisCleanCodeConfig *config;

- (NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *)unusedClassesWithAllData:(NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *)allClassData;


- (NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *)maybeUnusedClassesWithAllData:(NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *)allClassData;

- (void)logUnusedClasses:(NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *)unusedClasses toFile:(NSString *)file;

@end

NS_ASSUME_NONNULL_END
