//
//  UIScrollView+GYDScrollVisible.m
//  GYDDevelopment
//
//  Created by gongyadong on 2021/12/10.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "UIScrollView+GYDScrollVisible.h"
#import <objc/runtime.h>
#import "GYDUITypes.h"
#import "GYDFoundationPrivateHeader.h"

//用来记录属性
@interface GYDScrollVisibleProperty : NSObject

@property (nonatomic) CGRect lockedRect;

@property (nonatomic) UIEdgeInsets safeArea;

//为了展示出可见区域，额外增加的insets
@property (nonatomic) UIEdgeInsets insetsOffset;

@property (nonatomic) BOOL didAddKeyboardNotification;

@end

@implementation GYDScrollVisibleProperty

@end

@implementation UIScrollView (GYDScrollVisible)

#pragma mark 记录历史键盘的高度

static CGFloat KeyboardY = 0;
+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gyd_keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

+ (void)gyd_keyboardWillChange:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect frame       = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    KeyboardY = frame.origin.y;
}

#pragma mark 记录附加属性

- (GYDScrollVisibleProperty *)gyd_scrollVisibleProperty {
    static char PropertyKey;
    GYDScrollVisibleProperty *p = objc_getAssociatedObject(self, &PropertyKey);
    if (!p) {
        p = [[GYDScrollVisibleProperty alloc] init];
        objc_setAssociatedObject(self, &PropertyKey, p, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        p.lockedRect = CGRectNull;
    }
    return p;
}

- (void)setGyd_visibleRect:(CGRect)rect {
    if (@available(iOS 11.0, *)) {
        if (self.contentInsetAdjustmentBehavior != UIScrollViewContentInsetAdjustmentNever) {
            GYDFoundationWarning(@"不能使用adjustedContentInset");
            return;
        }
    }
    GYDScrollVisibleProperty *p = [self gyd_scrollVisibleProperty];
    if (!p.didAddKeyboardNotification) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gyd_keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        p.didAddKeyboardNotification = YES;
    }
    p.lockedRect = rect;
    [self gyd_showVisibleRectOnY:KeyboardY];
}
- (CGRect)gyd_visibleRect {
    GYDScrollVisibleProperty *p = [self gyd_scrollVisibleProperty];
    if (p) {
        return p.lockedRect;
    }
    return CGRectNull;
}

- (void)setGyd_visibleSafeArea:(UIEdgeInsets)gyd_visibleSafeArea {
    GYDScrollVisibleProperty *p = [self gyd_scrollVisibleProperty];
    p.safeArea = gyd_visibleSafeArea;
    [self gyd_showVisibleRectOnY:KeyboardY];
}

- (UIEdgeInsets)gyd_visibleSafeArea {
    GYDScrollVisibleProperty *p = [self gyd_scrollVisibleProperty];
    if (p) {
        return p.safeArea;
    }
    return UIEdgeInsetsZero;
}

- (void)gyd_keyboardWillChange:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect frame       = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double d           = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:d animations:^{
        [self gyd_showVisibleRectOnY:frame.origin.y];
    }];
}

- (void)gyd_showVisibleRectOnY:(CGFloat)y {
    GYDScrollVisibleProperty *p = [self gyd_scrollVisibleProperty];
    if (CGRectIsNull(p.lockedRect)) {
        //没有锁定可视位置
        if (!UIEdgeInsetsEqualToEdgeInsets(p.insetsOffset, UIEdgeInsetsZero)) {
            UIEdgeInsets insets = self.contentInset;
            insets = UIEdgeInsetsSubInsets(insets, p.insetsOffset);
            p.insetsOffset = UIEdgeInsetsZero;
            self.contentInset = insets;
        }
        return;
    }
    if (@available(iOS 11.0, *)) {
        if (self.contentInsetAdjustmentBehavior != UIScrollViewContentInsetAdjustmentNever) {
            GYDFoundationWarning(@"不能使用adjustedContentInset");
            return;
        }
    }
    
    //---------- scrollView的可见区域不应该和按屏幕区域挂钩，用本身坐标加上gyd_visibleSafeArea，更好
    //屏幕可见区域
//    UIScreen *screen = [UIScreen mainScreen];
//    CGRect frame = screen.bounds;
//    if (y > 0 && y < [UIScreen mainScreen].bounds.size.height) {
//        //有键盘在，按键盘的y作为可见区域的高度
//        frame.size.height = y;
//    }
//    //将屏幕可见区域转换为scrollView的坐标
//    frame = [self convertRect:frame fromCoordinateSpace:screen.coordinateSpace];
//    //ScrollView本身可见区域
//    {
//        CGRect bounds = self.bounds;
//        frame = CGRectIntersection(frame, bounds);
//        if (CGRectIsEmpty(frame)) {
//            frame = CGRectZero;
//        }
//    }
    //-------------------------------------------
    //可见区域，以本身坐标作为初始值
    CGRect frame = self.bounds;
    if (y > 0 && y < [UIScreen mainScreen].bounds.size.height) {
        UIScreen *screen = [UIScreen mainScreen];
        frame.size.height = [self convertPoint:CGPointMake(0, y) fromCoordinateSpace:screen.coordinateSpace].y - frame.origin.y;
        
    }
    //-------------------------------------------
    //加上gyd_visibleSafeArea
    frame.origin.x += p.safeArea.left;
    frame.origin.y += p.safeArea.top;
    frame.size.width -= p.safeArea.left + p.safeArea.right;
    frame.size.height -= p.safeArea.top + p.safeArea.bottom;
    
    //如果按默认contentInset有回弹的话，那就换成回弹后的位置
    UIEdgeInsets contentInset = self.contentInset;
    contentInset = UIEdgeInsetsSubInsets(contentInset, p.insetsOffset);
//    if (@available(iOS 11.0, *)) {
//        contentInset = UIEdgeInsetsAddInsets(contentInset, self.adjustedContentInset);
//    }
    CGPoint contentOffset = self.contentOffset;
    {
        CGPoint offset = CGPointZero;
        CGRect bounds = self.bounds;
        CGSize contentSize = self.contentSize;
        if (bounds.origin.x + bounds.size.width > contentSize.width + contentInset.right) {
            offset.x = (contentSize.width + contentInset.right) - (bounds.origin.x + bounds.size.width);
        }
        if (offset.x < -contentInset.left - bounds.origin.x) {
            offset.x = -contentInset.left - bounds.origin.x;
        }
        if (bounds.origin.y + bounds.size.height > contentSize.height + contentInset.bottom) {
            offset.y = (contentSize.height + contentInset.bottom) - (bounds.origin.y + bounds.size.height);
        }
        if (offset.y < -contentInset.top - bounds.origin.y) {
            offset.y = -contentInset.top - bounds.origin.y;
        }
        frame.origin.x += offset.x;
        frame.origin.y += offset.y;
        contentOffset.x += offset.x;
        contentOffset.y += offset.y;
    }
    
    CGRect toFrame = p.lockedRect;
    //通过当前可见区域(frame)与想要看到的区域(toFrame)的偏差
    CGPoint offset = CGPointZero;
    if (frame.origin.x + frame.size.width < toFrame.origin.x + toFrame.size.width) {
        offset.x = (toFrame.origin.x + toFrame.size.width) - (frame.origin.x + frame.size.width);
    }
    if (offset.x > toFrame.origin.x - frame.origin.x) {
        offset.x = toFrame.origin.x - frame.origin.x;
    }
    if (frame.origin.y + frame.size.height < toFrame.origin.y + toFrame.size.height) {
        offset.y = (toFrame.origin.y + toFrame.size.height) - (frame.origin.y + frame.size.height);
    }
    if (offset.y > toFrame.origin.y - frame.origin.y) {
        offset.y = toFrame.origin.y - frame.origin.y;
    }
    //根据偏差计算目标contentOffset
//    CGPoint contentOffset = self.contentOffset;
    contentOffset.x += offset.x;
    contentOffset.y += offset.y;
    
    
    //再计算出不会回弹的最小contentInset
    UIEdgeInsets minInsets = UIEdgeInsetsZero;
    CGSize contentSize = self.contentSize;
    CGSize size = self.bounds.size;
    
    minInsets.left = -contentOffset.x;
    minInsets.top = -contentOffset.y;
    minInsets.right = contentOffset.x + size.width - contentSize.width;
    minInsets.bottom = contentOffset.y + size.height - contentSize.height;
    
    //与最小的contentInset做对比，调整最终的contentInset
    GYDUIStructUnion contentV;
    contentV.edgeInsetsValue = contentInset;
    GYDUIStructUnion min;
    min.edgeInsetsValue = minInsets;
    
    for (int i = 0; i < 4; i++) {
        if (contentV.arrayValue[i] < min.arrayValue[i]) {
            contentV.arrayValue[i] = min.arrayValue[i];
        }
    }
//    if (@available(iOS 11.0, *)) {
//        contentV.edgeInsetsValue = UIEdgeInsetsSubInsets(contentV.edgeInsetsValue, self.adjustedContentInset);
//    }
    p.insetsOffset = UIEdgeInsetsAddInsets(p.insetsOffset, UIEdgeInsetsSubInsets(contentV.edgeInsetsValue, self.contentInset));
    self.contentInset = contentV.edgeInsetsValue;
    [self setContentOffset:contentOffset animated:NO];
}

@end
