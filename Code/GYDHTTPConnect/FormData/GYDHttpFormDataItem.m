//
//  GYDHttpFormDataItem.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/07/29.
//

#import "GYDHttpFormDataItem.h"
#import "GYDFoundationPrivateHeader.h"

#import "NSString+GYDEscape.h"

@implementation GYDHttpFormDataItem

/** 普通参数 */
+ (instancetype)formDataWithName:(NSString *)name stringValue:(NSString *)value {
    GYDHttpFormDataItem *item = [[self alloc] init];
    item.name = name;
    item.value = [name dataUsingEncoding:NSUTF8StringEncoding];
    return item;
}

/** 文件参数 */
+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName contentType:(NSString *)contentType contentData:(NSData *)data {
    GYDHttpFormDataItem *item = [[self alloc] init];
    item.name = name;
    item.fileName = fileName;
    item.contentType = contentType;
    item.value = data;
    return item;
}

- (NSData *)build {
    NSMutableData *data = [NSMutableData data];
    NSMutableString *disposition = [NSMutableString stringWithString:@"Content-Disposition: form-data;"];
    if (self.name.length > 0) {
        [disposition appendFormat:@" name=\"%@\";", [self.name gyd_escapeStringByBackslash]];
    } else {
        GYDFoundationWarning(@"form-data必须有name");
    }
    if (self.fileName.length > 0) {
        [disposition appendFormat:@"filename=\"%@\"", [self.fileName gyd_escapeStringByBackslash]];
    }
    if (self.contentType.length > 0) {
        [disposition appendFormat:@"\r\nContent-Type: %@", [self.contentType gyd_escapeStringByBackslash]];
    }
    [disposition appendString:@"\r\n\r\n"];
    [data appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (self.value.length > 0) {
        [data appendData:self.value];
    } else {
        //data应该可以为空
    }
    
    return data;
}

@end
