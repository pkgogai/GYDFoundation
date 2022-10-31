//
//  GYDLogControlView.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/24.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDDebugControlView.h"

@implementation GYDDebugControlView
{
    UIScrollView *_scrollView;
    NSMutableArray<UIView *> *_headItemArray;
    NSMutableArray<UIView *> *_scrollItemArray;
    NSMutableArray<UIView *> *_tailItemArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _headItemArray = [NSMutableArray array];
        _scrollItemArray = [NSMutableArray array];
        _tailItemArray = [NSMutableArray array];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.backgroundColor = [UIColor clearColor];
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            [self addSubview:scrollView];
            scrollView;
        });
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    CGFloat tmpX = 0;
    for (UIView *view in _headItemArray) {
        if (view.hidden) {
            continue;
        }
        CGRect frame = view.frame;
        frame.origin.x = tmpX;
        frame.origin.y = 0;
        view.frame = frame;
        tmpX += frame.size.width;
    }
    
    CGFloat tmpRightX = size.width;
    for (UIView *view in _tailItemArray) {
        if (view.hidden) {
            continue;
        }
        CGRect frame = view.frame;
        frame.origin.x = tmpRightX - frame.size.width;
        frame.origin.y = 0;
        view.frame = frame;
        tmpRightX = frame.origin.x;
    }
    
    _scrollView.frame = CGRectMake(tmpX, 0, tmpRightX > tmpX ? (tmpRightX - tmpX) : 0, size.height);
    
    tmpX = 0;
    for (UIView *view in _scrollItemArray) {
        if (view.hidden) {
            continue;
        }
        CGRect frame = view.frame;
        frame.origin.x = tmpX;
        frame.origin.y = 0;
        view.frame = frame;
        tmpX += frame.size.width;
    }
    _scrollView.contentSize = CGSizeMake(tmpX, size.height);
}

- (void)addControlItemView:(UIView *)view location:(GYDDebugControlViewLocation)location {
    if ([_headItemArray containsObject:view]) {
        [_headItemArray removeObject:view];
        [view removeFromSuperview];
    } else if ([_tailItemArray containsObject:view]) {
        [_tailItemArray removeObject:view];
        [view removeFromSuperview];
    } else if ([_scrollItemArray containsObject:view]) {
        [_scrollItemArray removeObject:view];
        [view removeFromSuperview];
    }
    
    if (location == GYDDebugControlViewLocationHead) {
        [_headItemArray addObject:view];
        [self addSubview:view];
    } else if (location == GYDDebugControlViewLocationTail) {
        [_tailItemArray addObject:view];
        [self addSubview:view];
    } else {
        [_scrollItemArray addObject:view];
        [_scrollView addSubview:view];
    }
    [self setNeedsLayout];
}

- (void)removeView:(UIView *)view {
    [_headItemArray removeObject:view];
    [_tailItemArray removeObject:view];
    [_scrollItemArray removeObject:view];
    [view removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
