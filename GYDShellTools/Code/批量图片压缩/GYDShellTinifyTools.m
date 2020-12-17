//
//  GYDShellTinifyTools.m
//  GYDFoundation
//
//  Created by gongyadong on 2020/12/16.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDShellTinifyTools.h"
#import "GYDFoundation.h"
#import "GYDFoundationPrivateHeader.h"

#import "GYDShellConnectTools.h"

#pragma mark - 文件数据模型
@interface GYDShellTinifyFileItem : NSObject

GYDJSONProperty(NSString *, name);

GYDJSONProperty(NSString *, path);

GYDJSONProperty(NSInteger, size);

GYDJSONProperty(NSString *, md5);

GYDJSONProperty(NSInteger, progress);

@end

@implementation GYDShellTinifyFileItem

- (NSString *)description {
    return [self gyd_JSONString];
}
- (NSString *)debugDescription {
    return [self description];
}

@end


@implementation GYDShellTinifyTools
{
    NSMutableArray<NSString *> *_apiKeys;
}

- (void)setApiKeys:(NSArray<NSString *> *)apiKeys {
    _apiKeys = [apiKeys mutableCopy];
}
- (NSArray<NSString *> *)apiKeys {
    return [_apiKeys copy];
}

/**
 压缩一张图片
 */
- (nullable NSData *)imageDataForCompressImageData:(nonnull NSData *)imageData output:(out NSString * _Nullable * _Nullable)output {
    
    /*
     获取一个合适的key
     */
    NSString *key = [_apiKeys firstObject];
    if (!key) {
        if (output) {
            *output = @"没有key了";
        }
        return nil;
    }
    NSString *authorization = [@"Basic " stringByAppendingString:[[@"api:" stringByAppendingString:key] gyd_base64Value]];
    
    
    GYDShellConnectTools *connect = [[GYDShellConnectTools alloc] init];
    connect.timeoutTimeInterval = 60;
    connect.url = @"https://api.tinify.com/shrink";
    connect.headerField = @{
        @"Authorization" : authorization
    };
    connect.method = @"POST";
    connect.bodyData = imageData;
    [connect syncSend];
    
    /*
     {"input":{"size":91733,"type":"image/png"},"output":{"size":23711,"type":"image/png","width":750,"height":1334,"ratio":0.2585,"url":"https://api.tinify.com/output/gah3v1eexhmty1gt8ujhjfhge2gbf1g2"}}
     
     {
         input =     {
             size = 91733;
             type = "image/png";
         };
         output =     {
             height = 1334;
             ratio = "0.2585";
             size = 23711;
             type = "image/png";
             url = "https://api.tinify.com/output/gah3v1eexhmty1gt8ujhjfhge2gbf1g2";
             width = 750;
         };
     }
     */
    
//    NSLog(@"%@", connect.resultString);
    
    if (connect.resultHttpStatusCode == 429) {
        NSLog(@"key次数用光：%@", key);
        [_apiKeys removeObject:key];
        return [self imageDataForCompressImageData:imageData output:output];
    }
    
    if (connect.resultCode != GYDSimpleHttpConnectResultCodeSuccess) {
        if (output) {
            *output = [NSString stringWithFormat:@"图片上传失败：%zd,%zd,%@", connect.resultCode, connect.resultHttpStatusCode, connect.resultString];
            return nil;
        }
    }
    
    NSDictionary *outputDic = [GYDDictionary dictionaryForKey:@"output" inDictionary:connect.resultJSONObject];
    NSString *outputUrl = [GYDDictionary stringForKey:@"url" inDictionary:outputDic];
    if (outputUrl.length == 0) {
        if (output) {
            *output = [NSString stringWithFormat:@"图片上传失败：http:%zd，data:\n%@", connect.resultHttpStatusCode, connect.resultString];
        }
        return nil;
    }
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:outputUrl]];
    if (!data) {
        if (output) {
            *output = [NSString stringWithFormat:@"图片下载失败：%@", outputUrl];
        }
        return nil;
    }
    
    return data;
}

/**
 批量压缩一个目录中的图片并直接替换
 */
- (BOOL)compressImagesAtPath:(nonnull NSString *)path resursive:(BOOL)resursive historyFile:(nullable NSString *)filePath {
    /*
     读取记录文件：
     md5:压缩次数（图片可以压缩多次），-1压缩到极致，1压缩过
     @{
        @"${md5}" : -1
     }
     
     遍历目录找出所有需要处理的文件，并记录属性:
     路径、文件名、体积、md5。
     @[
        @{
            @"path" : @"/",
            @"name" : @"",
            @"size" : 1,
            @"md5"  : @"m"
        }
     ]
     挑拣出新增的图片，打印，批量压缩并替换，修改记录
     
     挑拣出没压制到极限的图片继续压缩
     
     保存记录
     
     
     */
    NSMutableDictionary *oldMd5Progress = nil;
    if (filePath) {
        oldMd5Progress = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    }
    NSMutableDictionary *newMd5Progress = [NSMutableDictionary dictionary];
    
    NSMutableArray *willArray = [NSMutableArray array]; //还没压缩
    NSMutableArray *doingArray = [NSMutableArray array];    //压缩过1次以上，但并未到极致
    NSMutableArray *doneArray = [NSMutableArray array]; //压缩到极致
    
    [GYDFile enumPath:path usingBlock:^(NSString * _Nonnull fileName, NSString * _Nonnull fullPath, BOOL * _Nonnull stop) {
        NSDictionary<NSFileAttributeKey, id> *fileAtt = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
        NSString *fileType = [GYDDictionary stringForKey:NSFileType inDictionary:fileAtt];
        if (![fileType isEqualToString:NSFileTypeRegular]) {
            return;
        }
        if (![[fileName pathExtension] isEqualToString:@"png"]) {
            return;
        }
        NSNumber *fileSize = [GYDDictionary numberForKey:NSFileSize inDictionary:fileAtt];
        if (!fileSize) {
            GYDFoundationWarning(@"文件大小获取失败：%@", filePath);
            return;
        }
        if ([fileSize integerValue] == 0) {
            GYDFoundationWarning(@"文件大小为0：%@", filePath);
            return;
        }
        GYDMd5 *md5Maker = [[GYDMd5 alloc] init];
        [md5Maker addFile:fullPath];
        NSString *md5 = [md5Maker MD5];
        
        GYDShellTinifyFileItem *item = [[GYDShellTinifyFileItem alloc] init];
        item.name = fileName;
        item.path = fullPath;
        item.size = [fileSize integerValue];
        item.md5 = md5;
        NSInteger progress = [[GYDDictionary numberForKey:md5 inDictionary:oldMd5Progress] integerValue];
        if (progress != 0) {
            newMd5Progress[md5] = @(progress);
        }
        if (progress < 0) {
            [doneArray addObject:item];
        } else if (progress > 0) {
            [doingArray addObject:item];
        } else {
            [willArray addObject:item];
        }
    }];
    
    NSLog(@"已压缩到极致：%zd", doneArray.count);
    NSLog(@"压缩过：%zd", doingArray.count);
    NSLog(@"未压缩：%zd", willArray.count);
    
    NSMutableArray<GYDShellTinifyFileItem *> *doArray = willArray;
//    if (doArray.count < 1) {
//        doArray = doingArray;
//        if (doArray.count < 1) {
//            return YES;
//        }
//    }

    [doArray sortUsingComparator:^NSComparisonResult(GYDShellTinifyFileItem * _Nonnull obj1, GYDShellTinifyFileItem * _Nonnull obj2) {
        return obj2.size - obj1.size;
    }];
    
    BOOL r = [self compressFileArray:doArray progress:newMd5Progress];
    
    if (filePath.length) {
        BOOL r = [newMd5Progress writeToFile:filePath atomically:YES];
        if (!r) {
            NSLog(@"记录文件保存失败：%@", filePath);
        }
    }
    return r;
}

- (BOOL)compressFileArray:(NSArray<GYDShellTinifyFileItem *> *)doArray progress:(NSMutableDictionary *)newMd5Progress {
    for (GYDShellTinifyFileItem *item in doArray) {
        
        NSLog(@"处理图片:%@, %zd", item.name, item.size);
        NSData *fromData = [NSData dataWithContentsOfFile:item.path];
        if (!fromData) {
            NSLog(@"读取文件失败：%@", item.path);
            return NO;
        }
        NSString *msg = nil;
        NSData *toData = [self imageDataForCompressImageData:fromData output:&msg];
        if (!toData) {
            NSLog(@"处理文件失败：%@", item.path);
            if (msg) {
                NSLog(@"%@", msg);
            }
            return NO;
        }
        GYDMd5 *builder = [[GYDMd5 alloc] init];
        [builder addData:toData];
        NSString *toMd5 = [builder MD5];
        if ([toMd5 isEqualToString:item.md5]) {
            newMd5Progress[toMd5] = @(-1);
        } else {
            newMd5Progress[toMd5] = @(1);
            NSError *err = nil;
            BOOL r = [toData writeToFile:item.path options:NSDataWritingAtomic error:&err];
            if (!r) {
                NSLog(@"写入数据失败：%@\n%@", item.path, [err localizedDescription]);
                return NO;
            }
        }
        NSLog(@"结果：%zd(%zd)", toData.length, toData.length - fromData.length);
    }
    return YES;
}

//- (NSString *)formatSize:(NSInteger)size {
//    NSString *str = @"";
//    if (size > 1000*1000) {
//        str = [str stringByAppendingFormat:@"%zdM", size / 1000*1000];
//        size -= size / 1000*1000;
//    }
//
//    if (size > 1000) {
//        str = [str stringByAppendingFormat:@"%zdK", size / 1000];
//        size -= size / 1000;
//    }
//    if (size) {
//        <#statements#>
//    }
//
//}

@end
