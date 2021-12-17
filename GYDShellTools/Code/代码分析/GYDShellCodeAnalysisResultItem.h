//
//  GYDShellCodeAnalysisResultItem.h
//  GYDFoundation
//
//  Created by gongyadong on 2021/10/28.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+GYDJSONObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellCodeAnalysisResultCategoryItem : NSObject

GYDJSONProperty(NSString *, typeName);

GYDJSONProperty(NSString *, categoryName);

GYDJSONProperty(NSString *, desc);

GYDJSONProperty(NSString *, createTime);

GYDJSONProperty(NSString *, author);

GYDJSONProperty(NSString *, fileName);

@property (nonatomic, strong) NSMutableSet<NSString *> *includeTypes;

@end

@interface GYDShellCodeAnalysisResultClassItem : NSObject

GYDJSONProperty(NSString *, typeName);

GYDJSONPropertyArray(NSString, *, superClassArray);

GYDJSONProperty(BOOL, hasLoadFun);

@property (nonatomic, strong) NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultCategoryItem *> *allCategory;

+ (void)saveModelDictionary:(NSDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *)modelDic toFile:(NSString *)filePath;

+ (NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *)loadModelDictionaryFromFile:(NSString *)filePath;

@end




NS_ASSUME_NONNULL_END
