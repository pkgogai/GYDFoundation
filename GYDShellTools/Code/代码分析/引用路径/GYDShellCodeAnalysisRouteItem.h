//
//  GYDShellCodeAnalysisRouteItem.h
//  GYDFoundation
//
//  Created by gongyadong on 2021/11/1.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 对于多个路径 ，中间有重合的情况，一条路径跑通，其它的跑到重合的位置即可。
 
 */

/**
 类之间的路径，最终的处理结果，用来搜索
 */
@interface GYDShellCodeAnalysisRouteItem : NSObject

@property (nonatomic) NSString *fromType;

@property (nonatomic) NSString *toType;

@property (nonatomic) NSInteger distance;

@property (nonatomic) NSArray<NSString *> *routeArray;

@end

NS_ASSUME_NONNULL_END
