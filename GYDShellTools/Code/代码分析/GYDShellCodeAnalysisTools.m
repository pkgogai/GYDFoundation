//
//  GYDShellCodeAnalysisTools.m
//  GYDFoundation
//
//  Created by gongyadong on 2021/10/19.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDShellCodeAnalysisTools.h"
#import "GYDFoundationPrivateHeader.h"
#import "GYDShellCodeAnalysisFileAnalysis.h"
#import "GYDShellCodeAnalysisResultItem.h"
#import "GYDShellCodeAnalysisRouteTools.h"
#import "GYDShellCodeAnalysisSwiftFileAnalysis.h"
#import "GYDShellCodeAnalysisXibFileAnalysis.h"
#import "GYDShellCodeAnalysisConfig.h"
#import "GYDShellCodeAnalysisUnusedCodeTools.h"

@implementation GYDShellCodeAnalysisTools
{
    GYDShellCodeAnalysisConfig *_config;
    
    NSString *_rootPath;    //根路径
    
    NSString *_cachePath;   //缓存路径
    NSString *_cacheCopyFilePath;   //复制文件到此路径
    
    NSString *_resultPath;  //存放结果的目录
    NSString *_resultSourceDataFilePath;    //解析出来的原始信息
    NSString *_resultClassDataFilePath;     //进一步处理成类的信息
    NSString *_resultUnusedClassFilePath;   //未使用类的信息
    NSString *_resultMaybeUnusedClassFilePath;   //未使用类的信息
    
    NSMutableDictionary *_allFiles;
    
}

/** 默认处理 */
- (void)defaultAction {
    
    [self loadConfig];
    
    [self analysisFiles];
    
    [self findUnusedClass];
    
    [self planRoute];
    
}

- (void)loadConfig {
    _config = [GYDShellCodeAnalysisConfig loadModelFromFile:self.configPath];
    _rootPath = _config.basePath;
    if ([_rootPath hasPrefix:@"/"] || [_rootPath hasPrefix:@"~/"]) {
        
    } else if ([_rootPath hasPrefix:@"./"]) {
        _rootPath = [[self.configPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:_rootPath];
    } else {
        GYDFoundationError(@"根路径要以“/”或“~/”或“./”开头");
        exit(0);
    }
    
    _cachePath = [_rootPath stringByAppendingPathComponent:_config.cachePath];
    _cacheCopyFilePath = [_cachePath stringByAppendingPathComponent:@"files"];
    
    _resultPath = [_rootPath stringByAppendingPathComponent:_config.resultPath];
    
    _resultSourceDataFilePath = [_resultPath stringByAppendingPathComponent:@"SourceData.plist"];
    _resultClassDataFilePath = [_resultPath stringByAppendingPathComponent:@"ClassData.plist"];
    _resultUnusedClassFilePath = [_resultPath stringByAppendingPathComponent:@"Unused.txt"];
    _resultMaybeUnusedClassFilePath = [_resultPath stringByAppendingPathComponent:@"MaybeUnused.txt"];
}

- (void)analysisFiles {
    [self clear];
    
    for (NSString *filePath in [_config.codePaths copy]) {
        [self addFileFromPath:[_rootPath stringByAppendingPathComponent:filePath]];
    }
    NSString *errorMsg = nil;
    BOOL r = [GYDFile makeSureDirectoryAtPath:_resultPath errorMessage:&errorMsg];
    if (!r) {
        GYDFoundationError(@"缓存目录创建失败：%@", errorMsg);
        return;
    }
    
    NSMutableArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *resultArray = [self preprocessCacheFiles];
    [GYDShellCodeAnalysisFileAnalysisResultItem saveModelArray:resultArray toFile:_resultSourceDataFilePath];
    
    NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *dic = [self cleanResultArray:resultArray];
    [GYDShellCodeAnalysisResultClassItem saveModelDictionary:dic toFile:_resultClassDataFilePath];
}

- (void)findUnusedClass {
    NSString *errorMsg = nil;
    BOOL r = [GYDFile makeSureDirectoryAtPath:_resultPath errorMessage:&errorMsg];
    if (!r) {
        GYDFoundationError(@"缓存目录创建失败：%@", errorMsg);
        return;
    }
    
    NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *allData = [GYDShellCodeAnalysisResultClassItem loadModelDictionaryFromFile:_resultClassDataFilePath];
    
    GYDShellCodeAnalysisUnusedCodeTools *unusedCodeTools = [[GYDShellCodeAnalysisUnusedCodeTools alloc] init];
    unusedCodeTools.config = _config.cleanCode;
    
    NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *unusedClass = [unusedCodeTools unusedClassesWithAllData:allData];
    
    NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *maybeUnusedClass = [unusedCodeTools maybeUnusedClassesWithAllData:allData];
    
    for (NSString *key in unusedClass) {
        [maybeUnusedClass removeObjectForKey:key];
    }
    [unusedCodeTools logUnusedClasses:unusedClass toFile:_resultUnusedClassFilePath];
    [unusedCodeTools logUnusedClasses:maybeUnusedClass toFile:_resultMaybeUnusedClassFilePath];
}

- (void)planRoute {
    NSString *errorMsg = nil;
    BOOL r = [GYDFile makeSureDirectoryAtPath:_resultPath errorMessage:&errorMsg];
    if (!r) {
        GYDFoundationError(@"缓存目录创建失败：%@", errorMsg);
        return;
    }
    
    NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *allData = [GYDShellCodeAnalysisResultClassItem loadModelDictionaryFromFile:_resultClassDataFilePath];
    
    GYDShellCodeAnalysisRouteTools *tools = [[GYDShellCodeAnalysisRouteTools alloc] init];
    NSMutableSet<NSString *> *keepClassArray = [self keepClassArrayWithCleanData:allData];
    [keepClassArray addObject:@"LGWebView"];
    [keepClassArray addObject:@"AppDelegate"];
    [keepClassArray addObject:@"LGUrlJumpManager"];

    [tools planRouteWithDataDic:allData keepClassArray:keepClassArray];
    
    [tools logType:@"LGLargeCompanyDetailViewController"];
    
}



/** 清除干净 */
- (BOOL)clear {
    _allFiles = nil;
    if (!_cachePath) {
        GYDFoundationError(@"没设置缓存路径");
        return NO;
    }
    NSError *error = nil;
    BOOL r = [[NSFileManager defaultManager] removeItemAtPath:_cachePath error:&error];
    if (!r) {
        GYDFoundationError(@"%@", [error localizedDescription]);
    }
    return r;
}

/** 以目录为单位添加要分析的文件 */
- (void)addFileFromPath:(NSString *)path {
    NSString *errorMsg = nil;
    BOOL r = [GYDFile makeSureDirectoryAtPath:_cacheCopyFilePath errorMessage:&errorMsg];
    if (!r) {
        GYDFoundationError(@"缓存目录创建失败：%@", errorMsg);
        return;
    }
    
    if (!_allFiles) {
        _allFiles = [NSMutableDictionary dictionary];
    }
    NSArray *extArray = @[@"h", @"m", @"swift", @"storyboard", @"xib"];

    [GYDFile enumPath:path usingBlock:^(NSString * _Nonnull fileName, NSString * _Nonnull fullPath, BOOL * _Nonnull stop) {
        NSDictionary<NSFileAttributeKey, id> *fileAtt = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
        NSString *fileType = [GYDDictionary stringForKey:NSFileType inDictionary:fileAtt];
        if (![fileType isEqualToString:NSFileTypeRegular]) {
            return;
        }
        NSString *ext = [fileName pathExtension];
        if (!ext) {
            return;
        }
        if (![extArray containsObject:ext]) {
            return;
        }
        
        NSString *toPath = [_cacheCopyFilePath stringByAppendingPathComponent:fileName];
        
        NSError *er = nil;
        BOOL r = [[NSFileManager defaultManager] copyItemAtPath:fullPath toPath:toPath error:&er];
        if (!r) {
            GYDFoundationWarning(@"%@", [er localizedDescription]);
            return;
        }
        _allFiles[fileName] = toPath;
    }];
}

#pragma mark - 文件解析

/** 解析缓存文件 */
- (NSMutableArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *)preprocessCacheFiles {
    NSMutableArray *allFilePath = [NSMutableArray array];

    @autoreleasepool {
        [GYDFile enumPath:_cacheCopyFilePath usingBlock:^(NSString * _Nonnull fileName, NSString * _Nonnull fullPath, BOOL * _Nonnull stop) {
            NSArray *extArray = @[@"h", @"m", @"swift", @"storyboard", @"xib"];
            NSString *ext = [fileName pathExtension];
            if (!ext) {
                return;
            }
            if (![extArray containsObject:ext]) {
                return;
            }
            [allFilePath addObject:fullPath];
        }];
    }

//    NSArray *allFilePath = _allFiles.allObjects;
    
    NSMutableArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *resultArray = [self resultArrayByPreprocessFilePathArray:allFilePath];
    return resultArray;
}

- (NSMutableArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *)resultArrayByPreprocessFilePathArray:(NSArray<NSString *> *)filePathArray {

    NSMutableArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *resultArray = [NSMutableArray array];
    __block NSInteger fileIndex = 0;
    NSLock *lock = [[NSLock alloc] init];

    dispatch_queue_t queue = dispatch_queue_create("", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 9; i++) {
        dispatch_async(queue, ^{
            while (1) {

                NSString *filePath = nil;
                [lock lock];
                
                if (fileIndex % 100 == 0) {
                    printf("当前进度(%zd/%zd)\n", fileIndex, filePathArray.count);
                }
                if (fileIndex < filePathArray.count) {
                    filePath = filePathArray[fileIndex];
                    fileIndex++;
                }
                [lock unlock];
                if (!filePath) {
                    break;
                }
                @autoreleasepool {
                    NSArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *array = nil;
                    if ([filePath.pathExtension isEqualToString:@"swift"]) {
                        array = [GYDShellCodeAnalysisSwiftFileAnalysis preprocessFileAtPath:filePath];
                    } else if ([filePath.pathExtension isEqualToString:@"xib"] || [filePath.pathExtension isEqualToString:@"storyboard"]) {
                        array = [GYDShellCodeAnalysisXibFileAnalysis preprocessFileAtPath:filePath];
                    } else {
                        array = [GYDShellCodeAnalysisFileAnalysis preprocessFileAtPath:filePath];
                    }
                    [lock lock];
                    [resultArray addObjectsFromArray:array];
                    [lock unlock];
                }
            }
        });
    }
    dispatch_barrier_sync(queue, ^{
    });
    return resultArray;
}

/** 进一步处理和类有关的信息 */
- (NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *)cleanResultArray:(NSMutableArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *)resultArray {
    
    NSMutableSet *allClass = [NSMutableSet set];
    for (GYDShellCodeAnalysisFileAnalysisResultItem *item in resultArray) {
        if (item.itemClass.length > 0) {
            [allClass addObject:item.itemClass];
        }
    }
    NSMutableDictionary *superClassDic = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (GYDShellCodeAnalysisFileAnalysisResultItem *item in resultArray) {
        GYDShellCodeAnalysisResultClassItem *cla = dic[item.itemClass ?: @""];
        if (!cla) {
            cla = [[GYDShellCodeAnalysisResultClassItem alloc] init];
            cla.typeName = item.itemClass;
            dic[item.itemClass ?: @""] = cla;
        }
        if (item.hasLoadFun) {
            cla.hasLoadFun = YES;
        }
        GYDShellCodeAnalysisResultCategoryItem *cate = cla.allCategory[item.category ?: @""];
        if (!cate) {
            cate = [[GYDShellCodeAnalysisResultCategoryItem alloc] init];
            if (!cla.allCategory) {
                cla.allCategory = [NSMutableDictionary dictionary];
            }
            cla.allCategory[item.category ?: @""] = cate;
            cate.typeName = item.itemClass;
            cate.categoryName = item.category;
            cate.includeTypes = [NSMutableSet set];
        }
        if (item.superClassName.length > 0) {
            if (superClassDic[item.itemClass]) {
                GYDFoundationWarning(@"类：%@,有重复的父类声明：%@,%@。", item.itemClass, superClassDic[item.itemClass], item.superClassName);
            }
            superClassDic[item.itemClass] = item.superClassName;
        }
        
        if ([item.fileName hasSuffix:@".h"]) {
            if (item.desc.length > 0) {
                cate.desc = item.desc;
            }
            if (item.createTime.length > 0) {
                cate.createTime = item.createTime;
            }
            if (item.author.length > 0) {
                cate.author = item.author;
            }
            if (item.fileName.length > 0) {
                cate.fileName = item.fileName;
            }
        } else {
            if (cate.desc.length < 1) {
                cate.desc = item.desc;
            }
            if (cate.createTime.length < 1) {
                cate.createTime = item.createTime;
            }
            if (cate.author.length < 1) {
                cate.author = item.author;
            }
            if (cate.fileName.length < 1) {
                cate.fileName = item.fileName;
            }
        }
        for (NSString *type in item.includeTypes) {
            if ([allClass containsObject:type]) {
                [cate.includeTypes addObject:type];
            }
        }
    }
    for (GYDShellCodeAnalysisResultClassItem *cla in dic.allValues) {
        NSMutableArray *array = [NSMutableArray array];
        NSString *c = cla.typeName;
        NSInteger i = 0;
        NSArray *breakTypes = @[@"NSObject", @"UITabBarController", @"UIViewController", @"UINavigationController", @"UIView"];
        while (c) {
            if ([breakTypes containsObject:c]) {
                break;
            }
            c = superClassDic[c];
            if (c) {
                [array addObject:c];
            }
            i++;
            if (i >= 10) {
                GYDFoundationWarning(@"继承关系过长:%@:%@", cla.typeName, array);
                break;
            }
        }
        cla.superClassArray = [array copy];
        
    }
    return dic;
}

#pragma mark - 白名单
- (NSMutableSet<NSString *> *)keepClassArrayWithCleanData:(NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *)allDataDic {
    NSMutableSet<NSString *> *allClass = [NSMutableSet set];
    NSArray *keepTypes = @[@"UITabBarController", @"UIViewController", @"UINavigationController"];
    for (GYDShellCodeAnalysisResultClassItem *item in [allDataDic allValues]) {
        if ([keepTypes containsObject:[item.superClassArray lastObject]]) {
            [allClass addObject:item.typeName];
        }
    }
    return allClass;
}





@end
