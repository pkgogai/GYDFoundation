//
//  NSObject+GYDObject.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/11.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "NSObject+GYDObject.h"
#import "gyd_class_property.h"
#include <objc/runtime.h>

@implementation NSObject (GYDObject)

/** 是否是这个类型（不包含子类） */
- (BOOL)gyd_isClass:(nonnull Class)c {
    return [self isMemberOfClass:c];
}

/** 是否是这个类或这个类型的子类型 */
- (BOOL)gyd_isClassOrSubOfClass:(nonnull Class)c {
    return [self isKindOfClass:c];
}

/** 遍历所有的子类（不包括本类）。效率低，应只在开发时使用。 */
+ (void)gyd_enumerateSubClassUsingBlock:(void (^ _Nonnull )(Class _Nonnull subClass, BOOL * _Nonnull stop))block {
    gyd_class_enumerateSubClass(self, block);
}

/** 遍历本类的所有方法名，不包含父类方法 */
+ (void)gyd_enumerateMethodContainsSuperClass:(BOOL)containsSuperClass usingBlock:(void (^ _Nonnull)(const char  * _Nonnull methodName, BOOL * _Nonnull stop))block {
    gyd_class_enumerateMethod(self, containsSuperClass, block);
}

/** 遍历本类的所有属性名 */
+ (void)gyd_enumerateProperyContainsSuperClass:(BOOL)containsSuperClass usingBlock:(void (^ _Nonnull)(const char  * _Nonnull properyName, const char * _Nonnull attributes, BOOL * _Nonnull stop))block {
    gyd_class_enumeratePropery(self, containsSuperClass, block);
}

/** 获取具体属性的类型，如果是id类，则给class赋值，如果是int float等则给type赋值，例如：class="NSString" 或 type="i" */
+ (BOOL)gyd_getTypeOfProperty:(nonnull NSString *)propertyName usingBlock:(void (^ _Nonnull)(char * _Nullable className, char * _Nullable type))block {
    if (!block) {
        return NO;
    }
    objc_property_t pro = class_getProperty(self, [propertyName cStringUsingEncoding:NSUTF8StringEncoding]);
    if (!pro) {
        return NO;
    }
    gyd_class_getPropertyType_block(property_getAttributes(pro), block);
    return YES;
}

@end
