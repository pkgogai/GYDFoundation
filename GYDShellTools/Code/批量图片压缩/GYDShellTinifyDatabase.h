//
//  GYDShellTinifyDatabase.h
//  GYDFoundation
//
//  Created by gongyadong on 2020/12/17.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellTinifyDatabase : NSObject

- (instancetype)initWithPath:(NSString *)path;

- (NSInteger)state:(NSInteger)state forFileMd5:(NSString *)md5;

- (NSString *)setName:(NSString *)name state:(NSInteger)state forFileMd5:(NSString *)md5;

@end

NS_ASSUME_NONNULL_END
