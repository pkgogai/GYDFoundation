//
//  GYDHttpFormDataItem.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/07/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYDHttpFormDataItem : NSObject

//如有需要，再加一个NSInputStream形式的处理

#pragma mark - 普通参数

@property (nonatomic)   NSString *name;

@property (nonatomic)   NSData   *value;

#pragma mark - 文件参数需要的额外信息

@property (nonatomic)   NSString *fileName;

@property (nonatomic)   NSString *contentType;


/** 普通参数 */
+ (instancetype)formDataWithName:(NSString *)name stringValue:(NSString *)value;

/** 文件参数 */
+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName contentType:(NSString *)contentType contentData:(NSData *)data;

- (NSData *)build;

@end

NS_ASSUME_NONNULL_END
