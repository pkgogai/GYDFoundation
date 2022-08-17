//
//  GYDShellTinifyTools.h
//  GYDFoundation
//
//  Created by gongyadong on 2020/12/16.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellTinifyTools : NSObject

/**
 每个key每月有500免费次数。一次性多给几个，内部自动切换
 */
@property (nonatomic, copy, nullable) NSArray<NSString *> *apiKeys;

/**
 压缩一张图片
 */
- (nullable NSData *)imageDataForCompressImageData:(nonnull NSData *)imageData output:(out NSString * _Nullable * _Nullable)output;

/**
 批量压缩一个目录中的图片并直接替换
 @param path 目录路径
 @param resursive 目录是否递归查找
 @param filePath 记录处理状态到文件，以便下次跳过已处理的文件
 */
- (BOOL)compressImagesAtPath:(nonnull NSString *)path resursive:(BOOL)resursive historyFile:(nullable NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
