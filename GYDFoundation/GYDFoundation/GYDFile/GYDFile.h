//
//  GYDFile.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/8/21.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSUInteger, GYDFileCreatResult) {
//    GYDFileCreatResultSuccess,
//    GYDFileCreatResultExist,
//    GYDFileCreatResultError,
//};

//typedef NS_ENUM(NSUInteger, GYDFileOpenMode) {
//    GYDFileOpenModeForReading = 1,
//    GYDFileOpenModeForWriting = 1<<1,
//    GYDFileOpenModeForUpdating = GYDFileOpenModeForReading | GYDFileOpenModeForWriting,
//
//    GYDFileOpenModeOnlyCreate = 1<<2,
//    GYDFileOpenModeOnlyOpen  = 1<<3,
//    GYDFileOpenModeCreateOrOpen = GYDFileOpenModeOnlyCreate | GYDFileOpenModeOnlyOpen,
//};

/**
 不能因为创建文件时路径被占用就把别人的东西删除，所以错误信息除了看看外没有处理价值，有错误就自己老老实实的换个路径吧
 */
@interface GYDFile : NSObject

/** 确保指定目录存在（不存在就尝试创建） */
+ (BOOL)makeSureDirectoryAtPath:(nonnull NSString *)path errorMessage:(NSString * _Nullable * _Nullable)errorMessage;

/** 确保指定文件存在（不存在就尝试创建，包括路径上的目录），注意：是文件不是目录 */
+ (BOOL)makeSureFileAtPath:(nonnull NSString *)path errorMessage:(NSString * _Nullable * _Nullable)errorMessage;

@end
