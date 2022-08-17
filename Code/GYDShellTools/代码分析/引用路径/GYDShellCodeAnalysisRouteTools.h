//
//  GYDShellCodeAnalysisRouteTools.h
//  GYDFoundation
//
//  Created by gongyadong on 2021/11/1.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDShellCodeAnalysisRouteItem.h"
#import "GYDShellCodeAnalysisResultItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellCodeAnalysisRouteTools : NSObject

- (void)planRouteWithDataDic:(NSMutableDictionary<NSString *, GYDShellCodeAnalysisResultClassItem *> *)dataDic keepClassArray:(NSSet<NSString *> *)keepClassSet;


- (void)logType:(NSString *)type;


@end

NS_ASSUME_NONNULL_END
