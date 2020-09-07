//
//  GYDHttpFormDataMaker.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/07/29.
//

#import <Foundation/Foundation.h>
#import "GYDHttpFormDataItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDHttpFormDataMaker : NSObject

@property (nonatomic)   NSMutableArray<GYDHttpFormDataItem *> *formDataArray;

+ (NSString *)markNewBoundary;

/** Content-Type: */
- (NSString *)httpContentTypeWithBoundary:(NSString *)boundary;

/** body */
- (NSData *)httpBodyWithBoundary:(NSString *)boundary;

/** 构建所有参数，headerKey:headerValue用于填充HTTPHeaderField，headerKey固定值Content-Type，body是http消息体 */
- (void)buildFormData:(void(^)(NSString *headerKey, NSString *headerValue, NSData *body))block;

@end

NS_ASSUME_NONNULL_END
