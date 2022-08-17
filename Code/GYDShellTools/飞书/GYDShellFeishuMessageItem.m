//
//  GYDShellFeishuMessageItem.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/09/07.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDShellFeishuMessageItem.h"
#import "GYDShellFeishuTools.h"

@implementation GYDShellFeishuMessageItem

+ (instancetype)messageWithText:(NSString *)text {
    GYDShellFeishuMessageItem *message = [[self alloc] init];
    message.messageType = GYDShellFeishuMessageItemTypeText;
    message.text = text;
    return message;
}

+ (instancetype)messageWithLink:(NSString *)link text:(NSString *)text {
    GYDShellFeishuMessageItem *message = [[self alloc] init];
    message.messageType = GYDShellFeishuMessageItemTypeLink;
    message.link = link;
    message.text = text;
    return message;
}

+ (instancetype)messageWithImageData:(NSData *)imageData size:(CGSize)size {
    GYDShellFeishuMessageItem *message = [[self alloc] init];
    message.messageType = GYDShellFeishuMessageItemTypeImage;
    message.imageData = imageData;
    message.size = size;
    return message;
}

+ (instancetype)messageWithAtUserId:(NSString *)userId {
    GYDShellFeishuMessageItem *message = [[self alloc] init];
    message.messageType = GYDShellFeishuMessageItemTypeAt;
    message.atUserId = userId;
    return message;
}

- (NSDictionary *)feishuContentWithTools:(GYDShellFeishuTools *)tools output:(out NSString * _Nullable * _Nullable)output {
    if (self.messageType == GYDShellFeishuMessageItemTypeText) {
        return @{
            @"tag"  : @"text",
            @"text" : self.text ?: @""
        };
    } else if (self.messageType == GYDShellFeishuMessageItemTypeLink) {
        return @{
            @"tag"  : @"a",
            @"text" : self.text ?: @"",
            @"href" : self.link ?: @""
        };
    } else if (self.messageType == GYDShellFeishuMessageItemTypeImage) {
        NSString *imageKey = [tools imageKeyForUploadImageData:self.imageData type:@"message" output:output];
        if (!imageKey) {
            return nil;
        }
        return @{
            @"tag"  : @"img",
            @"image_key"    : imageKey,
            @"width"    : @(self.size.width),
            @"height"   : @(self.size.height)
        };
    } else if (self.messageType == GYDShellFeishuMessageItemTypeAt) {
        return @{
            @"tag"    : @"at",
            @"user_id"    : self.atUserId ?: @""
        };
    }
    
    if (output) {
        *output = @"未处理的消息类型";
    }
    return nil;
}

@end
