//
//  GYDDebugViewHierarchyDisplayView.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/08/09.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDDebugViewHierarchyDisplayView.h"

@implementation GYDDebugViewHierarchyDisplayView
{
    UIScrollView *_scrollView;
    
    CGPoint _slipOffset;
    CGFloat _scale;     //拉伸
    
    NSInteger _panBaseHierarchyIndex;   //用于拖拽偏移时记录基准层
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scale = 1;
        _slipOffset = CGPointZero;
        
        _scrollView = ({
            UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.bounds];
            sv.minimumZoomScale = 0.5;
            sv.maximumZoomScale = 5;
//            sv.delegate = self;
            if (@available(iOS 11, *)) {
                _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
            if (@available(iOS 13, *)) {
                _scrollView.automaticallyAdjustsScrollIndicatorInsets = NO;
            }
            sv;
        });
        [self addSubview:_scrollView];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
        pan.minimumNumberOfTouches = 2;
        [_scrollView addGestureRecognizer:pan];
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizer:)];
        [_scrollView addGestureRecognizer:pinch];
        
    }
    return self;
}

#pragma mark - 数据源

- (void)reloadRootViewHierarchyItem:(GYDDebugViewHierarchyItem *)root {
    for (UIView *view in _itemViewArray) {
        [view removeFromSuperview];
    }
    __block NSInteger maxLevel = 1;
    NSMutableArray<GYDDebugViewHierarchyItemView *> *allDisplayView = [NSMutableArray array];
    [root enumerateChildItemsUsingBlock:^(GYDDebugViewHierarchyItem * _Nonnull item, BOOL * _Nonnull stop) {
        if (!item.displayConfig.show) {
            return;
        }
        item.displayView.model = item;
        [allDisplayView addObject:item.displayView];
        if (item.hierarchyIndex > maxLevel) {
            maxLevel = item.hierarchyIndex;
        }
//        NSLog(@"%zd,%zd,%@,%@", item.orderNumber, item.hierarchyIndex, item.viewClass, NSStringFromCGRect(item.viewFrame));
    }];
    _maxLevel = maxLevel;
    _bottomLevel = 1;
    _topLevel = maxLevel;
    
    [allDisplayView sortUsingComparator:^NSComparisonResult(GYDDebugViewHierarchyItemView * _Nonnull obj1, GYDDebugViewHierarchyItemView * _Nonnull obj2) {
        return (obj1.model.hierarchyIndex - obj2.model.hierarchyIndex) ?: (obj1.model.orderNumber - obj2.model.orderNumber);
    }];
    
    _itemViewArray = [allDisplayView copy];
    for (UIView *view in _itemViewArray) {
        [_scrollView addSubview:view];
    }
    [self layoutHierarchyItemViews];
}

#pragma mark - UI

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = self.bounds;
}

- (void)changeSlipOffset:(CGPoint)slipOffset {
    if (CGPointEqualToPoint(slipOffset, _slipOffset)) {
        return;
    }
    CGPoint pointInterval = CGPointMake(slipOffset.x - _slipOffset.x, slipOffset.y - _slipOffset.y);
    _slipOffset = slipOffset;
    [self layoutHierarchyItemViews];
    
    CGPoint contentOffset = _scrollView.contentOffset;
    contentOffset.x += pointInterval.x * _scale * _bottomLevel;
    contentOffset.y += pointInterval.y * _scale * _bottomLevel;
    _scrollView.contentOffset = contentOffset;
}

- (void)layoutHierarchyItemViews {
    NSInteger maxHierarchyIndex = 1;
    for (GYDDebugViewHierarchyItemView *view in self.itemViewArray) {
        view.hidden = (view.model.hierarchyIndex < self.bottomLevel) || (view.model.hierarchyIndex > self.topLevel) ||!view.model.displayConfig.show;
//        if (view.hidden) {
//            continue;
//        }
        view.useCompleteImage = (view.model.hierarchyIndex == self.topLevel);
        
        if (maxHierarchyIndex < view.model.hierarchyIndex) {
            maxHierarchyIndex = view.model.hierarchyIndex;
        }
        CGRect frame = view.model.viewFrame;
        frame.origin.x += view.model.hierarchyIndex * _slipOffset.x;
        frame.origin.y += view.model.hierarchyIndex * _slipOffset.y;
        
        frame.origin.x *= _scale;
        frame.origin.y *= _scale;
        frame.size.width *= _scale;
        frame.size.height *= _scale;
        
        view.frame = frame;
    }
    
    
//    CGSize contentSize = [UIScreen mainScreen].bounds.size;
//    contentSize.width += (maxHierarchyIndex * _slipOffset.x);
//    contentSize.height += (maxHierarchyIndex * _slipOffset.y);
//    contentSize.width *= _scale;
//    contentSize.height *= _scale;
//    _scrollView.contentSize = contentSize;
    
    CGSize contentSize = [UIScreen mainScreen].bounds.size;
    contentSize.width *= _scale;
    contentSize.height *= _scale;
    UIEdgeInsets insets = UIEdgeInsetsMake(contentSize.height / 2, contentSize.width / 2, contentSize.height / 2, contentSize.width / 2);
    if (_slipOffset.x > 0) {
        insets.right += maxHierarchyIndex *_slipOffset.x * _scale;
    } else {
        insets.left += - maxHierarchyIndex *_slipOffset.x * _scale;
    }
    if (_slipOffset.y > 0) {
        insets.bottom += maxHierarchyIndex * _slipOffset.y * _scale;
    } else {
        insets.top += -maxHierarchyIndex * _slipOffset.y * _scale;
    }
    _scrollView.contentSize = contentSize;
    _scrollView.contentInset = insets;
}

/** 根据选中区域获取数据 */
- (NSArray<GYDDebugViewHierarchyItem *> *)itemArrayInSelectFrame:(CGRect)frame {
    CGPoint offset = _scrollView.contentOffset;
    frame.origin.x += offset.x;
    frame.origin.y += offset.y;
    NSMutableArray *array = [NSMutableArray array];
    for (GYDDebugViewHierarchyItemView *view in self.itemViewArray) {
        if ((view.model.hierarchyIndex < self.bottomLevel) || (view.model.hierarchyIndex > self.topLevel)) {
            view.isSelected = NO;
            continue;
        }
        //不显示系统或隐藏视图时，这里的数组本身就不包含model
//        if (view.model.isHidden) {
//            continue;
//        }
        if (CGRectIsNull(CGRectIntersection(frame, view.frame))) {
            view.isSelected = NO;
            continue;
        }
        view.isSelected = YES;
        [array insertObject:view.model atIndex:0];
    }
    return array;
}

#pragma mark - slip 手势
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)pan {
    
    CGPoint scrollViewOffset = _scrollView.contentOffset;
    
    //找一下接近的层级来锁定位置，效果可能好看点，先找屏幕内的试试效果
//    if (pan.state == UIGestureRecognizerStateBegan) {
//        _panBaseHierarchyIndex = 0;
//        
//        CGRect frame = self.bounds;
//        frame.origin.x += scrollViewOffset.x;
//        frame.origin.y += scrollViewOffset.y;
//        for (GYDDebugViewHierarchyItemView *view in self.itemViewArray) {
//            if (view.hidden) {
//                continue;
//            }
//            if (CGRectEqualToRect(frame, CGRectUnion(frame, view.frame))) {
//                _panBaseHierarchyIndex = view.model.hierarchyIndex;
//                break;
//            }
//        }
//    }
    CGPoint offset = [pan translationInView:_scrollView];
    CGPoint slipOffset = _slipOffset;
    slipOffset.x += offset.x / 5;
    slipOffset.y += offset.y / 5;
    [pan setTranslation:CGPointZero inView:_scrollView];
    [self changeSlipOffset:slipOffset];
    
    if (_panBaseHierarchyIndex > 1) {
        scrollViewOffset.x += offset.x / 5 * (_panBaseHierarchyIndex - 1);
        scrollViewOffset.y += offset.y / 5 * (_panBaseHierarchyIndex - 1);
        _scrollView.contentOffset = scrollViewOffset;
    }
}

- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)pinch {
    if (pinch.state == UIGestureRecognizerStateBegan) {
        pinch.scale = _scale;
    } else {
        if (pinch.scale < 0.25) {
            pinch.scale = 0.25;
        } else if (pinch.scale > 8.0) {
            pinch.scale = 8.0;
        }
        if (_scale == pinch.scale) {
            return;
        }
        CGPoint local = [pinch locationInView:_scrollView];
        CGPoint p = _scrollView.contentOffset;
        CGPoint offset = CGPointMake(local.x - p.x, local.y - p.y);
//        p.x += _scrollView.frame.size.width / 2;
//        p.y += _scrollView.frame.size.height / 2;
        p = local;
        p.x /= _scale;
        p.y /= _scale;
        _scale = pinch.scale;
        p.x *= _scale;
        p.y *= _scale;
        p.x -= offset.x;// _scrollView.frame.size.width / 2;
        p.y -= offset.y;// _scrollView.frame.size.height / 2;
        [self layoutHierarchyItemViews];
        _scrollView.contentOffset = p;
    }
}

@end
