//
//  GYDShellCodeAnalysisFileAnalysisResultItem.h
//  GYDFoundation
//
//  Created by gongyadong on 2021/11/1.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+GYDJSONObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellCodeAnalysisFileAnalysisResultItem : NSObject

GYDJSONProperty(NSString *, itemClass);

GYDJSONProperty(NSString *, category);

GYDJSONProperty(NSString *, superClassName);

GYDJSONProperty(NSString *, desc);

GYDJSONProperty(NSString *, createTime);

GYDJSONProperty(NSString *, author);

GYDJSONProperty(NSString *, fileName);

GYDJSONProperty(BOOL, hasLoadFun);

@property (nonatomic, strong) NSMutableSet<NSString *> *includeTypes;

+ (void)saveModelArray:(NSMutableArray *)dataArray toFile:(NSString *)filePath;

+ (NSMutableArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *)loadModelArrayFromFile:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
