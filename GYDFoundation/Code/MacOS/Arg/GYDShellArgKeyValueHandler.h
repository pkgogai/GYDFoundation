//
//  GYDShellArgKeyValueHandler.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/09/07.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDShellArgHanlder.h"

/**
 约定参数格式： path -key1 value1 -key2 value2 -key3 value3
 注意，如果没有value值，也要用一个 "" 占位
*/

@interface GYDShellArgKeyValueHandler : GYDShellArgHanlder

- (nullable NSString *)argForKey:(nonnull NSString *)key;

- (nullable NSDictionary *)argDictionary;

@end

