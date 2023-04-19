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
//    原来是我的问题，一开始以为 contentInset和adjustedContentInset 是叠加的，所以会出现问题。现在仔细验证一下，原来adjustedContentInset已经包含了contentInset
//    if (@available(iOS 11.0, *)) {
//        if (self.contentInsetAdjustmentBehavior != UIScrollViewContentInsetAdjustmentNever) {
//            GYDFoundationWarning(@"不能使用adjustedContentInset");
//            return;
//        }
//    }
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
//    if (@available(iOS 11.0, *)) {
//        if (self.contentInsetAdjustmentBehavior != UIScrollViewContentInsetAdjustmentNever) {
//            GYDFoundationWarning(@"不能使用adjustedContentInset");
//            return;
//        }
//    }
    
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
    
    //难得用一次系统的坐标转换，就顺便把旋转方向也加上吧
    CGPoint keyboardPoint = CGPointMake(0, frame.origin.y + frame.size.height); //键盘或屏幕底部的一个坐标点
    CGPoint keyboardDirection = CGPointMake(0, -1); //键盘的方向
    CGPoint keyboardHorizon = CGPointMake(1, 0);    //键盘或屏幕底部的水平线
    if (y > 0 && y < [UIScreen mainScreen].bounds.size.height) {
        UIScreen *screen = [UIScreen mainScreen];
        keyboardPoint = [self convertPoint:CGPointMake(0, y) fromCoordinateSpace:screen.coordinateSpace];
        keyboardDirection = [self convertPoint:CGPointMake(0, y - 1) fromCoordinateSpace:screen.coordinateSpace];
        keyboardHorizon = [self convertPoint:CGPointMake(1, y) fromCoordinateSpace:screen.coordinateSpace];
        keyboardDirection.x -= keyboardPoint.x;
        keyboardDirection.y -= keyboardPoint.y;
        
        keyboardHorizon.x -= keyboardPoint.x;
        keyboardHorizon.y -= keyboardPoint.y;
    }
    //-------------------------------------------
    //如果按默认contentInset有回弹的话，那就换成回弹后的位置
    UIEdgeInsets contentInset = self.contentInset;
    if (@available(iOS 11.0, *)) {
        contentInset = self.adjustedContentInset;
    }
    contentInset = UIEdgeInsetsSubInsets(contentInset, p.insetsOffset);
    
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
    CGPoint offset = [self offsetWithVisibleRect:frame targetRect:toFrame keyboardPoint:keyboardPoint direction:keyboardDirection horizon:keyboardHorizon];
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
    if (@available(iOS 11.0, *)) {
        //11以上用的是adjustedContentInset，但我们无法直接设置adjustedContentInset，只能通过设置contentInset来间接修改adjustedContentInset。
        //contentInset和adjustedContentInset的差值可能是safeArea或0，计算规则比较复杂，甚至于ScrollView是否可滚动都有关系，所以利用现有的差值计算。
        UIEdgeInsets adjOffset = UIEdgeInsetsSubInsets(self.adjustedContentInset, self.contentInset);
        contentV.edgeInsetsValue = UIEdgeInsetsSubInsets(contentV.edgeInsetsValue, adjOffset);
    }
    {
        UIEdgeInsets inset = self.contentInset;
        inset = UIEdgeInsetsSubInsets(inset, p.insetsOffset);
        //修改 contentInset 会丢失精度，所以要先修改，然后以丢失精度后的结果来计算差值
        self.contentInset = contentV.edgeInsetsValue;
        p.insetsOffset = UIEdgeInsetsSubInsets(self.contentInset, inset);
    }
//    NSLog(@"-> inset: %@, offset: %@", NSStringFromUIEdgeInsets(contentV.edgeInsetsValue), NSStringFromCGPoint(contentOffset));
    [self setContentOffset:contentOffset animated:NO];
}

//通过当前可见区域(VisibleRect)与想要看到的目标区域(targetRect)，还有键盘的坐标（keyboardPoint）、方向（direction）、水平线（horizon）来计算需要进行的偏移
- (CGPoint)offsetWithVisibleRect:(CGRect)rect targetRect:(CGRect)target keyboardPoint:(CGPoint)keyboardPoint direction:(CGPoint)direction horizon:(CGPoint)horizon {
    //记录一下开始位置，然后把target处理到合适位置，最后返回差值
    CGPoint origin = target.origin;  //
    //键盘的水平方向，两边都一样，所以按x>=0处理简单一点。
    if (horizon.x < 0) {
        horizon.x = - horizon.x;
        horizon.y = - horizon.y;
    }
    if (horizon.y > horizon.x || -horizon.y > horizon.x) {
        //键盘方向左右
        //先处理上下边界
        if (target.origin.y > rect.origin.y + rect.size.height - target.size.height) {
            target.origin.y = rect.origin.y + rect.size.height - target.size.height;
        }
        if (target.origin.y < rect.origin.y) {
            target.origin.y = rect.origin.y;
        }
        //再处理左右边界
        CGFloat slope = horizon.x / horizon.y;//- direction.y / direction.x;
        CGFloat topX = (target.origin.y - keyboardPoint.y) * slope + keyboardPoint.x;
        CGFloat bottomX = topX + target.size.height * slope;
        if (direction.x < 0) {
            //左
            CGFloat x = MIN(topX, bottomX);
            x = MIN(x, rect.origin.x + rect.size.width);
            if (target.origin.x > x - target.size.width) {
                target.origin.x = x - target.size.width;
            }
            //整体宽度不够的时候，还可以继续试试上下移动一下。还可以把有效的size回调出去由使用方决定对齐方式，但是这样一种种情况的判断下去太麻烦了，暂不处理，等有空从头梳理简化一下。
//            if (target.origin.x < rect.origin.x) {
//                if (horizon.x == 0) {
//                    target.origin.x = rect.origin.x;
//                } else {
//                    CGFloat yOffset = (rect.origin.x - target.origin.x) / slope;
//                    if (yOffset >)
//                }
//            }
            if (target.origin.x < rect.origin.x) {
                target.origin.x = rect.origin.x;
            }
        } else {
            //右
            CGFloat x = MAX(topX, bottomX);
            x = MAX(x, rect.origin.x);
            if (target.origin.x < x) {
                target.origin.x = x;
            }
        }
    } else {
        //键盘方向上下
        //先处理左右边界
        if (target.origin.x > rect.origin.x + rect.size.width - target.size.width) {
            target.origin.x = rect.origin.x + rect.size.width - target.size.width;
        }
        if (target.origin.x < rect.origin.x) {
            target.origin.x = rect.origin.x;
        }
        //再处理上下边界
        //斜率
        CGFloat slope = horizon.y / horizon.x;//- direction.x / direction.y;
        CGFloat leftY = (target.origin.x - keyboardPoint.x) * slope + keyboardPoint.y;
        CGFloat rightY = leftY + target.size.width * slope;
        if (direction.y < 0) {
            //上
            CGFloat y = MIN(leftY, rightY);
            y = MIN(y, rect.origin.y + rect.size.height);
            if (target.origin.y > y - target.size.height) {
                target.origin.y = y - target.size.height;
            }
            if (target.origin.y < rect.origin.y) {
                target.origin.y = rect.origin.y;
            }
        } else {
            //下
            CGFloat y = MAX(leftY, rightY);
            y = MAX(y, rect.origin.y);
            if (target.origin.y < y) {
                target.origin.y = y;
            }
        }
    }
    return CGPointMake(origin.x - target.origin.x, origin.y - target.origin.y);
}

@end
