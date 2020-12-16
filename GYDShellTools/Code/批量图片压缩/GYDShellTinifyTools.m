//
//  GYDShellTinifyTools.m
//  GYDFoundation
//
//  Created by gongyadong on 2020/12/16.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDShellTinifyTools.h"

#import "GYDShellConnectTools.h"
#import "GYDHttpFormDataMaker.h"
#import "NSString+GYDEscape.h"
#import "GYDDictionary.h"


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
    
    NSLog(@"%@", connect.resultString);
    
    if (connect.resultHttpStatusCode == 401) {
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
     文件名、体积、md5、压缩次数（图片可以压缩多次）
     
     遍历目录找出所有需要处理的文件，并记录属性:
     路径、文件名、体积、md5。
     
     挑拣出新增的图片，打印，批量压缩并替换，修改记录
     
     挑拣出没压制到极限的图片继续压缩
     
     保存记录
     
     
     */
    
    
    return NO;
}


@end
