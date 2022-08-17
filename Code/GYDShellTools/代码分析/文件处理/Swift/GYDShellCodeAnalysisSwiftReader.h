//
//  GYDShellCodeAnalysisSwiftReader.h
//  GYDFoundation
//
//  Created by gongyadong on 2021/11/2.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDShellCodeAnalysisReader.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellCodeAnalysisSwiftReader : GYDShellCodeAnalysisReader

+ (NSMutableArray<GYDShellCodeAnalysisReaderWord *> *)wordArrayWithFile:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
