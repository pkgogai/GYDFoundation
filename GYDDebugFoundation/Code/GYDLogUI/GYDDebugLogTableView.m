//
//  GYDDebugLogTableView.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/24.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDDebugLogTableView.h"

@interface UIScrollView ()

- (void)_scrollViewWillBeginDragging;

- (void)_notifyDidScroll;

- (void)_scrollViewDidEndDraggingForDelegateWithDeceleration:(BOOL)decelerate;

- (void)_scrollViewDidEndDeceleratingForDelegate;

@end

@implementation GYDDebugLogTableView
{
    BOOL _scrollViewIsScrollByFinger;
    BOOL _isLockToBottom;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        _isLockToBottom = YES;
        _scrollViewIsScrollByFinger = NO;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.allowsMultipleSelection = NO;
        self.exclusiveTouch = YES;
        self.multipleTouchEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.estimatedRowHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

- (void)animateReloadData {
    CGPoint offset = self.contentOffset;
    [self reloadData];
    
    //offset<0时，reloadData会把offset归0，所以先恢复一下原来的位置
    if (self.contentOffset.y != offset.y) {
        [self setContentOffset:offset animated:NO];
    }
    
    //手指按着的话，保持当前位置就好，不用处理滚动了
    if (_scrollViewIsScrollByFinger) {
        return;
    }
    
    if (_isLockToBottom) {
        offset.y = self.contentSize.height + self.contentInset.bottom - self.frame.size.height;
    }
    if (offset.y < -self.contentInset.top) {
        offset.y = -self.contentInset.top;
    }
    
    if (self.contentOffset.y != offset.y) {
        [self setContentOffset:offset animated:YES];
    }
}

#pragma mark - UITableViewDelegate

- (void)_scrollViewWillBeginDragging {
    _scrollViewIsScrollByFinger = YES;
    [super _scrollViewWillBeginDragging];
}

- (void)_notifyDidScroll {
    [super _notifyDidScroll];
    if (!_scrollViewIsScrollByFinger) {
        return;
    }
    CGFloat offsetBottom = self.contentSize.height + self.contentInset.bottom - self.contentOffset.y - self.frame.size.height;
    _isLockToBottom = (offsetBottom <= 10);
}

- (void)_scrollViewDidEndDraggingForDelegateWithDeceleration:(BOOL)decelerate {
    if (!decelerate) {
        _scrollViewIsScrollByFinger = NO;
    }
    [super _scrollViewDidEndDraggingForDelegateWithDeceleration:decelerate];
}

- (void)_scrollViewDidEndDeceleratingForDelegate {
    _scrollViewIsScrollByFinger = NO;
    [super _scrollViewDidEndDeceleratingForDelegate];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
