//
//  GYDJSONExampleModel.h
//  iOSExample
//
//  Created by 宫亚东 on 2018/10/31.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+GYDJSONObject.h"

@interface GYDJSONExampleModel : NSObject

GYDJSONProperty(NSString *, key1);

GYDJSONPropertyNamed(NSInteger, key2, jsonKey2);    //model中的key2属性，对应json结构中的jsonKey2字段

GYDJSONPropertyArray(NSString , *, stringArray);    //对应json结构的数组中元素类型是字符串

GYDJSONPropertyArrayNamed(GYDJSONExampleModel, *, modelArray, models); //对应json结构的数组中元素类型又是一个可以和GYDJSONExampleModel互转的字典

@end
