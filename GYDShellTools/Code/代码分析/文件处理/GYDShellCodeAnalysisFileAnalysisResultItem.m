//
//  GYDShellCodeAnalysisFileAnalysisResultItem.m
//  GYDFoundation
//
//  Created by gongyadong on 2021/11/1.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDShellCodeAnalysisFileAnalysisResultItem.h"

@interface GYDShellCodeAnalysisFileAnalysisResultItem ()

/** 内部转JSON用 */
GYDJSONPropertyArray(NSString, *, includes);

@end


@implementation GYDShellCodeAnalysisFileAnalysisResultItem

+ (instancetype)gyd_modelWithJSONDictionary:(NSDictionary *)dic {
    GYDShellCodeAnalysisFileAnalysisResultItem *model = [super gyd_modelWithJSONDictionary:dic];
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

+ (void)saveModelArray:(NSMutableArray *)dataArray toFile:(NSString *)filePath {
    NSArray *jsonArray = [GYDShellCodeAnalysisFileAnalysisResultItem gyd_JSONArrayWithModelArray:dataArray];
    [jsonArray writeToFile:filePath atomically:YES];
}

+ (NSMutableArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *)loadModelArrayFromFile:(NSString *)filePath {
    NSArray *jsonArray = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *modelArray = [GYDShellCodeAnalysisFileAnalysisResultItem gyd_modelArrayWithJSONArray:jsonArray];
    return modelArray;
}


@end
