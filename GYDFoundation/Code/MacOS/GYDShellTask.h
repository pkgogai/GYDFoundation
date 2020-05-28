//
//  GYDShellTask.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2019/8/10.
//

#import <Foundation/Foundation.h>

@interface GYDShellTask : NSObject

+ (int)executeShellCommand:(nonnull NSString *)command output:(out NSString * _Nullable * _Nullable)output;

@end
