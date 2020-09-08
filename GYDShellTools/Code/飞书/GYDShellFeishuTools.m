//
//  GYDShellFeishuTools.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/09/07.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDShellFeishuTools.h"
#import "GYDShellConnectTools.h"
#import "GYDJSONSerialization.h"
#import "GYDDictionary.h"
#import "GYDHttpFormDataMaker.h"
#import "GYDFoundationPrivateHeader.h"

@implementation GYDShellFeishuTools

/** 获取权限，也就是更新token */
- (BOOL)updateTokenOutput:(out NSString * _Nullable * _Nullable)output {
    if (self.appId.length < 1) {
        if (output) {
            *output = @"appId必须有值";
        }
        return NO;
    }
    if (self.appSecret.length < 1) {
        if (output) {
            *output = @"appSecret必须有值";
        }
        return NO;
    }
    GYDShellConnectTools *connect = [[GYDShellConnectTools alloc] init];
    connect.url = @"https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal/";
    connect.method = @"POST";
    connect.headerField = @{
        @"Content-Type" : @"application/json"
    };
    connect.bodyData = [GYDJSONSerialization dataWithJSONObject:@{
        @"app_id": self.appId, @"app_secret": self.appSecret
    }];
    [connect syncSend];
    NSString *token = [GYDDictionary stringForKey:@"tenant_access_token" inDictionary:connect.resultJSONObject];
    if (token.length < 1) {
        if (output) {
            *output = connect.resultString;
        }
        return NO;
    }
    self.token = token;
    return YES;
}

/** 上传图片，返回Key，失败为nil */
- (nullable NSString *)imageKeyForUploadImageData:(NSData *)data type:(NSString *)type output:(out NSString * _Nullable * _Nullable)output {
    if (!self.token) {
        if (![self updateTokenOutput:output]) {
            return nil;
        }
    }
    
    GYDHttpFormDataMaker *formDataMaker = [[GYDHttpFormDataMaker alloc] init];
    [formDataMaker.formDataArray addObject:[GYDHttpFormDataItem formDataWithName:@"image" fileName:@"1.png" contentType:@"image" contentData:data]];
    [formDataMaker.formDataArray addObject:[GYDHttpFormDataItem formDataWithName:@"image_type" stringValue:type]];
    GYDShellConnectTools *connect = [[GYDShellConnectTools alloc] init];
    connect.timeoutTimeInterval = 60;
    connect.url = @"https://open.feishu.cn/open-apis/image/v4/put/";
    connect.method = @"POST";
    [formDataMaker buildFormData:^(NSString * _Nonnull headerKey, NSString * _Nonnull headerValue, NSData * _Nonnull body) {
        connect.headerField = @{
            headerKey : headerValue,
            @"Authorization" : [NSString stringWithFormat:@"Bearer %@", self.token]
        };
        connect.bodyData = body;
    }];
    [connect syncSend];
    
    NSNumber *code = [GYDDictionary numberForKey:@"code" inDictionary:connect.resultJSONObject];
    NSDictionary *dataDic = [GYDDictionary dictionaryForKey:@"data" inDictionary:connect.resultJSONObject];
    NSString *imageKey = [GYDDictionary stringForKey:@"image_key" inDictionary:dataDic];
    if (!code || [code integerValue] != 0 || imageKey.length < 1) {
        if (output) {
            *output = connect.resultString;
        }
    }
    return imageKey;
}

/** 发送消息 */
- (BOOL)sendMessageToChat:(NSString *)chat withTitle:(NSString *)title messageItemArray:(NSArray<GYDShellFeishuMessageItem *> *)messageItemArray output:(out NSString * _Nullable * _Nullable)output {
    if (!self.token) {
        if (![self updateTokenOutput:output]) {
            return NO;
        }
    }
    NSMutableArray *content = [NSMutableArray array];
    for (GYDShellFeishuMessageItem *item in messageItemArray) {
        NSString *outInfo = nil;
        NSDictionary *dic = [item feishuContentWithTools:self output:&outInfo];
        if (!dic) {
            GYDFoundationWarning(@"组装飞书消息失败：%@", outInfo);
        }
        [content addObject:@[dic]];
    }
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    body[@"msg_type"] = @"post";
    body[@"content"] = @{
        @"post" : @{
                @"zh_cn" : @{
                        @"title"    : title ?: @"",
                        @"content"  : content
                }
        }
    };
    if ([chat hasPrefix:@"oc_"]) {
        body[@"chat_id"] = chat;
    } else {
        body[@"email"] = chat;
    }
    GYDShellConnectTools *connect = [[GYDShellConnectTools alloc] init];
    connect.url = @"https://open.feishu.cn/open-apis/message/v4/send/";
    connect.method = @"POST";
    connect.headerField = @{
        @"Content-Type" : @"application/json",
        @"Authorization" : [NSString stringWithFormat:@"Bearer %@", self.token]
    };
    connect.bodyData = [GYDJSONSerialization dataWithJSONObject:body];
    [connect syncSend];
    
    NSNumber *code = [GYDDictionary numberForKey:@"code" inDictionary:connect.resultJSONObject];
    if (!code || [code integerValue] != 0) {
        if (output) {
            *output = connect.resultString;
        }
        return NO;
    }
    return YES;
}

#pragma mark - 最简单的机器人处理
/** 最简单的发消息，不支持at，不支持富媒体 */
+ (BOOL)sendSimpleMessageToRobot:(NSString *)robot withTitle:(NSString *)title message:(NSString *)message output:(out NSString * _Nullable * _Nullable)output {
    GYDShellConnectTools *connect = [[GYDShellConnectTools alloc] init];
    connect.url = [NSString stringWithFormat:@"https://open.feishu.cn/open-apis/bot/hook/%@", robot];
    connect.method = @"POST";
    connect.headerField = @{
        @"Content-Type" : @"application/json"
    };
    connect.bodyData = [GYDJSONSerialization dataWithJSONObject:@{
        @"title": title ?: @"",
        @"text": message ?: @""
    }];
    [connect syncSend];
    
    NSNumber *ok = [GYDDictionary numberForKey:@"ok" inDictionary:connect.resultJSONObject];
    if (!ok || ![ok boolValue]) {
        if (output) {
            *output = connect.resultString;
        }
        return NO;
    }
    return YES;
}

@end
