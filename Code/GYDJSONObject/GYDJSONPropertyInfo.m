//
//  GYDJSONPropertyInfo.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/11.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDJSONPropertyInfo.h"

@implementation GYDJSONPropertyInfo

/** 检查错误，如果没查到则返回nil */
- (nullable NSString *)checkErrorMessage {
    NSString *errorMessage = @"";
    if (_modelName.length < 1) {
        errorMessage = [errorMessage stringByAppendingString:@"没有modelName\n"];
    }
    if (_jsonName.length < 1) {
        errorMessage = [errorMessage stringByAppendingString:@"没有jsonName\n"];
    }
    if ((_propertyClass == NULL) == (_encodeType == nil)) {
        errorMessage = [errorMessage stringByAppendingString:@"propertyClass和attType应该有且只有1个\n"];
    }
    if ([_propertyClass isSubclassOfClass:[NSArray class]] == (_arrayClass == NULL)) {
        errorMessage = [errorMessage stringByAppendingString:@"propertyClass是数组时，必须要指定arrayClass\n"];
    }
    if (errorMessage.length > 0) {
        errorMessage = [NSString stringWithFormat:@"属性：%@ 定义错误：\n%@", self, errorMessage];
    } else {
        errorMessage = nil;
    }
    return errorMessage;
}

- (NSString *)description {
    NSMutableString *desc = [[NSMutableString alloc] initWithFormat:@"%@->%@,", _modelName, _jsonName];
    if (_propertyClass == NULL) {
        [desc appendFormat:@"基础:%@", _encodeType];
    } else if ([_propertyClass isSubclassOfClass:[NSArray class]]) {
        [desc appendFormat:@"数组:%@", _arrayClass];
    } else {
        [desc appendFormat:@"对象:%@", _propertyClass];
    }
    return desc;
}

- (NSString *)debugDescription {
    return [self description];
}

@end
