//
//  NSObject+GYDJSONObject.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/11.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDJSONDefineHeader.h"
#import "GYDJSONPropertyInfo.h"

/*
 TODO:
 声明成id类型的属性可以直接接受允许任何json类型，不进行转换（注意：在获取属性类型时，id和NSObject不同，NSClassFromString(@"id")是不行的）
 为array和dictionary添加类别。
 
 可以声明的属性类型：
    可与NSNumber互转的基本类型，用 setValue:forKey: 自然转换
    NSString和NSNumber以及他们的子类，解析时可以互转，例如json里是NSNumber，model里可以定义为NSMutableString。
    NSDictionary以及它的子类，如果定义为 NSMutableDictionary及其之类，则会将内部所有 NSDictionary 和 NSArray 转换成 Mutable 形式。
    此外的 NSObject 按照下面定义的规则进行转换。
 
 注意：
    转换时也会包含了父类中定义的属性规则。
    对于[NSNull null]，如果属性声明成 NSDictionary ，则里面的 [NSNull null] 元素依然正常保留；如果是下面定义的属性，则替换成nil，避免类型错误。
    值为nil的属性，生成NSDictionary时不包含
 
 因为这里用到了 ZZSET__，__TO__，__AS__ 3个作为关键字，因此继承于此类后属性名和方法名中不能再包含这3个。
 
 用法：
 创建 NSObject 子类，声明属性时，如果是需要转换的属性，则使用下面的宏定义
 普通属性：
 属性名与服务器相同：GYDJSONProperty(type, name) 例：GYDJSONProperty(NSString *, name1);
 属性名与服务器不同：GYDJSONPropertyNamed(type, name, JSONName) 例：GYDJSONPropertyNamed(NSNumber *, modelName2, JSONName2);
 
 数组属性：
 属性名与服务器相同：GYDJSONPropertyArray(type, star, name) 例：GYDJSONPropertyArray(NSString, *, array1);
 属性名与服务器不同：GYDJSONPropertyArrayNamed(type, star, name, JSONName) 例：GYDJSONPropertyArrayNamed(NSNumber, *, modelArray2, JSONArray2);
 
 如果是不处理的属性，则正常声明，例：@property (nonatomic) NSString *otherProperty;
 
 如果有特殊处理，则继承这两个方法
 + (nullable instancetype)gyd_modelWithJSONDictionary:(nullable NSDictionary *)dic;
 - (nonnull NSMutableDictionary *)gyd_JSONDictionary;
 */

@interface NSObject (GYDJSONObject)

#pragma mark - JSON转换的最终处理方法，如果有特殊处理，可以继承这两个方法
/** json字典转model */
+ (nullable instancetype)gyd_modelWithJSONDictionary:(nullable NSDictionary *)dic;
/** model转json字典 */
- (nonnull NSMutableDictionary *)gyd_JSONDictionary;

#pragma mark - 扩展方法，内部使用上面的基础方法

+ (nullable instancetype)gyd_modelWithJSONData:(nullable NSData *)data;
+ (nullable instancetype)gyd_modelWithJSONString:(nullable NSString *)string;
+ (nullable NSMutableArray *)gyd_modelArrayWithJSONArray:(nullable NSArray *)array;

- (nonnull NSData *)gyd_JSONData;
- (nonnull NSString *)gyd_JSONString;
+ (nullable NSMutableArray *)gyd_JSONArrayWithModelArray:(nullable NSArray *)array;

#pragma mark - 解析方法
//属性转换：json->model
+ (nullable id)gyd_propertyValueForClass:(nullable Class)class withJSONValue:(nonnull id)value;
+ (nonnull NSMutableArray *)gyd_propertyValueArrayForClass:(nonnull Class)class withJSONValueArray:(nonnull NSArray *)jsonArray;
//属性转换：model->json
+ (nullable id)gyd_JSONValueWithPropertyValue:(nonnull id)value;
+ (nonnull NSMutableArray *)gyd_JSONValueArrayWithPropertyValueArray:(nonnull NSArray *)propertyArray;

#pragma mark - 调试

/** 反序列化后是否保留原json结构以供调试，默认NO */
@property (nonatomic, class, setter=gyd_setKeepSourceJSONObject:) BOOL gyd_keepSourceJSONObject;

/** 如果设置了gyd_keepSourceJSONObject，则反序列化后这里会记录原数据的json结构 */
@property (nonatomic, readonly, nullable) id gyd_sourceJSONObject;

/** 检查错误信息，没发现错误则返回nil，子类调用是校验子类本身，用 NSObject 调用则是校验所有子类 */
+ (nullable NSString *)gyd_checkError;

#pragma mark - 属性映射关系

/** 类属性映射信息 */
+ (nonnull NSArray<GYDJSONPropertyInfo *> *)gyd_propertyInfoArray;


@end
