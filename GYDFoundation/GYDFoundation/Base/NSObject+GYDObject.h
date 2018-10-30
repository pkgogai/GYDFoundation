//
//  NSObject+GYDObject.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/11.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (GYDObject)

/** 是否是这个类型（不包含子类） */
- (BOOL)gyd_isClass:(nonnull Class)c;

/** 是否是这个类或这个类型的子类型 */
- (BOOL)gyd_isClassOrSubOfClass:(nonnull Class)c;

/** 遍历所有的子类（不包括本类）。效率低，应只在开发时使用。 */
+ (void)gyd_enumerateSubClassUsingBlock:(void (^ _Nonnull )(Class _Nonnull subClass, BOOL * _Nonnull stop))block;

/** 遍历本类的所有方法名，不包含父类方法 */
+ (void)gyd_enumerateMethodContainsSuperClass:(BOOL)containsSuperClass usingBlock:(void (^ _Nonnull)(const char  * _Nonnull methodName, BOOL * _Nonnull stop))block;

/** 遍历本类的所有属性名 */
+ (void)gyd_enumerateProperyContainsSuperClass:(BOOL)containsSuperClass usingBlock:(void (^ _Nonnull)(const char  * _Nonnull properyName, const char * _Nonnull attributes, BOOL * _Nonnull stop))block;

/** 获取具体属性的类型，如果是id类，则给class赋值，如果是int float等则给type赋值，例如：class="NSString" 或 type="i" */
+ (BOOL)gyd_getTypeOfProperty:(nonnull NSString *)propertyName usingBlock:(void (^ _Nonnull)(char * _Nullable className, char * _Nullable type))block;

@end
