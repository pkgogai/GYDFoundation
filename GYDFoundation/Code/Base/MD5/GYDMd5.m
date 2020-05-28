//
//  GYDMd5.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2019/8/19.
//

#import "GYDMd5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation GYDMd5
{
    CC_MD5_CTX _md5;
}
#pragma mark - 先初始化

- (instancetype)init
{
    self = [super init];
    if (self) {
        CC_MD5_Init(&_md5);
    }
    return self;
}


#pragma mark - 再放入数据

- (void)addString:(nullable NSString *)string {
    if (!string) {
        return;
    }
    const char *cStr = [string UTF8String];
    CC_MD5_Update(&_md5, cStr, (CC_LONG)strlen(cStr));
    
}
- (void)addData:(nullable NSData *)data {
    if (!data) {
        return;
    }
    CC_MD5_Update(&_md5, [data bytes], (CC_LONG)[data length]);
}
/** 文件有可能不存在或者读取失败 */
- (BOOL)addFile:(nullable NSString *)filePath {
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (!handle) {
        return NO;
    }
    NSData* fileData = [handle readDataOfLength:10240];
    while ([fileData length] > 0) {
        CC_MD5_Update(&_md5, [fileData bytes], (CC_LONG)[fileData length]);
        fileData = [handle readDataOfLength:10240];
    }
    return YES;
}

#pragma mark - 最后得到md5

- (nonnull NSString *)MD5 {
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &_md5);
    NSString* s = [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                   digest[0], digest[1], digest[2], digest[3],
                   digest[4], digest[5], digest[6], digest[7],
                   digest[8], digest[9], digest[10], digest[11],
                   digest[12], digest[13], digest[14], digest[15]];
    return s;
}

@end
