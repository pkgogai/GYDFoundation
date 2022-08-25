//
//  GYDDebugLogWindowControl.m
//  GYDDebugFoundation
//
//  Created by gongyadong on 2022/4/21.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDDebugLogWindowControl.h"
#import "GYDDebugRootView.h"
#import "UIButton+GYDButton.h"

#import "GYDLogListView.h"

#import "GYDDebugAppInterface.h"

@implementation GYDDebugLogWindowControl

static GYDDebugWindow *_Window = nil;

+ (UIWindow *)window {
    return _Window;
}

+ (void)setShow:(BOOL)show {
    if (show) {
        if (!_Window) {
            _Window = [[GYDDebugWindow alloc] initWithRootView:[self rootView]];
            _Window.hidden = NO;
        }
    } else {
        if (_Window) {
            _Window.hidden = YES;
            _Window = nil;
        }
    }
}

+ (BOOL)isShow {
    return _Window != nil;
}

+ (UIView *)rootView {
    
    GYDDebugRootView *view = [[GYDDebugRootView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    GYDLogListView *listView = [[GYDLogListView alloc] initWithFrame:CGRectZero];
    listView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    view.contentView = listView;
    
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
            self.show = NO;
        }];
    }
    NSMutableArray<UIView *> *viewArray = [NSMutableArray array];
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, GYDLogViewMinWidth * 2, GYDLogViewMinWidth);
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.titleLabel.textColor = [UIColor whiteColor];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:@"操作日志" forState:UIControlStateNormal];
        [button setTitle:@"操作日志☑" forState:UIControlStateSelected];
        
        button.backgroundColor = [UIColor blueColor];
        button.tag = GYDDebugControlViewLogTouchTag;
        [viewArray addObject:button];
        
        [button gyd_setClickActionBlock:^(UIButton * _Nonnull button) {
            button.selected = !button.selected;
            listView.userInteractionEnabled = button.selected;
            listView.isLogInterfaceEnable = button.selected;
            if (button.selected) {
                listView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
            } else {
                listView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            }
        }];
        listView.userInteractionEnabled = button.selected;
        listView.isLogInterfaceEnable = button.selected;
        if (button.selected) {
            listView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        } else {
            listView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        }
    }
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, GYDLogViewMinWidth * 1, GYDLogViewMinWidth);
        button.titleLabel.font = [UIFont systemFontOfSize:24];
        button.titleLabel.textColor = [UIColor whiteColor];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:@"折" forState:UIControlStateNormal];
        [button setTitle:@"展" forState:UIControlStateSelected];
        button.backgroundColor = [UIColor redColor];
        button.tag = GYDDebugControlViewLogFoldTag;
        [viewArray addObject:button];
        
        [button gyd_setClickActionBlock:^(UIButton * _Nonnull button) {
            button.selected = !button.selected;
            listView.isFolded = button.selected;
        }];
    }
    
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, GYDLogViewMinWidth, GYDLogViewMinWidth);
        button.titleLabel.font = [UIFont systemFontOfSize:24];
        button.titleLabel.textColor = [UIColor whiteColor];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:@"清" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor blueColor];
        button.tag = GYDDebugControlViewLogClearTag;
        [viewArray addObject:button];
        
        [button gyd_setClickActionBlock:^(UIButton * _Nonnull button) {
            [listView clearData];
        }];
    }
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, GYDLogViewMinWidth, GYDLogViewMinWidth);
        button.titleLabel.font = [UIFont systemFontOfSize:24];
        button.titleLabel.textColor = [UIColor whiteColor];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:@"线" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor redColor];
        button.tag = GYDDebugControlViewLogLineTag;
        [viewArray addObject:button];
        
        [button gyd_setClickActionBlock:^(UIButton * _Nonnull button) {
            [listView addLine];
        }];
    }
    
    NSArray *array = [GYDDebugAppInterface.delegate logRootView:view willAddControlViewArray:viewArray] ?: viewArray;
    for (UIView *view in array) {
        [controlView addControlItemView:view location:GYDDebugControlViewLocationNormal];
    }
    
    return view;
}


@end
