//
//  GYDHttpFormDataMaker.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/07/29.
//

#import "GYDHttpFormDataMaker.h"

@implementation GYDHttpFormDataMaker

- (NSMutableArray<GYDHttpFormDataItem *> *)formDataArray {
    if (!_formDataArray) {
        _formDataArray = [NSMutableArray array];
    }
    return _formDataArray;
}

+ (NSString *)markNewBoundary {
    return [NSString stringWithFormat:@"----%08X%08X", arc4random(), arc4random()];
}

- (NSString *)httpContentTypeWithBoundary:(NSString *)boundary {
    return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
}

- (NSData *)httpBodyWithBoundary:(NSString *)boundary {
    if (self.formDataArray.count < 1) {
        return nil;
    }
    NSMutableData *data = [NSMutableData data];
    [data appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSInteger i = 0;
    for (GYDHttpFormDataItem *item in self.formDataArray) {
        if (i == 0) {
            i++;
        } else {
            [data appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [data appendData:[item build]];
        [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [data appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
    return data;
}

/** 构建所有参数，headerKey:headerValue用于填充HTTPHeaderField，headerKey固定值Content-Type，body是http消息体 */
- (void)buildFormData:(void(^)(NSString *headerKey, NSString *headerValue, NSData *body))block {
    if (!block) {
        return;
    }
    NSString *headerKey = @"Content-Type";
    NSString *boundary = [GYDHttpFormDataMaker markNewBoundary];
    
    NSString *headerValue = [self httpContentTypeWithBoundary:boundary];
    NSData *body = [self httpBodyWithBoundary:boundary];
    block = block;
    block(headerKey, headerValue, body);
}

@end
