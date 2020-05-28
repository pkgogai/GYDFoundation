//
//  GYDMd5.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2019/8/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYDMd5 : NSObject

#pragma mark - 先初始化

- (instancetype)init;


#pragma mark - 再放入数据

- (void)addString:(nullable NSString *)string;
- (void)addData:(nullable NSData *)data;
/** 文件有可能不存在或者读取失败 */
- (BOOL)addFile:(nullable NSString *)filePath;


#pragma mark - 最后得到md5

- (nonnull NSString *)MD5;

@end

NS_ASSUME_NONNULL_END
