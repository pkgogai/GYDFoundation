//
//  UIView+GYDSafeArea.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/2.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "UIView+GYDSafeArea.h"
#import <objc/runtime.h>    //objc_setAssociatedObject 系列函数

@implementation UIView (GYDSafeArea)

static char GYDSafeAreaInsetsPrivateKey;

- (UIEdgeInsets)gyd_safeAreaInsets {
    UIEdgeInsets safeArea = [self gyd_safeAreaInsetsAllowNegative];
    if (safeArea.top < 0) {
        safeArea.top = 0;
    }
    if (safeArea.right < 0) {
        safeArea.right = 0;
    }
    if (safeArea.bottom < 0) {
        safeArea.bottom = 0;
    }
    if (safeArea.left < 0) {
        safeArea.left = 0;
    }
    return safeArea;
}

- (UIEdgeInsets)gyd_safeAreaInsetsAllowNegative {
    UIView *view = self;
    while (view) {
        NSDictionary *dic = objc_getAssociatedObject(view, &GYDSafeAreaInsetsPrivateKey);
        if (dic) {
            //禁用，直接返回0
            if ([dic[@"d"] boolValue]) {
                return UIEdgeInsetsZero;
            }
            
            //对于旋转的情况，要单独计算4个点，太麻烦，而且safeArea和旋转一点都不般配，就忽略吧。
            //忽略后的效果就是旋转后安全区按最少误伤的方式取值，但其内部如果有反向旋转回来的view，其安全区还是准确的。
            CGSize size = view.bounds.size;
            CGRect contextArea;
            contextArea.origin.x = [dic[@"l"] floatValue];
            contextArea.origin.y = [dic[@"t"] floatValue];
            contextArea.size.width = size.width - [dic[@"r"] floatValue] - contextArea.origin.x;
            contextArea.size.height = size.height - [dic[@"b"] floatValue] - contextArea.origin.y;
            
            contextArea = [view convertRect:contextArea toView:self];
            size = self.bounds.size;
            
            return UIEdgeInsetsMake(contextArea.origin.y, contextArea.origin.x, size.height - contextArea.origin.y - contextArea.size.height, size.width - contextArea.origin.x - contextArea.size.width);
        }
        view = view.superview;
    }
    return UIEdgeInsetsZero;
}
//以前这个只是简单的加法不考虑拉伸，平移等几何变换，但其实用到safeArea的地方并不多，没必要自己去累加，所以干脆换成系统自身的计算。这里的代码就留个纪念，
///** 通过gyd_setSafeAreaInsets计算出来的safeArea，可以有负值 */
//- (UIEdgeInsets)gyd_safeAreaInsetsAllowNegative {
//    UIView *view = self;
//    UIEdgeInsets safeAreaOffset = UIEdgeInsetsZero;
//    while (view) {
//        NSDictionary *dic = objc_getAssociatedObject(view, &GYDSafeAreaInsetsPrivateKey);
//        if (dic) {
//            UIEdgeInsets safeArea = UIEdgeInsetsMake(
//                                                     [dic[@"t"] floatValue] + safeAreaOffset.top,
//                                                     [dic[@"l"] floatValue] + safeAreaOffset.left,
//                                                     [dic[@"b"] floatValue] + safeAreaOffset.bottom,
//                                                     [dic[@"r"] floatValue] + safeAreaOffset.right
//                                                     );
//            return safeArea;
//        }
//
//        UIView *superView = view.superview;
//        if (!superView) {
//            return UIEdgeInsetsZero;
//        }
//
//        CGSize size = superView.bounds.size;
//        CGRect frame = view.frame;
//        if ([superView isKindOfClass:[UIScrollView class]]) {
//            UIScrollView *tmpView = (UIScrollView *)superView;
//            CGSize tmpSize = tmpView.contentSize;
//            UIEdgeInsets tmpInsets = tmpView.contentInset;
//            frame.origin.x += tmpInsets.left;
//            frame.origin.y += tmpInsets.top;
//
//            tmpSize.width   += tmpInsets.left + tmpInsets.right;
//            tmpSize.height  += tmpInsets.top + tmpInsets.bottom;
//
//            //11系统以下，不用管adjustedContentInset
//
//            if (size.width < tmpSize.width) {
//                size.width = tmpSize.width;
//            }
//            if (size.height < tmpSize.height) {
//                size.height = tmpSize.height;
//            }
//        }
//
//        safeAreaOffset.top  -= frame.origin.y;
//        safeAreaOffset.left -= frame.origin.x;
//        safeAreaOffset.bottom -= size.height - frame.size.height - frame.origin.y;
//        safeAreaOffset.right  -= size.width - frame.size.width - frame.origin.x;
//        view = superView;
//    }
//    return UIEdgeInsetsZero;
//}

- (void)gyd_setSafeAreaInsets:(UIEdgeInsets)safeAreaInsets {
    NSDictionary *safeArea = @{
                               @"t" : @(safeAreaInsets.top),
                               @"l" : @(safeAreaInsets.left),
                               @"r" : @(safeAreaInsets.right),
                               @"b" : @(safeAreaInsets.bottom)
                               };
    objc_setAssociatedObject(self, &GYDSafeAreaInsetsPrivateKey, safeArea, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)gyd_resetSafeAreaInsets {
    objc_setAssociatedObject(self, &GYDSafeAreaInsetsPrivateKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)gyd_disableSafeArea {
    objc_setAssociatedObject(self, &GYDSafeAreaInsetsPrivateKey, @{@"d" : @(YES)}, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
