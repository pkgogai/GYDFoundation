//
//  GYDDebugRootView.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/24.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDDebugRootView.h"
#import "UIView+GYDSafeArea.h"

const CGFloat GYDLogViewMinWidth = 45;

@implementation GYDDebugRootView
{
    BOOL _isFullScreen;
    UIView *_boundsView;
    CGFloat _maxHeight; //  除去键盘之后，控制条可以使用的最大高度
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (_isFullScreen) {
        for (UIView *view in _boundsView.subviews) {
            if (view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
                return YES;
            }
        }
        return NO;
    } else {
        point = [self convertPoint:point toView:_boundsView];
        return [_boundsView pointInside:point withEvent:event];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameAction:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        _maxHeight = [UIScreen mainScreen].bounds.size.height;
        _isFullScreen = YES;
        
        _boundsView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.clipsToBounds = YES;
            view;
        });
        [self addSubview:_boundsView];
        
        _controlView = ({
            GYDDebugControlView *controlView = [[GYDDebugControlView alloc] initWithFrame:CGRectMake(0, 100, 0, 0)];
            controlView.backgroundColor = [UIColor greenColor];
            controlView;
        });
        [_boundsView addSubview:_controlView];
        
        UIButton *button = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor redColor];
            button.frame = CGRectMake(0, 0, GYDLogViewMinWidth, GYDLogViewMinWidth);
            button.titleLabel.font = [UIFont systemFontOfSize:9];
            button.titleLabel.textColor = [UIColor whiteColor];
            button.titleLabel.numberOfLines = 3;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitle:@"↑\n← + →\n↓" forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(clickedFullScreenButton:) forControlEvents:UIControlEventTouchUpInside];
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
            [button addGestureRecognizer:pan];
            button;
        });
        [_controlView addControlItemView:button location:GYDDebugControlViewLocationHead];
        
        
    }
    return self;
}

- (void)setContentView:(UIView *)contentView {
    if (_contentView) {
        [_contentView removeFromSuperview];
    }
    _contentView = contentView;
    [_boundsView addSubview:_contentView];
    if (_controlView) {
        [_boundsView bringSubviewToFront:_controlView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIEdgeInsets safeArea = self.gyd_safeAreaInsets;

    CGRect bounds = self.bounds;
    if (safeArea.bottom < bounds.size.height - _maxHeight) {
        safeArea.bottom = bounds.size.height - _maxHeight;
    }
    _contentView.frame = bounds;
    
    if (_isFullScreen) {
        _boundsView.frame = bounds;
        
        CGFloat controlViewY = _controlView.frame.origin.y;
        if (controlViewY > bounds.size.height - safeArea.bottom - GYDLogViewMinWidth) {
            controlViewY = bounds.size.height - safeArea.bottom - GYDLogViewMinWidth;
        }
        if (controlViewY < safeArea.top) {
            controlViewY = safeArea.top;
        }
        _controlView.frame = CGRectMake(0, controlViewY, bounds.size.width, GYDLogViewMinWidth);
    } else {
        _controlView.frame = CGRectMake(0, 0, bounds.size.width, GYDLogViewMinWidth);
        
        CGRect boundsViewFrame = _boundsView.frame;
        boundsViewFrame.size.width = GYDLogViewMinWidth;
        boundsViewFrame.size.height = GYDLogViewMinWidth;
        
        if (boundsViewFrame.origin.y > bounds.size.height - safeArea.bottom - boundsViewFrame.size.height) {
            boundsViewFrame.origin.y = bounds.size.height - safeArea.bottom - boundsViewFrame.size.height;
        }
        if (boundsViewFrame.origin.y < safeArea.top) {
            boundsViewFrame.origin.y = safeArea.top;
        }
        if (boundsViewFrame.origin.x > bounds.size.width - safeArea.right - boundsViewFrame.size.width) {
            boundsViewFrame.origin.x = bounds.size.width - safeArea.right - boundsViewFrame.size.width;
        }
        if (boundsViewFrame.origin.x < safeArea.left) {
            boundsViewFrame.origin.x = safeArea.left;
        }
        
        _boundsView.frame = boundsViewFrame;
    }
}

- (void)changeFullScreen:(BOOL)fullScreen {
    if (_isFullScreen == fullScreen) {
        return;
    }
    _isFullScreen = fullScreen;
    CGRect bounds = self.bounds;
    [UIView animateWithDuration:0.2 animations:^{
        if (fullScreen) {
            CGRect frame = _controlView.frame;
            frame.origin.y = _boundsView.frame.origin.y;
            _controlView.frame = frame;
        } else {
            CGRect frame = _boundsView.frame;
            frame.origin.y = _controlView.frame.origin.y;
            _boundsView.frame = frame;
        }
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }];
}

- (void)keyboardWillChangeFrameAction:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect frame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double d = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (frame.origin.y > 0 && frame.origin.y < [UIScreen mainScreen].bounds.size.height) {
        _maxHeight = frame.origin.y;
    } else {
        _maxHeight = [UIScreen mainScreen].bounds.size.height;
    }
    [UIView animateWithDuration:d animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }];
}

// 全屏按钮点击
- (void)clickedFullScreenButton:(UIButton *)btn {
    [self changeFullScreen:!_isFullScreen];
}

// 全屏按钮滑动，界限之类在layoutSubviews中处理
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan {
    CGPoint p = [pan translationInView:self];
    if (_isFullScreen) {
        CGRect frame = _controlView.frame;
        frame.origin.y += p.y;
        _controlView.frame = frame;
    } else {
        CGRect frame = _boundsView.frame;
        frame.origin.x += p.x;
        frame.origin.y += p.y;
        _boundsView.frame = frame;
    }
    [pan setTranslation:CGPointMake(0, 0) inView:self];
    [self setNeedsLayout];
}

@end
