//
//  gyd_class_property.c
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/11.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#include "gyd_class_property.h"
#include <objc/runtime.h>   //objc_xxx
#include <stdlib.h>         //free
#include <string.h>         //strstr,strncpy
#include <objc/NSObject.h>  //NSObject
//#import <Foundation/Foundation.h> //这个包含了stdlib.h，string.h，NSObject.h

/** 遍历所有的子类（不包括本类）。没缓存，一次性的，效率低，应只在开发时使用。 */
void gyd_class_enumerateSubClass(Class _Nonnull superClass, void (^ _Nonnull block)(Class _Nonnull subClass, BOOL * _Nonnull stop)) {
    if (!block) {
        return;
    }
    unsigned int numClasses = 0;
    Class *classes = objc_copyClassList(&numClasses);
    
    if (numClasses > 0) {
        BOOL stop = NO;
        for (int i = 0; i < numClasses; i++) {
            //注意，因为不确定是不是 NSObject 的子类，所以不能使用 NSObject 的 isSubclassOfClass 方法
            Class tmpClass = class_getSuperclass(classes[i]);
            while (tmpClass != NULL) {
                if (tmpClass == superClass) {
                    block(classes[i], &stop);
                    if (stop) {
                        free(classes);
                        return;
                    }
                    break;
                } else if (tmpClass == [NSObject class]) {  //文件名要用.m，不能用.c
                    break;
                } else {
                    tmpClass = class_getSuperclass(tmpClass);
                }
            }
        }
    }
    if (classes != NULL) {
        free(classes);
    }
    return;
}

/** 遍历本类的所有方法 */
void gyd_class_enumerateMethod(Class _Nonnull c, BOOL containsSuperClass, void (^ _Nonnull block)(const char * _Nonnull methodName, BOOL * _Nonnull stop)) {
    if (!block) {
        return;
    }
    unsigned int count = 0;
    Method *methods = class_copyMethodList(c, &count);
    BOOL stop = NO;
    for (int i =0; i < count; i++) {
        block(sel_getName(method_getName(methods[i])), &stop);
        if (stop) {
            break;
        }
    }
    if (methods) {
        free(methods);
    }
    if (containsSuperClass) {
        Class superClass = class_getSuperclass(c);
        if (superClass) {
            gyd_class_enumerateMethod(superClass, YES, block);
        }
    }
}

/** 遍历本类的所有属性名 */
void gyd_class_enumeratePropery(Class _Nonnull c, BOOL containsSuperClass, void (^ _Nonnull block)(const char * _Nonnull properyName, const char * _Nonnull attributes, BOOL * _Nonnull stop)) {
    if (!block) {
        return;
    }
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(c, &count);
    BOOL stop = NO;
    for (int i = 0; i < count; i++) {
        block(property_getName(properties[i]), property_getAttributes(properties[i]), &stop);
        if (stop) {
            break;
        }
    }
    if (properties) {
        free(properties);
    }
    if (containsSuperClass) {
        Class superClass = class_getSuperclass(c);
        if (superClass) {
            gyd_class_enumeratePropery(superClass, YES, block);
        }
    }
}

//如果不想在外面用free()，那就用block形式的吧
void gyd_class_getPropertyType_block(const char * _Nonnull attributes, void (^ _Nonnull block)(char * _Nullable className, char * _Nullable type)) {
    BOOL isFirstChar = YES;
    for (const char *p = attributes; *p != '\0'; p ++) {
        if (*p == 'T' && isFirstChar) {
            char *end = strstr(p, ",");
            unsigned long len;
            if (end) {
                len = end - p;
            } else {
                len = strlen(p);
            }
            //就算到结尾了，那也是','或者'\0'，不用担心越界
            if (p[1] == '@') {
                if (len > 4) {
                    char str[len - 3];
                    strncpy(str, p + 3, len - 4);
                    str[len - 4] = '\0';
                    block(str, NULL);
                } else {
                    block("id", NULL);
                }
            } else {
                char str[len];
                strncpy(str, p + 1, len - 1);
                str[len - 1] = '\0';
                block(NULL, str);
            }
            return;
        } else if (*p == ',') {
            isFirstChar = YES;
        } else {
            isFirstChar = NO;
        }
    }
    block(NULL, NULL);
}
