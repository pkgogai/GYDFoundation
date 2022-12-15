//
//  GYDDebugViewHierarchyWindowControl.m
//  GYDFoundation
//
//  Created by gongyadong on 2022/6/23.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDDebugViewHierarchyWindowControl.h"
#import "GYDDebugWindow.h"
#import "GYDDebugRootView.h"
#import "GYDDebugControlView.h"
#import "UIButton+GYDButton.h"
#import "UIGestureRecognizer+GYDBlock.h"
#import "UIView+GYDCustomFunction.h"
#import "NSObject+GYDCustomFunction.h"
#import "GYDDebugViewHierarchyRootView.h"
#import "UIImage+GYDImage.h"

#import "GYDDebugAppInterface.h"

@implementation GYDDebugViewHierarchyWindowControl

static GYDDebugWindow *_Window = nil;

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

static NSSet<NSString *> *containerClassNames = nil;
+ (void)setSystemContainerViewClassNames:(NSSet<NSString *> *)systemContainerViewClassNames {
    containerClassNames = [systemContainerViewClassNames copy];
}
+ (NSSet<NSString *> *)systemContainerViewClassNames {
    if (!containerClassNames) {
        containerClassNames = [NSSet setWithArray:@[
            @"UIDropShadowView",
            @"UITransitionView",
            @"UINavigationTransitionView",
            @"UIViewControllerWrapperView",
            @"UITableViewCellContentView",
            @"UIPickerTableViewWrapperCell",
            @"UIPickerColumnView",
            @"UIPickerTableView",
            @"_UINavigationBarContentView",
            @"_UITAMICAdaptorView",
            @"_UIButtonBarStackView",
        ]];
    }
    return containerClassNames;
}

static NSSet<NSString *> *tailClassNames = nil;
+ (void)setSystemTailViewClassNames:(NSSet<NSString *> *)systemTailViewClassNames {
    tailClassNames = [systemTailViewClassNames copy];
}
+ (NSSet<NSString *> *)systemTailViewClassNames {
    if (!tailClassNames) {
        tailClassNames = [NSSet setWithArray:@[
            //tabbar
            @"UIVisualEffectView",
            @"_UIVisualEffectContentView",
            @"UITabBarButtonLabel",
            @"UITabBarSwappableImageView",
            @"_UIBarBackground",
            @"_UIBarBackgroundShadowView",
            @"_UIBarBackgroundShadowContentImageView",
            @"UITextSelectionView",
            @"_UIVisualEffectBackdropView",
            @"_UIScrollViewScrollIndicator",
            @"_UITextLayoutCanvasView",
            @"_UITextLayoutFragmentView",
            @"_UIVisualEffectContentView",
            @"_UIVisualEffectBackdropView",
            @"_UIBarBackground",
            @"_UIBarBackgroundShadowView",
            @"_UIBarBackgroundShadowContentImageView",
            @"UITextViewSelectionView",
            @"_UITextViewCanvasView",
            @"_UITextContainerView",
            @"_UITextLayoutView",
            @"UITextEffectsWindow",
            @"UIRemoteKeyboardWindow"
        ]];
    }
    return tailClassNames;
}



+ (UIView *)rootView {
    GYDDebugRootView *view = [[GYDDebugRootView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    GYDDebugViewHierarchyRootView *contentView = [[GYDDebugViewHierarchyRootView alloc] initWithFrame:CGRectZero];
    [contentView reloadViewHierarchyWithAllWindows];
    contentView.backgroundColor = [UIColor whiteColor];
    
    view.contentView = contentView;
    
    GYDDebugControlView *controlView = view.controlView;
    __weak GYDDebugRootView *weakRootView = view;
    //注意单向引用关系：controlView>button>contentView
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
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, GYDLogViewMinWidth)];
        view.tag = GYDViewHierarchyControlViewSpaceTag;
        [viewArray addObject:view];
    }
    
    {
        UIButton *detailButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, GYDLogViewMinWidth, GYDLogViewMinWidth);
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.titleLabel.textColor = [UIColor whiteColor];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.numberOfLines = 0;
            [button setTitle:@"📖\n详情" forState:UIControlStateNormal];
            [button setTitle:@"📖\n详情" forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage gyd_imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage gyd_imageWithColor:[UIColor blueColor]] forState:UIControlStateSelected];
            button;
        });
        UIButton *moveAndSelectButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, GYDLogViewMinWidth, GYDLogViewMinWidth);
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.titleLabel.textColor = [UIColor whiteColor];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.numberOfLines = 0;
            [button setTitle:@"🤚\n拖动" forState:UIControlStateNormal];
            [button setTitle:@"⊹\n选择" forState:UIControlStateSelected];
            button.backgroundColor = [UIColor blueColor];
            button;
        });
        moveAndSelectButton.hidden = YES;
        
        //注意单向引用关系：detailButton>moveAndSelectButton
        [detailButton gyd_setClickActionBlock:^(UIButton * _Nonnull button) {
            button.selected = !button.selected;
            contentView.showListView = button.selected;
            moveAndSelectButton.selected = YES;
            moveAndSelectButton.hidden = !contentView.showListView;
            [weakRootView.controlView setNeedsLayout];
            
            contentView.showSelectView = moveAndSelectButton.hidden ? NO : moveAndSelectButton.selected;
        }];
        [moveAndSelectButton gyd_setClickActionBlock:^(UIButton * _Nonnull button) {
            button.selected = !button.selected;
            contentView.showSelectView = button.selected;
        }];
        detailButton.tag = GYDViewHierarchyControlViewListTag;
        [viewArray addObject:detailButton];
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, GYDLogViewMinWidth)];
            view.tag = GYDViewHierarchyControlViewSpaceTag;
            [viewArray addObject:view];
        }
        moveAndSelectButton.tag = GYDViewHierarchyControlViewMoveSelectChangeTag;
        [viewArray addObject:moveAndSelectButton];
        
    }
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, GYDLogViewMinWidth)];
        view.tag = GYDViewHierarchyControlViewSpaceTag;
        [viewArray addObject:view];
    }
    
    {
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, GYDLogViewMinWidth * 1.2, GYDLogViewMinWidth);
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.titleLabel.textColor = [UIColor whiteColor];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitle:@"system" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage gyd_imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage gyd_imageWithColor:[UIColor blueColor]] forState:UIControlStateSelected];
            button.tag = GYDViewHierarchyControlViewSystemTag;
            [viewArray addObject:button];

            [button gyd_setClickActionBlock:^(UIButton * _Nonnull button) {
                button.selected = !button.selected;
                contentView.showIgnoreView = button.selected;
                [weakRootView.controlView gyd_callFunction:@"updateLevelValue" withArg:nil];
            }];
        }
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, GYDLogViewMinWidth)];
            view.tag = GYDViewHierarchyControlViewSpaceTag;
            [viewArray addObject:view];
        }
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, GYDLogViewMinWidth * 1.2, GYDLogViewMinWidth);
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.titleLabel.textColor = [UIColor whiteColor];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.numberOfLines = 0;
            [button setTitle:@"hidden\nalpha=0" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage gyd_imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage gyd_imageWithColor:[UIColor blueColor]] forState:UIControlStateSelected];
            button.tag = GYDViewHierarchyControlViewHiddenTag;
            [viewArray addObject:button];

            [button gyd_setClickActionBlock:^(UIButton * _Nonnull button) {
                button.selected = !button.selected;
                contentView.showHiddenView = button.selected;
                [weakRootView.controlView gyd_callFunction:@"updateLevelValue" withArg:nil];
            }];
        }
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, GYDLogViewMinWidth)];
            view.tag = GYDViewHierarchyControlViewSpaceTag;
            [viewArray addObject:view];
        }
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GYDLogViewMinWidth * 1.5, GYDLogViewMinWidth)];
            label.userInteractionEnabled = YES;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor whiteColor];
            label.numberOfLines = 0;
            label.backgroundColor = [UIColor blueColor];
            label.adjustsFontSizeToFitWidth = YES;
            label.tag = GYDViewHierarchyControlViewLevelTag;
            [viewArray addObject:label];
            [controlView gyd_setFunction:@"updateLevelValue" withAction:^id _Nullable(UILabel * _Nonnull obj, id  _Nullable arg) {
                label.text = [NSString stringWithFormat:@"显示图层\n↕%zd - %zd↕", contentView.displayView.bottomLevel, contentView.displayView.topLevel];
                return nil;
            }];
            [controlView gyd_callFunction:@"updateLevelValue" withArg:nil];
            __weak UILabel *weakLabel = label;
            __block BOOL panRight = NO;
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithActionBlock_gyd:^(UIGestureRecognizer * _Nonnull gr) {
                __strong UILabel *strongLabel = weakLabel;
                if (!strongLabel) {
                    return;
                }
                
                UIPanGestureRecognizer *p = (UIPanGestureRecognizer *)gr;
                if (p.state == UIGestureRecognizerStateBegan) {
                    CGPoint local = [p locationInView:strongLabel];
                    panRight = local.x > strongLabel.bounds.size.width / 2;
                }
                CGFloat step = 20.0;
                CGPoint offset = [p translationInView:p.view];
                if (offset.y > -step && offset.y < step) {
                    return;
                }
                NSInteger c = offset.y / step;
                NSInteger oldValue = panRight ? contentView.displayView.topLevel : contentView.displayView.bottomLevel;
                NSInteger newValue = oldValue + c;
                
                if (newValue < 1) {
                    newValue = 1;
                } else if (newValue > contentView.displayView.maxLevel) {
                    newValue = contentView.displayView.maxLevel;
                }
                c = newValue - oldValue;
                offset.y -= c * step;
                [p setTranslation:offset inView:p.view];
                if (panRight) {
                    contentView.displayView.topLevel = newValue;
                } else {
                    contentView.displayView.bottomLevel = newValue;
                }
                [contentView.displayView layoutHierarchyItemViews];
                
                [weakRootView.controlView gyd_callFunction:@"updateLevelValue" withArg:nil];
            }];
            [label addGestureRecognizer:pan];
        }
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, GYDLogViewMinWidth)];
            view.tag = GYDViewHierarchyControlViewSpaceTag;
            [viewArray addObject:view];
        }
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, GYDLogViewMinWidth * 1, GYDLogViewMinWidth);
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:24];
            button.titleLabel.textColor = [UIColor whiteColor];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitle:@"类" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage gyd_imageWithColor:[UIColor blueColor]] forState:UIControlStateNormal];
            button.tag = GYDViewHierarchyControlViewDetailTag;
            [viewArray addObject:button];
            __block NSInteger showType = 0; //0类，1全，2无
            [button gyd_setClickActionBlock:^(UIButton * _Nonnull button) {
                if (showType < 2) {
                    showType ++;
                } else {
                    showType = 0;
                }
                if (showType == 0) {
                    [button setTitle:@"类" forState:UIControlStateNormal];
                } else if (showType == 1) {
                    [button setTitle:@"详" forState:UIControlStateNormal];
                } else {
                    [button setTitle:@"无" forState:UIControlStateNormal];
                }
                [contentView.rootItem enumerateChildItemsUsingBlock:^(GYDDebugViewHierarchyItem * _Nonnull item, BOOL * _Nonnull stop) {
                    if (showType == 0) {
                        item.displayConfig.showClass = YES;
                        item.displayConfig.showDesc = NO;
                    } else if (showType == 1) {
                        item.displayConfig.showClass = YES;
                        item.displayConfig.showDesc = YES;
                    } else {
                        item.displayConfig.showClass = NO;
                        item.displayConfig.showDesc = NO;
                    }
                    [item.displayView updateConfig];
                }];
            }];
        }
    }
    NSArray *array = [GYDDebugAppInterface.delegate viewHierarchyRootView:view willAddControlViewArray:viewArray] ?: viewArray;
    
    for (UIView *view in array) {
        [controlView addControlItemView:view location:GYDDebugControlViewLocationNormal];
    }
    
    return view;
}



@end
