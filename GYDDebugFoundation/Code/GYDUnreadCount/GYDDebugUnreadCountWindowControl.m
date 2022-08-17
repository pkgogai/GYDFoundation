//
//  GYDDebugUnreadCountWindowControl.m
//  GYDDevelopment
//
//  Created by gongyadong on 2021/3/30.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDDebugUnreadCountWindowControl.h"
#import "GYDUIKit.h"
#import "GYDDebugWindow.h"
#import "GYDDebugRootView.h"
#import "GYDDebugUnreadCountRootView.h"

@implementation GYDDebugUnreadCountWindowControl

static GYDDebugWindow *_Window = nil;

/** 只能显示1个manager */
+ (void)showWithUnreadCountManager:(GYDUnreadCountManager *)manager {
    if (!_Window) {
        _Window = [[GYDDebugWindow alloc] initWithRootView:[self rootViewWithUnreadCountManager:manager]];
        _Window.hidden = NO;
    }
}

/** 隐藏 */
+ (void)hide {
    if (_Window) {
        _Window.hidden = YES;
        _Window = nil;
    }
}

/** 判断是否已经显示 */
+ (BOOL)isShow {
    return _Window != nil;
}


+ (UIView *)rootViewWithUnreadCountManager:(GYDUnreadCountManager *)manager {
    GYDDebugRootView *view = [[GYDDebugRootView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    GYDDebugUnreadCountRootView *contentView = [[GYDDebugUnreadCountRootView alloc] initWithFrame:CGRectZero];
    [contentView updateWithUnreadCountManager:manager];
    
    view.contentView = contentView;
    
    GYDDebugControlView *controlView = view.controlView;
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, GYDLogViewMinWidth * 1, GYDLogViewMinWidth);
        button.titleLabel.font = [UIFont systemFontOfSize:24];
        button.titleLabel.textColor = [UIColor whiteColor];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:@"×" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor redColor];
        [controlView addControlItemView:button location:GYDDebugControlViewLocationTail];
        
        [button gyd_setClickActionBlock:^(UIButton * _Nonnull button) {
            [self hide];
        }];
    }
    
    return view;
}

@end
