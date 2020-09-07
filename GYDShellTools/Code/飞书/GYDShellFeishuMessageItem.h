//
//  GYDShellFeishuMessageItem.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/09/07.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GYDShellFeishuMessageItemType) {
    GYDShellFeishuMessageItemTypeText,
    GYDShellFeishuMessageItemTypeLink,
    GYDShellFeishuMessageItemTypeImage,
    GYDShellFeishuMessageItemTypeAt,
};

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

@end


NS_ASSUME_NONNULL_END
