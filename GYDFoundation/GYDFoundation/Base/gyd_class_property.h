//
//  gyd_class_property.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/11.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#ifndef gyd_class_property_h
#define gyd_class_property_h

#include <objc/objc.h>

/** 遍历所有的子类（不包括本类）。没缓存，一次性的，效率低，应只在开发时使用。 */
void gyd_class_enumerateSubClass(Class _Nonnull superClass, void (^ _Nonnull block)(Class _Nonnull subClass, BOOL * _Nonnull stop));

/** 遍历本类的所有方法 */
void gyd_class_enumerateMethod(Class _Nonnull c, BOOL containsSuperClass, void (^ _Nonnull block)(const char * _Nonnull methodName, BOOL * _Nonnull stop));

/** 遍历本类的所有属性名 */
void gyd_class_enumeratePropery(Class _Nonnull c, BOOL containsSuperClass, void (^ _Nonnull block)(const char * _Nonnull properyName, const char * _Nonnull attributes, BOOL * _Nonnull stop));

/**
 通过property_getAttributes()的值获取属性类型，如果是id类，则class赋值，如果是int float等则type赋值，例如：class="NSString" 或 type="i"
 注意：*classNameNeedFree和*typeNeedFree 如果有值，则需要在外部调用free()函数释放内存。
 这里要求了参数 _Nonnull，里面就不做空检查了，要是传NULL会闪退的
 */
void gyd_class_getPropertyType(const char * _Nonnull attributes, char * _Nullable * _Nonnull classNameNeedFree, char * _Nullable * _Nonnull typeNeedFree);
//如果不想在外面用free()，那就用block形式的吧
void gyd_class_getPropertyType_block(const char * _Nonnull attributes, void (^ _Nonnull block)(char * _Nullable className, char * _Nullable type));

#endif /* gyd_class_property_h */
