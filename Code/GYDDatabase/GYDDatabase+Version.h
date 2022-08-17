//
//  GYDDatabase+Version.h
//  FMDB
//
//  Created by 宫亚东 on 2018/11/9.
//

#import "GYDDatabase.h"

@interface GYDDatabase (Version)

- (BOOL)updateVersion:(long long)version forKey:(nonnull NSString *)key actionBlock:(BOOL (NS_NOESCAPE ^ _Nonnull)(FMDatabase * _Nonnull db, long long lastVersion))block;

@end

