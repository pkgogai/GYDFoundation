//
//  UIScrollView+GYDContentInset.m
//  GYDFoundation
//
//  Created by gongyadong on 2022/8/23.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "UIScrollView+GYDContentInset.h"
#import "GYDEdgeInsetsObject.h"
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
    GYDEdgeInsetsObject *m = [[GYDEdgeInsetsObject alloc] init];
    m->_top = inset.top;
    m->_left = inset.left;
    m->_bottom = inset.bottom;
    m->_right = inset.right;
    NSMutableDictionary *dic = [self gyd_contentInsetDictionary];
    dic[key ?: [NSNull null]] = m;
    UIEdgeInsets allInset = UIEdgeInsetsZero;
    for (GYDEdgeInsetsObject *m in dic) {
        allInset.top += m->_top;
        allInset.left += m->_left;
        allInset.bottom += m->_bottom;
        allInset.right += m->_right;
    }
    [self setContentInset:allInset];
}

- (UIEdgeInsets)gyd_contentInsetForKey:(NSString *)key {
    GYDEdgeInsetsObject *m = [self gyd_contentInsetDictionary][key ?: [NSNull null]];
    if (!m) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(m->_top, m->_left, m->_bottom, m->_right);
}

@end
