//
//  GYDDebugViewHierarchyItemListView.m
//  GYDFoundation
//
//  Created by gongyadong on 2022/7/4.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDDebugViewHierarchyItemListView.h"
#import "GYDDebugViewHierarchyCellModel.h"

@interface GYDDebugViewHierarchyItemListView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation GYDDebugViewHierarchyItemListView
{
    UITableView *_tableView;
    NSMutableArray *_viewDataSource;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.allowsMultipleSelection = YES;
        _tableView.exclusiveTouch = YES;
        _tableView.multipleTouchEnabled = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _tableView.frame = self.bounds;
    
}

- (void)setList:(NSArray<GYDDebugViewHierarchyItem *> *)list {
    _list = list;
    _viewDataSource = [NSMutableArray array];
    for (GYDDebugViewHierarchyItem *item in list) {
        GYDDebugViewHierarchyCellModel *model = [[GYDDebugViewHierarchyCellModel alloc] init];
        model.data = item;
        [_viewDataSource addObject:model];
    }
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _viewDataSource.count) {
        GYDDebugViewHierarchyCellModel *model = _viewDataSource[indexPath.row];
        CGFloat height = [model heightInTableView:tableView];
        return height;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _viewDataSource.count) {
        GYDDebugViewHierarchyCellModel *model = _viewDataSource[indexPath.row];
        
        
        UITableViewCell *cell = [model cellInTableView:tableView];
        cell.clipsToBounds = YES;
        return cell;
    }
    return [[GYDTableViewCell alloc] init];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
