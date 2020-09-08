//
//  GYDHttpFormDataMaker.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/07/29.
//

#import <Foundation/Foundation.h>
#import "GYDHttpFormDataItem.h"
#import "GYDHttpFormDataMaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDHttpFormDataMaker : NSObject

#pragma mark - 整体方法

@property (nonatomic, nonnull)   NSMutableArray<GYDHttpFormDataItem *> *formDataArray;

/** 构建所有参数，headerKey:headerValue用于填充HTTPHeaderField，headerKey固定值Content-Type，body是http消息体 */
- (void)buildFormData:(void(^)(NSString *headerKey, NSString *headerValue, NSData *body))block;


#pragma mark - 细节

+ (NSString *)markNewBoundary;

/** Content-Type: */
- (NSString *)httpContentTypeWithBoundary:(NSString *)boundary;

/** body */
- (NSData *)httpBodyWithBoundary:(NSString *)boundary;



@end

NS_ASSUME_NONNULL_END
