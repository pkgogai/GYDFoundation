//
//  GYDJSONPropertyInfo.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/11.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 记录GYDJSONModel里各自属性的处理方式，实际上是当成结构体来用的，为了放在数组里才建的类。
 */
@interface GYDJSONPropertyInfo : NSObject
{
@public
    /** 本地原生代码中属性的命名 */
    NSString    *_modelName;
    /** 编码后的命名 */
    NSString    *_jsonName;
    /** 属性的类型，id及其子类时赋值，否则是NULL */
    Class       _propertyClass;
    /** ID及其子类时为NULL，否则使用@@encode(类型)的值 */
    NSString    *_encodeType;
    
    /** 数组内元素的类型，在_propertyClass是NSArray或NSMut???Array时有值，否则为NULL */
    Class       _arrayClass;
}

/** 检查错误，如果没查到则返回nil */
- (nullable NSString *)checkErrorMessage;

@end
