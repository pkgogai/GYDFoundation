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
    CGPoint contentOffset = self.contentOffset;
    
    //难得用一次系统的坐标转换，就顺便把旋转方向也加上吧，size是方向
    CGPoint keyboardPoint = CGPointMake(0, frame.origin.y + frame.size.height);
    CGPoint keyboardDirection = CGPointMake(0, -1);
    if (y > 0 && y < [UIScreen mainScreen].bounds.size.height) {
        UIScreen *screen = [UIScreen mainScreen];
        keyboardPoint = [self convertPoint:CGPointMake(0, y) fromCoordinateSpace:screen.coordinateSpace];
        keyboardDirection = [self convertPoint:CGPointMake(0, y - 1) fromCoordinateSpace:screen.coordinateSpace];
        keyboardDirection.x -= keyboardPoint.x;
        keyboardDirection.y -= keyboardPoint.y;
        
//        keyboardPoint.x -= contentOffset.x;
//        keyboardPoint.y -= contentOffset.y;
        
    }
    //-------------------------------------------
    //如果按默认contentInset有回弹的话，那就换成回弹后的位置
    UIEdgeInsets contentInset = self.contentInset;
    contentInset = UIEdgeInsetsSubInsets(contentInset, p.insetsOffset);
//    if (@available(iOS 11.0, *)) {
//        contentInset = UIEdgeInsetsAddInsets(contentInset, self.adjustedContentInset);
//    }
    
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
        keyboardPoint.x += offset.x;
        keyboardPoint.y += offset.y;
        contentOffset.x += offset.x;
        contentOffset.y += offset.y;
    }
    
    CGRect toFrame = p.lockedRect;
    //留出gyd_visibleSafeArea
    toFrame.origin.x -= p.safeArea.left;
    toFrame.origin.y -= p.safeArea.top;
    toFrame.size.width += p.safeArea.left + p.safeArea.right;
    toFrame.size.height += p.safeArea.top + p.safeArea.bottom;
    
    //根据可见区域、目标区域、键盘方向，计算目标contentOffset
    CGPoint offset = [self offsetWithVisibleRect:frame targetRect:toFrame keyboardPoint:keyboardPoint direction:keyboardDirection];
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

//通过当前可见区域(VisibleRect)与想要看到的目标区域(targetRect)，还有键盘方向keyboardDirection来计算需要进行的偏移
- (CGPoint)offsetWithVisibleRect:(CGRect)rect targetRect:(CGRect)target keyboardPoint:(CGPoint)keyboardPoint direction:(CGPoint)keyboardDirection {
    //记录一下开始位置，然后把target处理到合适位置，最后返回差值
    CGPoint origin = target.origin;  //
    //先看键盘方向，这里就只按4个方向移动来寻找合适位置
    NSInteger dirction = 0; //0上,1左,2下,3右
    if (keyboardDirection.y <= keyboardDirection.x && keyboardDirection.y <= -keyboardDirection.x) {
        //向上
        dirction = 0;
    } else if (keyboardDirection.y >= keyboardDirection.x && keyboardDirection.y >= -keyboardDirection.x) {
        //向下
        dirction = 2;
    } else if (keyboardDirection.x > keyboardDirection.y && keyboardDirection.x > -keyboardDirection.y) {
        //向右
        dirction = 3;
    } else if (keyboardDirection.x < keyboardDirection.y && keyboardDirection.x < -keyboardDirection.y) {
        //向左
        dirction = 1;
    } else {
        //漏了，按默认值向上
        GYDFoundationError(@"漏边界值了");
    }

    if (dirction == 0 || dirction == 2) {
        //先处理左右边界
        if (target.origin.x > rect.origin.x + rect.size.width - target.size.width) {
            target.origin.x = rect.origin.x + rect.size.width - target.size.width;
        }
        if (target.origin.x < rect.origin.x) {
            target.origin.x = rect.origin.x;
        }
        //再处理上下边界
        //斜率
        CGFloat slope = - keyboardDirection.x / keyboardDirection.y;
        CGFloat leftY = (target.origin.x - keyboardPoint.x) * slope + keyboardPoint.y;
        CGFloat rightY = leftY + target.size.width * slope;
        if (dirction == 0) {
            CGFloat y = MIN(leftY, rightY);
            y = MIN(y, rect.origin.y + rect.size.height);
            if (target.origin.y > y - target.size.height) {
                target.origin.y = y - target.size.height;
            }
            if (target.origin.y < rect.origin.y) {
                target.origin.y = rect.origin.y;
            }
        } else {
            CGFloat y = MAX(leftY, rightY);
            y = MAX(y, rect.origin.y);
            if (target.origin.y < y) {
                target.origin.y = y;
            }
        }
    } else {
        //先处理上下边界
        if (target.origin.y > rect.origin.y + rect.size.height - target.size.height) {
            target.origin.y = rect.origin.y + rect.size.height - target.size.height;
        }
        if (target.origin.y < rect.origin.y) {
            target.origin.y = rect.origin.y;
        }
        //再处理左右边界
        CGFloat slope = - keyboardDirection.y / keyboardDirection.x;
        CGFloat topX = (target.origin.y - keyboardPoint.y) * slope + keyboardPoint.x;
        CGFloat bottomX = topX + target.size.height * slope;
        if (dirction == 1) {
            CGFloat x = MIN(topX, bottomX);
            x = MIN(x, rect.origin.x + rect.size.width);
            if (target.origin.x > x - target.size.width) {
                target.origin.x = x - target.size.width;
            }
            if (target.origin.x < rect.origin.x) {
                target.origin.x = rect.origin.x;
            }
        } else {
            CGFloat x = MAX(topX, bottomX);
            x = MAX(x, rect.origin.x);
            if (target.origin.x < x) {
                target.origin.x = x;
            }
        }
    }
    return CGPointMake(origin.x - target.origin.x, origin.y - target.origin.y);
}

@end
