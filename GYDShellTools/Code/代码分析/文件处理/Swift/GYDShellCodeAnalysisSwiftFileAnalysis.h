//
//  GYDShellCodeAnalysisSwiftFileAnalysis.h
//  GYDFoundation
//
//  Created by gongyadong on 2021/11/2.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDShellCodeAnalysisFileAnalysisResultItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellCodeAnalysisSwiftFileAnalysis : NSObject

+ (NSArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *)preprocessFileAtPath:(NSString *)path;

- (NSArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *)preprocessFileAtPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
