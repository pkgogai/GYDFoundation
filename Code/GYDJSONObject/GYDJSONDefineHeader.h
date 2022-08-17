//
//  GYDJSONDefineHeader.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/11.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#ifndef GYDJSONDefineHeader_h
#define GYDJSONDefineHeader_h

/*
 通过修改setter方法名来解释属性的处理方式，
 
 普通属性：
 属性名与服务器相同：GYDJSONProperty(type, name) -> ZZSET__${name}
 属性名与服务器不同：GYDJSONPropertyNamed(type, name, JSONName)  -> ZZSET__${modelName}__TO__${JSONName}
 
 数组属性：
 属性名与服务器相同：GYDJSONPropertyArray(type, star, name) -> ZZSET__${name}__AS__${type}
 属性名与服务器不同：GYDJSONPropertyArrayNamed(type, star, name, JSONName)  ->  ZZSET__${modelName}__TO__${JSONName}__AS__${type}
 */

#pragma mark - 内部宏定义中 “Property” 改成 “________”，以在代码提示时减少干扰

#define GYDJSON________SetterPerfix "ZZSET__"
#define GYDJSON________SetterPerfixLength 7

#define GYDJSON________SetterRename "__TO__"
#define GYDJSON________SetterRenameLength 6

#define GYDJSON________SetterType "__AS__"
#define GYDJSON________SetterTypeLength 6

#define GYDJSON________SetterName(name) ZZSET__##name:
#define GYDJSON________SetterNamed(modelName, JSONName) ZZSET__##modelName##__TO__##JSONName:

#define GYDJSON________ArraySetterName(type, name) ZZSET__##name##__AS__##type:
#define GYDJSON________ArraySetterNamed(type, modelName,JSONName) ZZSET__##modelName##__TO__##JSONName##__AS__##type:

#define GYDJSONProperty(type, name) @property (nonatomic, setter=GYDJSON________SetterName(name)) type name
#define GYDJSONPropertyNamed(type, name, JSONName) @property (nonatomic, setter=GYDJSON________SetterNamed(name, JSONName)) type name


#define GYDJSONPropertyArray(type, star, name) @property (nonatomic, setter=GYDJSON________ArraySetterName(type, name)) NSArray <type star> *name
#define GYDJSONPropertyArrayNamed(type, star, name, JSONName) @property (nonatomic, setter=GYDJSON________ArraySetterNamed(type, name, JSONName)) NSArray <type star> *name


#endif /* GYDJSONDefineHeader_h */
