//
//  GYDShellFeishuMessageItem.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/09/07.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GYDShellFeishuTools;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GYDShellFeishuMessageItemType) {
    GYDShellFeishuMessageItemTypeText,
    GYDShellFeishuMessageItemTypeLink,
    GYDShellFeishuMessageItemTypeImage,
    GYDShellFeishuMessageItemTypeAt,
};

/**
 处理单个飞书消息的元素，飞书消息是此元素的双层数组。多个元素组成一行，多行组成一条消息。
 */
@interface GYDShellFeishuMessageItem : NSObject

@property (nonatomic) GYDShellFeishuMessageItemType messageType;

@property (nonatomic) NSString *text;

@property (nonatomic) NSString *link;

@property (nonatomic) NSData *imageData;

@property (nonatomic) CGSize size;

@property (nonatomic) NSString *atUserId;

+ (instancetype)messageWithText:(NSString *)text;

+ (instancetype)messageWithLink:(NSString *)link text:(NSString *)text;

+ (instancetype)messageWithImageData:(NSData *)imageData size:(CGSize)size;

+ (instancetype)messageWithAtUserId:(NSString *)userId;

/** GYDShellFeishuMessageItemTypeImage 是例外，需要上传，需要做额外的处理*/
- (NSDictionary *)feishuContentWithTools:(GYDShellFeishuTools *)tools output:(out NSString * _Nullable * _Nullable)output;

@end


NS_ASSUME_NONNULL_END
