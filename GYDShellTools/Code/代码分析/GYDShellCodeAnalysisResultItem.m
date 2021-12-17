//
//  GYDShellCodeAnalysisResultItem.m
//  GYDFoundation
//
//  Created by gongyadong on 2021/10/28.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDShellCodeAnalysisResultItem.h"

@interface GYDShellCodeAnalysisResultCategoryItem ()

/** 内部转JSON用 */
GYDJSONPropertyArray(NSString, *, includes);

@end

@implementation GYDShellCodeAnalysisResultCategoryItem

+ (instancetype)gyd_modelWithJSONDictionary:(NSDictionary *)dic {
    GYDShellCodeAnalysisResultCategoryItem *model = [super gyd_modelWithJSONDictionary:dic];
    model.includeTypes = [NSMutableSet setWithArray:model.includes];
    model.includes = nil;
    return model;
}

- (NSMutableDictionary *)gyd_JSONDictionary {
    self.includes = [self.includeTypes allObjects];
    NSMutableDictionary *dic = [super gyd_JSONDictionary];
    self.includes = nil;
    return dic;
}

@end


@interface GYDShellCodeAnalysisResultClassItem ()

/** 内部转JSON用 */
GYDJSONPropertyArray(GYDShellCodeAnalysisResultCategoryItem, *, categories);

@end

@implementation GYDShellCodeAnalysisResultClassItem

+ (instancetype)gyd_modelWithJSONDictionary:(NSDictionary *)dic {
    GYDShellCodeAnalysisResultClassItem *model = [super gyd_modelWithJSONDictionary:dic];
    model.allCategory = [NSMutableDictionary dictionaryWithCapacity:model.categories.count];
    for (GYDShellCodeAnalysisResultCategoryItem *item in model.categories) {
        model.allCategory[item.categoryName ?: @""] = item;
    }
    model.categories = nil;
    return model;
}

- (NSMutableDictionary *)gyd_JSONDictionary {
    self.categories = [self.allCategory allValues];
    NSMutableDictionary *dic = [super gyd_JSONDictionary];
    self.categories = nil;
    return dic;
}



+ (void)saveModelDictionary:(NSDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *)modelDic toFile:(NSString *)filePath {
    @autoreleasepool {
        NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
        [modelDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            jsonDic[key] = [obj gyd_JSONDictionary];
        }];
        
        [jsonDic writeToFile:filePath atomically:YES];
    }
}

+ (NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *)loadModelDictionaryFromFile:(NSString *)filePath {
    NSMutableDictionary *modelDic = [NSMutableDictionary dictionary];
    @autoreleasepool {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            GYDShellCodeAnalysisResultClassItem *item = [GYDShellCodeAnalysisResultClassItem gyd_modelWithJSONDictionary:obj];
            modelDic[item.typeName] = item;
        }];
    }
    return modelDic;
}

@end
