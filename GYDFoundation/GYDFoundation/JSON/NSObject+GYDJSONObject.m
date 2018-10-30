//
//  NSObject+GYDJSONObject.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/11.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "NSObject+GYDJSONObject.h"
#import "GYDFoundationPrivateHeader.h"
#import <objc/runtime.h>
#import <UIKit/UIApplication.h>
#import "GYDJSONSerialization.h"
#import "gyd_class_property.h"
#import "NSDictionary+GYDDictionary.h"

@implementation NSObject (GYDJSONObject)

#if GYDJSONAtomic == 1
static NSRecursiveLock *_PropertyMapCacheLock = nil;
#endif
+ (void)load {
    if (!_PropertyMapCacheLock) {
        _PropertyMapCacheLock = [[NSRecursiveLock alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
}

#pragma mark - JSON转换的最终处理方法，如果有特殊处理，可以继承这两个方法
/** json字典转model */
+ (nullable instancetype)gyd_modelWithJSONDictionary:(nullable NSDictionary *)dic {
    if (!dic) {
        return nil;
    }
    NSObject *model = [[self alloc] init];
    if (_KeepSourceJSONObject) {
        [model gyd_setSourceJSONObject:dic];
    }
    NSArray *propertyArray = [self gyd_propertyInfoArray];
    for (GYDJSONPropertyInfo *pro in propertyArray) {
        id value = dic[pro->_jsonName];
        if (!value || [NSNull null] == value) {
            continue;
        }
        if ([value isKindOfClass:[NSArray class]]) {
            //数组就不考虑有自定义的子类了，统一使用 NSMutableArray
            if (pro->_arrayClass) {
                value = [self gyd_propertyValueArrayForClass:pro->_arrayClass withJSONValueArray:value];
            } else {
                GYDFoundationWarning(@"属性：%@ 类型：%@ 获取数组内元素类型信息失败", pro->_modelName, pro->_propertyClass);
                value = nil;
            }
        } else {
            value = [self gyd_propertyValueForClass:pro->_propertyClass withJSONValue:value];
            if (!value) {
                GYDFoundationWarning(@"json转换失败：\n处理：%@\n数据：%@", pro, dic[pro->_jsonName]);
            }
        }
        if (value) {
            [model setValue:value forKey:pro->_modelName];
        }
        
    }
    return model;
}
/** model转json字典 */
- (nonnull NSMutableDictionary *)gyd_JSONDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSArray *propertyArray = [[self class] gyd_propertyInfoArray];
    for (GYDJSONPropertyInfo *pro in propertyArray) {
        id value = [self valueForKey:pro->_modelName];
        if (!value || [NSNull null] == value) {
            continue;
        }
        value = [NSObject gyd_JSONValueWithPropertyValue:value];
        
        if (value) {
            dic[pro->_jsonName] = value;
        }
    }
    
    return dic;
}

#pragma mark - 扩展方法，内部使用上面的基础方法

+ (nullable instancetype)gyd_modelWithJSONData:(nullable NSData *)data {
    NSDictionary *dic = [GYDJSONSerialization JSONDictionaryWithData:data];
    return [self gyd_modelWithJSONDictionary:dic];
}
+ (nullable instancetype)gyd_modelWithJSONString:(nullable NSString *)string {
    NSDictionary *dic = [GYDJSONSerialization JSONDictionaryWithString:string];
    return [self gyd_modelWithJSONDictionary:dic];
}
+ (nullable NSMutableArray *)gyd_modelArrayWithJSONArray:(nullable NSArray *)array {
    if (!array) {
        return nil;
    }
    return [self gyd_propertyValueArrayForClass:self withJSONValueArray:array];
}

- (nonnull NSData *)gyd_JSONData {
    NSDictionary *dic = [self gyd_JSONDictionary];
    return [GYDJSONSerialization dataWithJSONObject:dic];
}
- (nonnull NSString *)gyd_JSONString {
    NSDictionary *dic = [self gyd_JSONDictionary];
    return [GYDJSONSerialization stringWithJSONObject:dic];
}
+ (nullable NSMutableArray *)gyd_JSONArrayWithModelArray:(nullable NSArray *)array {
    if (!array) {
        return nil;
    }
    return [self gyd_JSONValueArrayWithPropertyValueArray:array];
}

#pragma mark - 解析方法
//属性转换：json->model
+ (nullable id)gyd_propertyValueForClass:(nullable Class)class withJSONValue:(nonnull id)value {
    if ([value isKindOfClass:[NSDictionary class]]) {
        if ([class isSubclassOfClass:[NSDictionary class]]) {
            if (![value isKindOfClass:class]) {
                //类型不符，需要转换
                if (class == [NSMutableDictionary class]) {
                    value = [(NSDictionary *)value gyd_recursiveMutableCopyIfNeed];
                } else if ([class isSubclassOfClass:[NSMutableDictionary class]]) {
                    value = [class dictionaryWithDictionary:[(NSDictionary *)value gyd_recursiveMutableCopyIfNeed]];
                } else {
                    value = [class dictionaryWithDictionary:value];
                }
            }
            
        } else if ([class isSubclassOfClass:[NSObject class]]) {
            //按照设置的特殊setter方法作为处理依据
            value = [class gyd_modelWithJSONDictionary:value];
        } else {
            value = nil;
        }
    } else if (class == NULL) {
        //没有class，就是最基本的数据类型，例如int,float等，或结构体，这里是肯定不支持结构体的。
        if ([value isKindOfClass:[NSNumber class]]) {
            //类型符合，不需要处理(不要弄出什么CGRect之类的)
        } else if ([value isKindOfClass:[NSString class]]) {
            //之后setvalue forkey会转换
        } else {
            value = nil;
        }
    } else if (![value isKindOfClass:class]) {
        if ([class isSubclassOfClass:[NSString class]]) {
            if ([value isKindOfClass:[NSString class]]) {
                //例如 NSMutableString
                value = [class stringWithString:value];
            } else if ([value isKindOfClass:[NSNumber class]]) {
                value = [class stringWithString:[(NSNumber *)value stringValue]];
            } else {
                value = nil;
            }
        } else if ([class isSubclassOfClass:[NSNumber class]]) {
            //NSNumber 不考虑子类
            if ([value isKindOfClass:[NSString class]]) {
                value = [class numberWithDouble:[(NSString *)value doubleValue]];
            } else {
                value = nil;
            }
        } else {
            value = nil;
        }
    }
    return value;
}
+ (nonnull NSMutableArray *)gyd_propertyValueArrayForClass:(nonnull Class)class withJSONValueArray:(nonnull NSArray *)jsonArray {
    NSMutableArray *array = [NSMutableArray array];
    for (id item in jsonArray) {
        id tmp = [self gyd_propertyValueForClass:class withJSONValue:item];
        if (tmp) {
            [array addObject:tmp];
        } else {
            GYDFoundationWarning(@"json转换失败：\n目标类型：%@\n数组内元素:%@", class, item);
        }
    }
    return array;
}
//属性转换：model->json
+ (nullable id)gyd_JSONValueWithPropertyValue:(nonnull id)value {
    if ([value isKindOfClass:[NSArray class]]) {
        //数组
        return [self gyd_JSONArrayWithModelArray:value];
    } else if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]){
        //字符串或数字
        return value;
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)value gyd_dictionaryLeftJsonObjectIfNeed];
    } else if ([value isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        return [value gyd_JSONDictionary];
    }
}
+ (nonnull NSMutableArray *)gyd_JSONValueArrayWithPropertyValueArray:(nonnull NSArray *)propertyArray {
    NSMutableArray *array = [NSMutableArray array];
    for (id item in propertyArray) {
        id tmp = [self gyd_JSONValueWithPropertyValue:item];
        if (tmp) {
            [array addObject:tmp];
        } else {
            GYDFoundationWarning(@"model转json失败：%@", item);
        }
    }
    return array;
}

#pragma mark - 调试

static BOOL _KeepSourceJSONObject = NO;
/** 反序列化后是否保留原json结构以供调试，默认NO */
+ (void)gyd_setKeepSourceJSONObject:(BOOL)gyd_keepSourceJSONObject {
    _KeepSourceJSONObject = gyd_keepSourceJSONObject;
}
+ (BOOL)gyd_keepSourceJSONObject {
    return _KeepSourceJSONObject;
}

static const char *_GYDSourceJSONObjectKey = "GYDSourceJSONObjectKey";
/** 如果设置了gyd_keepSourceJSONObject，则反序列化后这里会记录原数据的json结构 */
- (void)gyd_setSourceJSONObject:(id)value {
    objc_setAssociatedObject(self, _GYDSourceJSONObjectKey, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (id)gyd_sourceJSONObject {
    id obj = objc_getAssociatedObject(self, _GYDSourceJSONObjectKey);
    return obj;
}

/** 检查错误信息，没发现错误则返回nil，子类调用是校验子类本身，用 NSObject 调用则是校验所有子类 */
+ (nullable NSString *)gyd_checkError {
    NSMutableString *errorMessage = [NSMutableString string];
    if (self == [NSObject class]) {
        gyd_class_enumerateSubClass(self, ^(Class  _Nonnull __unsafe_unretained subClass, BOOL * _Nonnull stop) {
            NSString *r = [subClass gyd_checkError];
            if (r) {
                [errorMessage appendString:r];
            }
        });
    } else {
        NSArray<GYDJSONPropertyInfo *> *array = [self gyd_propertyInfoArray];
        for (GYDJSONPropertyInfo *info in array) {
            NSString *r = [info checkErrorMessage];
            if (r) {
                [errorMessage appendFormat:@"类：%@ 定义错误：\n%@", self, r];
            }
        }
    }
    
    if (errorMessage.length > 0) {
        return errorMessage;
    }
    return nil;
}

#pragma mark - 属性映射关系

static NSMutableDictionary<NSString *, NSArray<GYDJSONPropertyInfo *> *> *_PropertyMapCache = nil;
/** 类属性映射信息 */
+ (nonnull NSArray<GYDJSONPropertyInfo *> *)gyd_propertyInfoArray {
    NSString *className = NSStringFromClass(self);
#if GYDJSONAtomic == 1
    [_PropertyMapCacheLock lock];
#endif
    
    NSArray<GYDJSONPropertyInfo *> *array = [_PropertyMapCache objectForKey:className];
    if (!array) {
        array = [self gyd_propertyInfoArrayWithoutCache];
        if (!_PropertyMapCache) {
            _PropertyMapCache = [NSMutableDictionary dictionary];
        }
        _PropertyMapCache[className] = array;
    }
    
#if GYDJSONAtomic == 1
    [_PropertyMapCacheLock unlock];
#endif
    
    return array;
    
}

/** 获取本类属性不对外暴露 */
+ (NSArray<GYDJSONPropertyInfo *> *)gyd_propertyInfoArrayWithoutCache {
    NSMutableArray<GYDJSONPropertyInfo *> *array = [NSMutableArray array];
    gyd_class_enumerateMethod(self, YES, ^(const char * _Nonnull methodName, BOOL * _Nonnull stop) {
        char *p = strstr(methodName, GYDJSON________SetterPerfix);
        
        //不是规定的开头，或者不是setter方法，就不处理
        if (p != methodName) {
            return;
        }
        methodName = p + GYDJSON________SetterPerfixLength;
        
        const char *end = methodName + strlen(methodName) - 1;
        if (*end != ':') {
            return;
        }
        
        GYDJSONPropertyInfo *info = [[GYDJSONPropertyInfo alloc] init];
        
        p = strstr(methodName, GYDJSON________SetterRename);
        if (NULL != p) {
            info->_modelName = [[NSString alloc] initWithBytes:methodName length:p - methodName encoding:NSUTF8StringEncoding];
            methodName = p + GYDJSON________SetterRenameLength;
        }
        
        p = strstr(methodName, GYDJSON________SetterType);
        if (NULL == p) {
            info->_jsonName = [[NSString alloc] initWithBytes:methodName length:end - methodName encoding:NSUTF8StringEncoding];
        } else {
            info->_jsonName = [[NSString alloc] initWithBytes:methodName length:p - methodName encoding:NSUTF8StringEncoding];
            methodName = p + GYDJSON________SetterTypeLength;
            NSString *arrayType = [[NSString alloc] initWithBytes:methodName length:end - methodName encoding:NSUTF8StringEncoding];
            info->_arrayClass = NSClassFromString(arrayType);
        }
        if (!info->_modelName) {
            info->_modelName = info->_jsonName;
        }
        //父类的属性也可以渠道
        objc_property_t pro = class_getProperty(self, [info->_modelName cStringUsingEncoding:NSUTF8StringEncoding]);
        
        if (!pro) {
            GYDFoundationError(@"获取属性失败class:%@,property:%@", NSStringFromClass(self), info->_modelName);
            return;
        }
        char *classNameNeedFree = NULL;
        char *typeNeedFree = NULL;
        gyd_class_getPropertyType(property_getAttributes(pro), &classNameNeedFree, &typeNeedFree);
        if (NULL != classNameNeedFree) {
            info->_propertyClass = NSClassFromString([NSString stringWithCString:classNameNeedFree encoding:NSUTF8StringEncoding]);
            free(classNameNeedFree);
            classNameNeedFree = NULL;
        }
        if (NULL != typeNeedFree) {
            info->_encodeType = [NSString stringWithCString:typeNeedFree encoding:NSUTF8StringEncoding];
            free(typeNeedFree);
            typeNeedFree = NULL;
        }
        
        [array addObject:info];
    });
    return array;
}

#pragma mark - 内存警告处理

+ (void)didReceiveMemoryWarning {
#if GYDJSONAtomic == 1
    [_PropertyMapCacheLock lock];
#endif
    _PropertyMapCache = nil;
#if GYDJSONAtomic == 1
    [_PropertyMapCacheLock unlock];
#endif
}

@end
