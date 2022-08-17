//
//  GYDShellCodeAnalysisRouteTools.m
//  GYDFoundation
//
//  Created by gongyadong on 2021/11/1.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDShellCodeAnalysisRouteTools.h"
#import "GYDFoundationPrivateHeader.h"

//计算过程中用的数据类型
@interface GYDShellCodeAnalysisRouteToolsPlanModel : NSObject

@property (nonatomic) NSString *from;

@property (nonatomic) NSInteger distance;

@end

@implementation GYDShellCodeAnalysisRouteToolsPlanModel

@end


@implementation GYDShellCodeAnalysisRouteTools
{
    NSMutableArray<GYDShellCodeAnalysisRouteItem *> *_routeArray;
}

- (void)planRouteWithDataDic:(NSMutableDictionary<NSString *,GYDShellCodeAnalysisResultClassItem *> *)dataDic keepClassArray:(NSSet<NSString *> *)keepClassSet {
    
    _routeArray = [NSMutableArray array];
    
    for (NSString *type in keepClassSet) {
        GYDShellCodeAnalysisResultClassItem *item = dataDic[type];
        if (!item) {
            continue;
        }
        NSMutableDictionary *planDic = [NSMutableDictionary dictionary];
        GYDShellCodeAnalysisRouteToolsPlanModel *plan = [[GYDShellCodeAnalysisRouteToolsPlanModel alloc] init];
        plan.from = nil;
        plan.distance = 0;
        planDic[type] = plan;
        NSMutableArray *waitingArray = [NSMutableArray arrayWithObject:type];
        
        while (waitingArray.count > 0) {
            NSString *str = waitingArray[0];
            [waitingArray removeObjectAtIndex:0];
            GYDShellCodeAnalysisRouteToolsPlanModel *plan = planDic[str];
            NSInteger distance = plan.distance + 1;
            
            GYDShellCodeAnalysisResultClassItem *cla = dataDic[str];
            [cla.allCategory enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, GYDShellCodeAnalysisResultCategoryItem * _Nonnull obj, BOOL * _Nonnull stop) {
                for (NSString *i in obj.includeTypes) {
                    if (planDic[i]) {
                        continue;
                    }
                    GYDShellCodeAnalysisRouteToolsPlanModel *plan = [[GYDShellCodeAnalysisRouteToolsPlanModel alloc] init];
                    plan.from = str;
                    plan.distance = distance;
                    planDic[i] = plan;
                    if ([keepClassSet containsObject:i]) {
                        continue;
                    }
                    [waitingArray addObject:i];
                }
            }];
        }
        
        for (NSString *planKey in planDic) {
            if (![keepClassSet containsObject:planKey]) {
                continue;
            }
            if ([planKey isEqualToString:type]) {
                continue;
            }
            GYDShellCodeAnalysisRouteItem *route = [[GYDShellCodeAnalysisRouteItem alloc] init];
            route.fromType = type;
            route.toType = planKey;
            NSMutableArray *routes = [NSMutableArray array];
            NSString *from = planKey;
            while (from) {
                GYDShellCodeAnalysisRouteToolsPlanModel *plan = planDic[from];
                if (!plan.from) {
                    GYDFoundationError(@"路径来源错误：%@", from);
                    break;
                }
                from = plan.from;
                if ([from isEqualToString:type]) {
                    break;
                }
                [routes insertObject:from atIndex:0];
                
            }
            route.routeArray = routes;
            [_routeArray addObject:route];
        }
    }
}

- (void)logType:(NSString *)type {
    printf("-----------\n");
    for (GYDShellCodeAnalysisRouteItem *route in _routeArray) {
        if (![route.fromType isEqualToString:type] && ![route.toType isEqualToString:type]) {
            continue;
        }
        printf("%s", [route.fromType cStringUsingEncoding:NSUTF8StringEncoding]);
//        printf("%s >>> %s:\n\t->", [route.fromType cStringUsingEncoding:NSUTF8StringEncoding], [route.toType cStringUsingEncoding:NSUTF8StringEncoding]);
        for (NSString *str in route.routeArray) {
            printf(" > %s", [str cStringUsingEncoding:NSUTF8StringEncoding]);
        }
        printf(" > %s", [route.toType cStringUsingEncoding:NSUTF8StringEncoding]);
        printf("\n");
    }
    printf("-----------\n");
}

@end
