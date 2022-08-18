//
//  gyd_class_property.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/11.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#ifndef gyd_class_property_h
#define gyd_class_property_h

#include <objc/runtime.h>
#include <objc/objc.h>

NS_ASSUME_NONNULL_BEGIN

/** 方法交换 */
bool gyd_exchangeSelector(Class oClass, SEL oSelector, Class sClass, SEL sSelector);

/** 类方法交换 */
bool gyd_exchangeClassSelector(Class oClass, SEL oClassSelector, Class sClass, SEL sClassSelector);

/** 遍历所有的子类（不包括本类）。没缓存，一次性的，效率低，应只在开发时使用。 */
void gyd_class_enumerateSubClass(Class _Nonnull superClass, void (^ _Nonnull block)(Class _Nonnull subClass, BOOL * _Nonnull stop));

/** 遍历本类的所有方法 */
void gyd_class_enumerateMethod(Class _Nonnull c, BOOL containsSuperClass, void (^ _Nonnull block)(const char * _Nonnull methodName, BOOL * _Nonnull stop));

/** 遍历本类的所有属性名 */
void gyd_class_enumeratePropery(Class _Nonnull c, BOOL containsSuperClass, void (^ _Nonnull block)(const char * _Nonnull properyName, const char * _Nonnull attributes, BOOL * _Nonnull stop));

/** 遍历本类的所有成员变量名 */
void gyd_class_enumerateIvar(Class _Nonnull c, BOOL containsSuperClass, void (^ _Nonnull block)(const char * _Nonnull name, ptrdiff_t offset, const char * _Nonnull type, BOOL * _Nonnull stop));

//如果不想在外面用free()，那就用block形式的吧
void gyd_class_getPropertyType_block(const char * _Nonnull attributes, void (^ _Nonnull block)(char * _Nullable className, char * _Nullable type));

NS_ASSUME_NONNULL_END

#endif /* gyd_class_property_h */

/*
 在 iPhone 6s Plus 上测试，用
 void gyd_class_getPropertyType_block(const char * _Nonnull attributes, void (^ _Nonnull block)(char * _Nullable className, char * _Nullable type));
 速度几乎是
 void gyd_class_getPropertyType(const char * _Nonnull attributes, char * _Nullable * _Nonnull classNameNeedFree, char * _Nullable * _Nonnull typeNeedFree);
 的2倍
 "T@id":
    0.441111, 0.854748
 T@'ViewController'":
    0.750144, 1.236096
 block内用__block 修饰的对象几乎没影响，不加__block修饰的对象，要多一半的时间。用了self的成员变量则速度比不用block还要略慢。
 里面加上对"T@id"类型的char * 转 NSString * 时，用了 NoCopy:length:freeWhenDone: 后，总体时间大概变成了4倍（freeWhenDone是YES/NO都一样）。
 
     char *a="T@id";
//    char *a="T@'ViewController'";
    NSTimeInterval t1 = [NSDate timeIntervalSinceReferenceDate];
    for (NSInteger i = 0; i < 10000000; i ++) {
        gyd_class_getPropertyType_block(a, ^(char * _Nullable className, char * _Nullable type) {
            NSInteger k = i;
        });
    }
    NSTimeInterval t2 = [NSDate timeIntervalSinceReferenceDate];

    for (NSInteger i = 0; i < 10000000; i ++) {
        char *c = NULL;
        char *d = NULL;
        NSInteger k = i;
        gyd_class_getPropertyType(a, &c, &d);
        if (c) {
            free(c);
        }
        if (d) {
            free(d);
        }
    }
 
    NSTimeInterval t3 = [NSDate timeIntervalSinceReferenceDate];
 
    NSLog(@"%lf, %lf", t2 - t1, t3 - t2);
 */
