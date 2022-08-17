//
//  GYDDebugViewTipsDisplayView.m
//  GYDDevelopment
//
//  Created by gongyadong on 2021/1/4.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDDebugViewTipsDisplayView.h"
#import "GYDDebugViewTipsDisplayViewModel.h"
#import "GYDUIKit.h"
#import "gyd_timekeeper.h"

@interface GYDDebugViewTipsDisplayView ()<UIScrollViewDelegate>

@end
@implementation GYDDebugViewTipsDisplayView
{
    CGFloat _scale; //拉伸比例
    CGPoint _offset;    //拖动位置
    
    NSMutableArray<GYDDebugViewTipsDisplayViewModel *> *_sourceArray;
    GYDWeakDisplayLink *_timer;
//    GYDWeakTimer *_timer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scale = 1;
        _offset = CGPointZero;
        _sourceArray = [NSMutableArray array];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
        [self addGestureRecognizer:pan];
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizer:)];
        [self addGestureRecognizer:pinch];
        self.layer.drawsAsynchronously = YES;
    }
    return self;
}

- (void)addItem:(GYDDebugViewTipsDisplayViewModel *)item {
    if ([_sourceArray containsObject:item]) {
        return;
    }
    [_sourceArray addObject:item];
    [self addSubview:item.tipsView];
    
    item.shape = [[GYDDebugViewTipsShape alloc] init];
    item.shape.colorRGBValue = item.colorRGBValue;
    [self addShape:item.shape];
    
    [self updateLocalRect];
    if (!_timer) {
        _timer = [GYDWeakDisplayLink displayLinkStartWithWeakTarget:self selector:@selector(updateLocalRect)];
    }
}

- (void)removeItem:(GYDDebugViewTipsDisplayViewModel *)item {
    if (![_sourceArray containsObject:item]) {
        return;
    }
    [item.tipsView removeFromSuperview];
    [self removeShape:item.shape];
    [_sourceArray removeObject:item];
}

- (void)removeAll {
    for (GYDDebugViewTipsDisplayViewModel *item in _sourceArray) {
        [item.tipsView removeFromSuperview];
        [self removeShape:item.shape];
    }
    [_sourceArray removeAllObjects];
}

- (void)updateLocalRect {
    
    id<UICoordinateSpace> coordinateSpace = [UIScreen mainScreen].coordinateSpace;
    for (GYDDebugViewTipsDisplayViewModel *item in _sourceArray) {
        UIView *view = item.trackView;
        if (view) {
            item.locationRect = [view convertRect:view.bounds toCoordinateSpace:coordinateSpace];
        }
        item.shape.locationRect = item.locationRect;
    }
    
    [_sourceArray sortUsingComparator:^NSComparisonResult(GYDDebugViewTipsDisplayViewModel * _Nonnull obj1, GYDDebugViewTipsDisplayViewModel * _Nonnull obj2) {
        return CGRectGetMidY(obj1.locationRect) - CGRectGetMidY(obj2.locationRect) ?: CGRectGetMinX(obj1.locationRect) - CGRectGetMinX(obj2.locationRect) ?: CGRectGetMaxX(obj2.locationRect) - CGRectGetMaxX(obj1.locationRect);
    }];
    
    
    //
//    for (NSInteger i = 0; i < _sourceArray.count; i++) {
//        GYDDebugViewTipsDisplayViewModel *item = _sourceArray[i];
//        CGRect local = item.locationRect;
//        [item tipsAnimateToCenter:CGPointMake(local.origin.x + local.size.width / 2, local.origin.y + local.size.height / 2)];
//    }
//    [self layoutItemViews];
//    return;
    
    
    //
    
    UIEdgeInsets safeArea = self.gyd_safeAreaInsets;
    CGSize viewSize = self.bounds.size;
    viewSize.height -= safeArea.top + safeArea.bottom;
    //布局提示位置
    // --- 同一行位置的提示也尝试合成一行试试效果 ---
    NSMutableArray *lines = [NSMutableArray array];
    NSMutableArray *cols = nil;
    CGFloat itemWidth = viewSize.width;
    CGRect lastRect = CGRectZero;
    for (NSInteger i = 0; i < _sourceArray.count; i++) {
        GYDDebugViewTipsDisplayViewModel *item = _sourceArray[i];
        CGSize size = item.tipsView.frame.size;
        CGRect localRect = item.shape.locationRect;
        BOOL newLine = NO;
        if (itemWidth > 0 && itemWidth + size.width + 5 > viewSize.width) {
            newLine = YES;
        } else if (CGRectGetMidY(localRect) > CGRectGetMidY(lastRect) || CGRectGetMidX(localRect) < CGRectGetMidX(lastRect)) {
            newLine = YES;
            
        }
        if (newLine) {
            cols = [NSMutableArray array];
            [lines addObject:cols];
            itemWidth = size.width;
        } else {
            itemWidth += size.width + 5;
        }
        [cols addObject:item];
        lastRect = localRect;
    }
    
    CGFloat layoutHeight = 0;
    for (int i = 0; i < lines.count; i++) {
        NSArray *cols = lines[i];
        CGFloat lineHeight = 0;
        for (int j = 0; j < cols.count; j++) {
            GYDDebugViewTipsDisplayViewModel *item = cols[j];
            if (lineHeight < item.tipsView.frame.size.height) {
                lineHeight = item.tipsView.frame.size.height;
            }
        }
        layoutHeight += lineHeight;
    }
    
    CGFloat space = 0;
    if (layoutHeight < viewSize.height && lines.count > 0) {
        space = (viewSize.height - layoutHeight) / (lines.count + 1);
    }
    if (space < 5) {
        space = 5;
    }

    layoutHeight = safeArea.top + space;

    for (int i = 0; i < lines.count; i++) {
        NSArray *cols = lines[i];
        CGFloat lineHeight = 0;
        CGFloat lineWidth = 0;
        for (int j = 0; j < cols.count; j++) {
            GYDDebugViewTipsDisplayViewModel *item = cols[j];
            lineWidth += item.tipsView.frame.size.width;
            if (lineHeight < item.tipsView.frame.size.height) {
                lineHeight = item.tipsView.frame.size.height;
            }
        }
        CGFloat widthSpace = (viewSize.width - lineWidth) / cols.count;
        CGFloat layoutWidth = widthSpace / 2;
        for (int j = 0; j < cols.count; j++) {
            GYDDebugViewTipsDisplayViewModel *item = cols[j];
            CGSize size = item.tipsView.frame.size;
            [item tipsAnimateToCenter:CGPointMake(layoutWidth + size.width / 2, layoutHeight + size.height / 2)];
            layoutWidth += size.width + widthSpace;
        }
        layoutHeight += lineHeight + space;
    }
    [self layoutItemViews];
}



- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)pan {
    CGPoint offset = [pan translationInView:self];
    _offset.x += offset.x;
    _offset.y += offset.y;
    [pan setTranslation:CGPointZero inView:self];
    [self layoutItemViews];
}

- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)pinch {
    if (pinch.state == UIGestureRecognizerStateBegan) {
        pinch.scale = _scale;
    } else {
        if (pinch.scale < 1) {
            pinch.scale = 1;
        } else if (pinch.scale > 5.0) {
            pinch.scale = 5.0;
        }
        if (_scale == pinch.scale) {
            return;
        }
        CGPoint local = [pinch locationInView:self];
        
        CGPoint p = CGPointMake(_offset.x - local.x, _offset.y - local.y);
        
//        p.x /= _scale;
        p.y /= _scale;
        _scale = pinch.scale;
//        p.x *= _scale;
        p.y *= _scale;
        
        p.x += local.x;
        p.y += local.y;
        
        _offset = p;
        
        //更新视图
        [self layoutItemViews];
    }
}

#pragma mark - 布局
- (void)layoutItemViews {
    
    for (NSUInteger i = 0; i < _sourceArray.count; i++) {
        GYDDebugViewTipsDisplayViewModel *item = _sourceArray[i];
        CGPoint p = item.tipsAnimateCenter;
//        p.x *= _scale;
        p.y *= _scale;
        p.x += _offset.x;
        p.y += _offset.y;
        CGRect frame;
        frame.size = item.tipsView.frame.size;
        frame.origin.x = p.x - frame.size.width / 2;
        frame.origin.y = p.y - frame.size.height / 2;
        item.shape.tipsRect = frame;
        item.tipsView.frame = frame;
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

@end
