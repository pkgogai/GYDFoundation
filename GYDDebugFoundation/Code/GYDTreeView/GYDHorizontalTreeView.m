//
//  GYDHorizontalTreeView.m
//  GYDDevelopment
//
//  Created by gongyadong on 2021/3/31.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDHorizontalTreeView.h"
#import "UIView+GYDFrame.h"

@implementation GYDHorizontalTreeView
{
    NSMutableSet<UIView *> *_subviewSet;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _lineColor = [UIColor grayColor];
    }
    return self;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setRootItem:(GYDHorizontalTreeViewItem *)rootItem {
    _rootItem = rootItem;
    
    NSMutableSet<UIView *> *newSet = [NSMutableSet set];
    
    NSMutableArray *enumItems = [NSMutableArray arrayWithObject:rootItem];
    while (enumItems.count > 0) {
        GYDHorizontalTreeViewItem *item = enumItems[0];
        [enumItems removeObjectAtIndex:0];
        if (item.children.count > 0) {
            [enumItems addObjectsFromArray:item.children];
        }
        [self addSubview:item.view];
        [newSet addObject:item.view];
        [_subviewSet removeObject:item.view];
    }
    if (_subviewSet) {
        for (UIView *view in _subviewSet) {
            if (view.superview == self) {
                [view removeFromSuperview];
            }
        }
    }
    _subviewSet = newSet;
}

- (void)layoutAndChangeSize {
    CGFloat maxX = 0;
    CGFloat maxY = 0;
    [self recursionLayoutItem:_rootItem x:10 maxX:&maxX maxY:&maxY];
    self.gyd_size = CGSizeMake(maxX, maxY);
    [self setNeedsDisplay];
}

/**
 从根节点开始，递归布局所有节点，并记录布局到的最大尺寸。
 */
- (void)recursionLayoutItem:(GYDHorizontalTreeViewItem *)item x:(CGFloat )x maxX:(CGFloat *)maxX maxY:(CGFloat *)maxY {
    UIView *view = item.view;
    view.gyd_x = x;
    if (*maxX < view.gyd_rightX) {
        *maxX = view.gyd_rightX;
    }
    CGFloat beginY = *maxY;
    
    NSArray<GYDHorizontalTreeViewItem *> *children = item.children;
    if (children.count < 1) {
        view.gyd_y = beginY + 5;
        *maxY = view.gyd_bottomY + 5;
        return;
    }
    
    CGFloat chirdX = view.gyd_rightX + 20;
    for (GYDHorizontalTreeViewItem *i in item.children) {
        [self recursionLayoutItem:i x:chirdX maxX:maxX maxY:maxY];
    }
    GYDHorizontalTreeViewItem *first = children.firstObject;
    GYDHorizontalTreeViewItem *last = children.lastObject;
    
    CGFloat top = first.view.gyd_centerY;
    CGFloat bottom = last.view.gyd_centerY;
    view.gyd_centerY = (bottom + top) / 2;
    if (view.gyd_centerY < beginY + 5) {
        view.gyd_centerY = beginY + 5;
    }
    if (*maxY < view.gyd_bottomY + 5) {
        *maxY = view.gyd_bottomY + 5;
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.lineColor setStroke];
    [[UIColor clearColor] setFill];
    CGContextSetLineWidth(context, 1);
    [self recursionDrawItem:self.rootItem inContext:context];
}


- (void)recursionDrawItem:(GYDHorizontalTreeViewItem *)item inContext:(CGContextRef)context {
    NSArray<GYDHorizontalTreeViewItem *> *children = item.children;
    if (children.count < 1) {
        return;
    }
    GYDHorizontalTreeViewItem *first = [children firstObject];
    GYDHorizontalTreeViewItem *last = [children lastObject];
    
    CGFloat top = first.view.center.y - 5;
    CGFloat bottom = last.view.center.y + 5;
    CGFloat middle = (top + bottom) / 2;
    
    CGFloat x = CGRectGetMaxX(item.view.frame) + 10;
    CGFloat r = 5;
    // 形状
    if (bottom - top < r * 4) {
        CGContextMoveToPoint(context, x - r, middle);
        // -
        CGContextAddLineToPoint(context, x + r, middle);
    } else {
        CGContextMoveToPoint(context, x + r, top);
        //  _
        // (
        CGContextAddArc(context, x + r, top + r, r, -M_PI_2, M_PI, 1);
        // |位置的移动本身就是直线相连的，所以这里2条数线都可以省略
        CGContextAddLineToPoint(context, x, middle - r);
        // ）
        //-
        CGContextAddArc(context, x - r, middle - r, r, 0, M_PI_2, 0);
        //-
        // )
        CGContextAddArc(context, x - r, middle + r, r, -M_PI_2, 0, 0);
        // |
        CGContextAddLineToPoint(context, x, bottom - r);
        // (
        //  -
        CGContextAddArc(context, x + r, bottom - r, r, M_PI, M_PI_2, 1);
    }
    CGContextDrawPath(context, kCGPathStroke);
    
    for (GYDHorizontalTreeViewItem *i in children) {
        [self recursionDrawItem:i inContext:context];
    }
}


@end
