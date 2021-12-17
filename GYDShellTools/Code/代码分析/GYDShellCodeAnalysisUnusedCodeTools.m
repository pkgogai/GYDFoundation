//
//  GYDShellCodeAnalysisUnusedCodeTools.m
//  GYDFoundation
//
//  Created by gongyadong on 2021/11/16.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDShellCodeAnalysisUnusedCodeTools.h"
#import "GYDFoundationPrivateHeader.h"
#import "NSString+GYDString.h"


@implementation GYDShellCodeAnalysisUnusedCodeTools



- (NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *)unusedClassesWithAllData:(NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *)allClassData {
    NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *unusedClass = [allClassData mutableCopy];
    [unusedClass removeObjectForKey:@"AppDelegate"];
    [unusedClass removeObjectForKey:@"Swift"];
    [unusedClass removeObjectForKey:@"Xib+Storyboard"];
    
    [allClassData enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, GYDShellCodeAnalysisResultClassItem * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.hasLoadFun) {
            [unusedClass removeObjectForKey:key];
        }
        [obj.allCategory enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, GYDShellCodeAnalysisResultCategoryItem * _Nonnull cate, BOOL * _Nonnull stop) {
            for (NSString *type in cate.includeTypes) {
                if ([type isEqualToString:@"activityOfCompanyPositionView"]) {
                    NSLog(@"");
                }
                [unusedClass removeObjectForKey:type];
            }
        }];
    }];
    
    for (NSString *key in unusedClass.allKeys) {
        for (NSString *whiteListItem in self.config.whiteList) {
            if ([key gyd_matchingWildcardString:whiteListItem]) {
                [unusedClass removeObjectForKey:key];
                break;
            }
        }
    }
    
    return unusedClass;
}

- (NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *)maybeUnusedClassesWithAllData:(NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *)allClassData {
    NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *unusedClass = [allClassData mutableCopy];
    
    //2021年12月17日 remove 用array月0.0345秒，用set月0.07秒
    NSMutableSet<NSString *> *waitRemoveSet = [NSMutableSet set];
    [waitRemoveSet addObject:@"AppDelegate"];
    [waitRemoveSet addObject:@"Swift"];
    [waitRemoveSet addObject:@"Xib+Storyboard"];
    [allClassData enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, GYDShellCodeAnalysisResultClassItem * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.hasLoadFun) {
            [waitRemoveSet addObject:key];
            return;
        }
        for (NSString *whiteListItem in self.config.whiteList) {
            if ([key gyd_matchingWildcardString:whiteListItem]) {
                [waitRemoveSet addObject:key];
                break;
            }
        }
    }];

    while (waitRemoveSet.count > 0) {
        NSString *type = [waitRemoveSet anyObject];
        [waitRemoveSet removeObject:type];
        [unusedClass removeObjectForKey:type];
        GYDShellCodeAnalysisResultClassItem *item = allClassData[type];
        [item.allCategory enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, GYDShellCodeAnalysisResultCategoryItem * _Nonnull cate, BOOL * _Nonnull stop) {
            for (NSString *type in cate.includeTypes) {
                if (unusedClass[type]) {
                    [waitRemoveSet addObject:type];
                }
            }
        }];
    }
    return unusedClass;
    
}

- (void)logUnusedClasses:(NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *)unusedClasses toFile:(NSString *)file {
    
    NSDictionary *authorNameMap = @{
        @"NandaDong" : @"董慧翔",
        @"Nanda Dong" : @"董慧翔",
        @"董慧翔" : @"董慧翔",
        @"任崇庆" : @"任崇庆",
        @"Chris" : @"任崇庆",
        @"gongyadong" : @"宫亚东",
        @"宫亚东" : @"宫亚东",
        @"sharui" : @"沙睿",
        @"沙睿" : @"沙睿",
        @"MJ" : @"马健",
        @"jonkersun" : @"孙鹏程",
        @"Easy" : @"葛少玉",
        @"葛少玉" : @"葛少玉",
    };
//    NSDictionary *authorNameMap = @{
//        @"宫亚东" : @[@"宫亚东", @"gongyadong"],
//        @"任崇庆" : @[@"任崇庆", @"Chris"],
//        @"马健" : @[@"马健", @"MJ"],
//        @"沙睿" : @[@"沙睿", @"sharui"],
//        @"董慧翔" : @[@"董慧翔", @"NandaDong", @"Nanda Dong"],
//        @"孙鹏程" : @[@"jonkersun"],
//        @"葛少玉" : @[@"葛少玉", @"Easy"]
//    };
    NSMutableArray *authorOrderArray = [NSMutableArray array];
    NSMutableDictionary *authorDic = [NSMutableDictionary dictionary];
    [unusedClasses enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, GYDShellCodeAnalysisResultClassItem * _Nonnull obj, BOOL * _Nonnull stop) {
        GYDShellCodeAnalysisResultCategoryItem *cate = obj.allCategory[@""];
        if (!cate) {
            GYDFoundationWarning(@"没找到本类:%@", key);
            return;
        }
        //别人的sdk，忽略掉
        if ([cate.author isEqualToString:@"ibireme"]) {
            return;
        }
        NSString *author = cate.author ?: @"";
        NSString *realAuthor = authorNameMap[author];
        if (realAuthor) {
            author = realAuthor;
        }
        NSMutableArray *arr = authorDic[author];
        if (!arr) {
            arr = [NSMutableArray array];
            authorDic[author] = arr;
            if (realAuthor) {
                [authorOrderArray insertObject:author atIndex:0];
            } else {
                [authorOrderArray addObject:author];
            }
        }
        [arr addObject:obj];
    }];
    NSMutableString *output = [NSMutableString string];
    
    for (NSString *author in authorOrderArray) {
        NSArray *array = authorDic[author];
        if (array.count > 0) {
            [output appendFormat:@"%@：%3zd个\n", author, array.count];
        }
    }
    for (NSString *author in authorOrderArray) {
        NSArray *array = authorDic[author];
        if (array.count > 0) {
            [output appendFormat:@"----- %@ =%3zd个 -----\n", author, array.count];
            for (GYDShellCodeAnalysisResultClassItem *item in array) {
                [output appendFormat:@"%-30s", [item.typeName cStringUsingEncoding:NSUTF8StringEncoding]];
                for (GYDShellCodeAnalysisResultCategoryItem *cate in item.allCategory.allValues) {
                    [output appendFormat:@"《%s》", [cate.fileName cStringUsingEncoding:NSUTF8StringEncoding]];
                    if (cate.desc.length > 0) {
                        [output appendFormat:@"%@", cate.desc];
                    }
                }
                [output appendFormat:@"\n"];
            }
        } else {
            [output appendFormat:@"----- %20s 无 -----\n", [author cStringUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    GYDFoundationInfo(@"%@", output);
    if (file) {
        [output writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
}
@end
