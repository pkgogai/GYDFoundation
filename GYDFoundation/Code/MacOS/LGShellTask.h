//
//  LGShellTask.h
//  lib-base
//
//  Created by 宫亚东 on 2019/8/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGShellTask : NSObject

+ (int)executeShellCommand:(nonnull NSString *)command output:(out NSString * _Nullable * _Nullable)output;

@end

NS_ASSUME_NONNULL_END
