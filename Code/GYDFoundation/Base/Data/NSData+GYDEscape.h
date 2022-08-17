//
//  NSData+GYDBase64.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2019/8/22.
//

#import <Foundation/Foundation.h>

@interface NSData (GYDEscape)

#pragma mark - base64处理

- (nonnull NSString *)gyd_base64Value;

+ (nonnull NSData *)gyd_dataWithBase64String:(nonnull NSString *)base64String;

#pragma mark - MD5处理

- (nonnull NSString *)gyd_MD5Value;

@end
