//
//  GYDShellFeishuToolsDemo.m
//  GYDDevelopment
//
//  Created by gongyadong on 2022/2/10.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#define GYD_FOUNDATION_DEVELOPMENT 1

#import "GYDShellFeishuToolsDemo.h"
#import "GYDFoundationPrivateHeader.h"
#import "GYDShellFeishuTools.h"


@implementation GYDShellFeishuToolsDemo
{
    NSString *_appId;
    NSString *_appSecret;
    NSDictionary *_gitAuthorToFeishuDic;
    NSDictionary *_feishuInfoDic;
    GYDShellFeishuTools *_feishuTools;
    
}


+ (int)exampleMainArgc:(int)argc argv:(const char * _Nonnull * _Nonnull)argv {
    return 0;
}

+ (instancetype)sharedInstance {
    static GYDShellFeishuToolsDemo *demo = nil;
    if (!demo) {
        demo = [[self alloc] init];
    }
    return demo;
}

- (BOOL)setConfigFilePath:(NSString *)path {
    path = [path stringByStandardizingPath];
    
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:path];
    if (!config) {
        GYDFoundationWarning(@"读取飞书配置文件失败，配置文件路径：%@", path);
        return NO;
    }
    _feishuTools = nil;
    _appId = [GYDDictionary stringForKey:@"AppID" inDictionary:config];
    _appSecret = [GYDDictionary stringForKey:@"AppSecert" inDictionary:config];
    
    _gitAuthorToFeishuDic = [GYDDictionary dictionaryForKey:@"Git作者to飞书用户" inDictionary:config];
    
    _feishuInfoDic = [GYDDictionary dictionaryForKey:@"飞书用户信息" inDictionary:config];
    return YES;
}

- (NSString *)feishuUserWithGitAuthor:(NSString *)author {
    if (!author) {
        return nil;
    }
    if (_gitAuthorToFeishuDic[author]) {
        return _gitAuthorToFeishuDic[author];
    }
    return author;
}

/** 获取飞书用户id，可用于消息里的@操作 */
- (NSString *)idForUserName:(NSString *)userName {
    NSDictionary *userInfo = [GYDDictionary dictionaryForKey:userName inDictionary:_feishuInfoDic];
    NSString *userID = [GYDDictionary stringForKey:@"user_id" inDictionary:userInfo];
    return userID;
}

/** 发送消息 */
- (BOOL)sendMessageToUser:(NSString *)user withTitle:(NSString *)title messageItemArray:(NSArray<GYDShellFeishuMessageItem *> *)messageItemArray output:(out NSString * _Nullable * _Nullable)output {
    if (!_feishuTools) {
        _feishuTools = [[GYDShellFeishuTools alloc] init];
        _feishuTools.appId = _appId;
        _feishuTools.appSecret = _appSecret;
    }
    NSDictionary *userInfo = [GYDDictionary dictionaryForKey:user inDictionary:_feishuInfoDic];
    NSString *chatId = [GYDDictionary stringForKey:@"chat_id" inDictionary:userInfo];
    NSString *email = [GYDDictionary stringForKey:@"email" inDictionary:userInfo];
    if (chatId.length > 0) {
        user = chatId;
    } else if (email.length > 0) {
        user = email;
    }
    
    return [_feishuTools sendMessageToChat:user withTitle:title messageItemArray:messageItemArray output:output];
}

@end
