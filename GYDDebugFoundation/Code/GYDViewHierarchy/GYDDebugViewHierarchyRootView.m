//
//  GYDDebugViewHierarchyRootView.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/08/09.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDDebugViewHierarchyRootView.h"
#import "GYDDebugViewHierarchyWindowControl.h"
#import "GYDUIKit.h"
#import "UIView+GYDDebugInfo.h"
#import "UIView+GYDCustomFunction.h"

#import "GYDDebugWindow.h"
#import "GYDDebugViewHierarchyDisplayView.h"
#import "GYDDebugViewHierarchySelectView.h"
#import "GYDDebugViewHierarchyItemListView.h"
#import "GYDDebugFoundation.h"

@implementation GYDDebugViewHierarchyRootView
{
    GYDDebugViewHierarchyDisplayView *_displayView;
    GYDDebugViewHierarchySelectView *_selectView;
    UIView *_spaceLineView;
    GYDDebugViewHierarchyItemListView *_listView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _displayView = [[GYDDebugViewHierarchyDisplayView alloc] initWithFrame:self.bounds];
        [_displayView changeSlipOffset:CGPointZero];
        [self addSubview:_displayView];
        
        _selectView = [[GYDDebugViewHierarchySelectView alloc] initWithFrame:CGRectZero];
        _selectView.backgroundColor = [UIColor clearColor];
        [_selectView setTarget:self selectAction:@selector(selectViewDidSelect:)];
        [self addSubview:_selectView];
        
        _spaceLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _spaceLineView.backgroundColor = [UIColor yellowColor];
        [self addSubview:_spaceLineView];
        _listView = [[GYDDebugViewHierarchyItemListView alloc] initWithFrame:CGRectZero];
        _listView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_listView];
        
        _selectView.hidden = YES;
        _listView.hidden = YES;
        
        [self gyd_setFunction:@"layoutHierarchyItemViews" withAction:^id _Nullable(GYDDebugViewHierarchyRootView * _Nonnull obj, id  _Nullable arg) {
            [obj->_displayView layoutHierarchyItemViews];
            return nil;
        }];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _spaceLineView.hidden = _listView.hidden;
    if (_listView.hidden) {
        _displayView.frame = self.bounds;
    } else {
        CGRect frame = self.bounds;
        frame.origin.y = (NSInteger)(frame.size.height * 0.6);
        frame.size.height -= frame.origin.y;
        _listView.frame = frame;
        
        _spaceLineView.frame = CGRectMake(0, frame.origin.y - 2, frame.size.width, 2);
        
        frame.size.height = frame.origin.y - 2;
        frame.origin.y = 0;
        _displayView.frame = frame;
    }
    _selectView.frame = _displayView.frame;
}

- (void)setShowIgnoreView:(BOOL)showIgnoreView {
    _showIgnoreView = showIgnoreView;
    [self resetViewHierarchy];
}

- (void)setShowHiddenView:(BOOL)showHiddenView {
    _showHiddenView = showHiddenView;
    [self resetViewHierarchy];
}

- (void)setShowSelectView:(BOOL)showSelectView {
    _selectView.hidden = !showSelectView;
    [self setNeedsLayout];
}
- (BOOL)showSelectView {
    return !_selectView.hidden;
}

- (void)setShowListView:(BOOL)showListView {
    _listView.hidden = !showListView;
    if (_listView.hidden) {
        [_displayView itemArrayInSelectFrame:CGRectNull];
        _listView.list = nil;
    }
    [self setNeedsLayout];
}
- (BOOL)showListView {
    return !_listView.hidden;
}

- (void)reloadViewHierarchyWithAllWindows {
    NSMutableArray *windows = [[UIApplication sharedApplication].windows mutableCopy];
    for (NSInteger i = 0; i < windows.count; i++) {
        UIWindow *w = windows[i];
        if ([w isKindOfClass:[GYDDebugWindow class]]) {
            [windows removeObjectAtIndex:i];
            i--;
        }
    }
    return [self reloadViewHierarchyWithViewArray:windows];
}

- (void)reloadViewHierarchyWithViewArray:(NSArray<UIView *> *)viewArray {
    for (UIView *view in viewArray) {
        [UIView gyd_updateSubviewPropertyNameForView:view];
    }
    _rootItem = [GYDDebugViewHierarchyItem rootItemWithViewArray:viewArray];
    
    [self resetViewHierarchy];
    
    NSSet<NSString *> *ignoreClassNames = [GYDDebugViewHierarchyWindowControl systemTailViewClassNames];
    
    [_rootItem asyncLoadImageWithIgnoreClassNameSet:ignoreClassNames];
//    NSDictionary *viewCount = [_rootItem viewClassCount];
//    
//    NSLog(@"%@", viewCount);
}

- (void)resetViewHierarchy {
    NSSet<NSString *> *ignoreClassNames = [GYDDebugViewHierarchyWindowControl systemContainerViewClassNames];
    ignoreClassNames = [ignoreClassNames setByAddingObjectsFromSet:[GYDDebugViewHierarchyWindowControl systemTailViewClassNames]];
    
    [_rootItem resetHiddenItemsShowIgnoreView:self.showIgnoreView showHiddenView:self.showHiddenView isSuperViewHidden:NO ignoreClassNameSet:ignoreClassNames];
    
    [_rootItem resetViewHierarchyReturnTopLevel];
    
    [_displayView reloadRootViewHierarchyItem:_rootItem];
}

#pragma mark - 选择

- (void)selectViewDidSelect:(GYDDebugViewHierarchySelectView *)view {
    NSArray *array = [_displayView itemArrayInSelectFrame:view.selectFrame];
    _listView.list = array;
    NSLog(@"%@", array);
}

@end
