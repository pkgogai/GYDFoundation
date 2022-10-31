//
//  UIScrollView+GYDContentInset.m
//  GYDFoundation
//
//  Created by gongyadong on 2022/8/23.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "UIScrollView+GYDContentInset.h"
#import "GYDUITypes.h"
#import <objc/runtime.h>    //objc_setAssociatedObject 系列函数

@implementation UIScrollView (GYDContentInset)

static char UIScrollViewGYDContentInsetKey;

- (NSMutableDictionary *)gyd_contentInsetDictionary {
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &UIScrollViewGYDContentInsetKey);
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &UIScrollViewGYDContentInsetKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dic;
}

/** 叠加多个contentInset，通过不同的key来区分，每次调用时更新 */
- (void)gyd_setContentInset:(UIEdgeInsets)inset forKey:(NSString *)key {
    [self gyd_setContentInset:inset forKey:key min:NO];
}

- (UIEdgeInsets)gyd_contentInsetForKey:(NSString *)key {
    GYDUIStructObject *m = [self gyd_contentInsetDictionary][key ?: [NSNull null]];
    if (!m) {
        return UIEdgeInsetsZero;
    }
    return m->_value.edgeInsetsValue;
}

- (NSMutableDictionary *)gyd_minContentInsetDictionary {
    static char k;
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &k);
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &k, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dic;
}

- (void)gyd_setMinContentInset:(UIEdgeInsets)inset forKey:(NSString *)key {
    [self gyd_setContentInset:inset forKey:key min:YES];
}
- (UIEdgeInsets)gyd_minContentInsetForKey:(NSString *)key {
    GYDUIStructObject *m = [self gyd_minContentInsetDictionary][key ?: [NSNull null]];
    if (!m) {
        return UIEdgeInsetsZero;
    }
    return m->_value.edgeInsetsValue;
}

- (void)gyd_setContentInset:(UIEdgeInsets)inset forKey:(NSString *)key min:(BOOL)min {
    NSMutableDictionary *dic = [self gyd_contentInsetDictionary];
    NSMutableDictionary *minDic = [self gyd_minContentInsetDictionary];
    
    NSMutableDictionary *currentDic = min ? minDic : dic;
    GYDUIStructObject *m = currentDic[key];
    if (!m) {
        m = [[GYDUIStructObject alloc] init];
        currentDic[key] = m;
    }
    m->_value.edgeInsetsValue = inset;
    
    GYDUIStructUnion result;
    result.edgeInsetsValue = UIEdgeInsetsZero;
    for (GYDUIStructObject *m in dic.allValues) {
        for (NSInteger i = 0; i < 4; i++) {
            result.arrayValue[i] += m->_value.arrayValue[i];
        }
    }
    for (GYDUIStructObject *m in minDic.allValues) {
        for (NSInteger i = 0; i < 4; i++) {
            if (result.arrayValue[i] < m->_value.arrayValue[i]) {
                result.arrayValue[i] = m->_value.arrayValue[i];
            }
        }
    }
    [self setContentInset:result.edgeInsetsValue];
}


@end
