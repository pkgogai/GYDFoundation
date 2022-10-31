//
//  GYDFile.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/8/21.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDFile.h"

@implementation GYDFile

/** 确保指定目录存在（不存在就尝试创建） */
+ (BOOL)makeSureDirectoryAtPath:(nonnull NSString *)path errorMessage:(NSString * _Nonnull * _Nullable)errorMessage {
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        if (!isDir) {
            if (errorMessage) {
                *errorMessage = [NSString stringWithFormat:@"目录被文件占用：%@", path];
            }
            return NO;
        }
    } else {
        NSError *error = nil;
        BOOL r = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (!r) {   //创建失败的情况：例如路径上某层被文件名占用
            if (errorMessage) {
                *errorMessage = [NSString stringWithFormat:@"目录创建失败：%@", error.localizedDescription];
            }
            return NO;
        }
    }
    return YES;
}

/** 确保指定文件存在（不存在就尝试创建，包括路径上的目录），注意：是文件不是目录 */
+ (BOOL)makeSureFileAtPath:(nonnull NSString *)path errorMessage:(NSString * _Nullable * _Nullable)errorMessage {
    BOOL isDir = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        //如果路径存在，要检查是不是个文件
        if (isDir) {
            if (errorMessage) {
                *errorMessage = [NSString stringWithFormat:@"文件被目录占用：%@", path];
            }
            return NO;
        }
    } else {
        NSString *dirPath = [path stringByDeletingLastPathComponent];
        if (![self makeSureDirectoryAtPath:dirPath errorMessage:errorMessage]) {
            return NO;
        }
        BOOL r = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
        if (!r) {
            if (errorMessage) {
                *errorMessage = [NSString stringWithFormat:@"文件创建失败：%@", path];
            }
        }
    }
    return YES;
}

/** 深度遍历文件 */
+ (void)enumPath:(NSString *)path usingBlock:(void (NS_NOESCAPE ^)(NSString * _Nonnull, NSString * _Nonnull, BOOL * _Nonnull))block {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDirectoryEnumerator<NSString *> *en = [manager enumeratorAtPath:path];
    
    BOOL stop = NO;
    for (NSString *filePath in en) {
        NSString *fileName = [filePath lastPathComponent];
        NSString *fullPath = [path stringByAppendingPathComponent:filePath];
        block(fileName, fullPath, &stop);
        if (stop) {
            return;
        }
    }
}

/** 如果同名则加后缀，先是1~500，之后随机500次，如果1000次都有重名，就放弃 */
+ (nullable NSString *)emptyPathWithPath:(nonnull NSString *)path errorMessage:(NSString * _Nullable * _Nullable)errorMessage {
    NSString *dir = [path stringByDeletingLastPathComponent];
    NSString *lastPath = [path lastPathComponent];
    NSString *fileName = [lastPath stringByDeletingPathExtension];
    NSString *ext = [lastPath pathExtension];
    
    for (int i = 1; [[NSFileManager defaultManager] fileExistsAtPath:path]; i++) {
        if (i >= 1000) {
            *errorMessage = @"没找到可用路径";
            return nil;
        }
        path = [dir stringByAppendingPathComponent:fileName];
        path = [path stringByAppendingFormat:@"(%d)", i < 500 ? i : rand()];
        if (ext.length > 0) {
            path = [path stringByAppendingPathExtension:ext];
        }
    }
    return path;
}

@end
