//
//  GYDLogListView.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/24.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDLogListView.h"
#import "GYDDebugLogTableView.h"
#import "GYDLogTableViewCellModel.h"
#import "GYDLogSpaceCellModel.h"
#import "GYDUIKit.h"

@interface GYDLogListView ()<UITableViewDelegate, UITableViewDataSource, GYDLogCacheArrayChangedDelegate, GYDTableViewCellModelDelegate>

@end

@implementation GYDLogListView
{
    GYDDebugLogTableView *_tableView;
    NSMutableArray *_dataSource;    //数据源
    NSMutableArray *_viewDataSource;    //筛选后的数据源，
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *logArray = [GYDLog logCacheArray];
        _dataSource = [NSMutableArray arrayWithCapacity:logArray.count];
        for (id i in logArray) {
            [_dataSource insertObject:i atIndex:0];
        }
        
        _viewDataSource = _dataSource;
        
        _tableView = [[GYDDebugLogTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        GYDLog.logCacheArrayChangedDelegate = self;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _tableView.frame = self.bounds;
    _tableView.contentInset = self.gyd_safeAreaInsets;
}


- (void)clearData {
    [_dataSource removeAllObjects];
    if (_viewDataSource != _dataSource) {
        [_viewDataSource removeAllObjects];
    }
    [_tableView reloadData];
}

- (void)addLine {
    GYDLogSpaceCellModel *model = [[GYDLogSpaceCellModel alloc] init];
    model.color = [UIColor redColor];
    model.height = 2;
    [_dataSource addObject:model];
    if (_viewDataSource != _dataSource) {
        [_viewDataSource addObject:model];
    }
    [_tableView animateReloadData];
}

- (NSArray *)filterOptionArray {
    static NSCharacterSet *charSet = nil;
    if (!charSet) {
        charSet = [NSCharacterSet characterSetWithCharactersInString:@"?]"];
    }
    NSMutableArray *array = [NSMutableArray array];
    for (GYDLogTableViewCellModel *item in _dataSource) {
        if (![item.type isEqualToString:@"request"]) {
            continue;
        }
        GYDStringSearch *search = [[GYDStringSearch alloc] initWithString:item.msg];
        if (![search subStringToString:@"/v1/"]) {
            continue;
        }
        NSString *string = [search subStringToCharacterSet:charSet indexMoveToRight:YES];
        if (string) {
            [array removeObject:string];
            [array insertObject:string atIndex:0];
        }
    }
    return array;
}

- (void)setFilterArray:(NSArray *)filterArray {
    
    if (filterArray.count < 1) {
        if (_filterArray) {
            _filterArray = nil;
            _viewDataSource = _dataSource;
            [_tableView animateReloadData];
        }
        return;
    }
    _filterArray = [filterArray copy];
    
    [self reloadViewDataSource];
}

- (void)reloadViewDataSource {
    if (_filterArray) {
        _viewDataSource = [NSMutableArray array];
        for (GYDLogTableViewCellModel *log in _dataSource) {
            if ([self isFilterLog:log]) {
                [_viewDataSource addObject:log];
            }
        }
    } else {
        _viewDataSource = _dataSource;
    }
    [_tableView animateReloadData];
}

- (BOOL)isFilterLog:(GYDLogTableViewCellModel *)log {
    if ([log isKindOfClass:[GYDLogSpaceCellModel class]]) {
        return YES;
    }
    for (NSString *filter in _filterArray) {
        if ([log.msg containsString:filter]) {
            return YES;
        }
    }
    return NO;
}

- (void)setIsFolded:(BOOL)isFolded {
    _isFolded = isFolded;
    for (GYDLogTableViewCellModel *log in _dataSource) {
        if (log.isFolded != isFolded) {
            log.isFolded = isFolded;
        }
    }
    [_tableView reloadData];
    [_tableView setContentOffset:CGPointMake(0, _tableView.contentSize.height + _tableView.contentInset.bottom - _tableView.frame.size.height) animated:NO];
}

- (void)setIsLogInterfaceEnable:(BOOL)isLogInterfaceEnable {
    _isLogInterfaceEnable = isLogInterfaceEnable;
    [_tableView reloadData];
}

#pragma mark - GYDLogCacheArrayChangedDelegate

- (void)logCacheArrayDidChangedWithNewLog:(GYDLogTableViewCellModel *)log {
    if (![log isKindOfClass:[GYDLogTableViewCellModel class]]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        log.isFolded = self.isFolded;
        [_dataSource addObject:log];
        if (_dataSource != _viewDataSource) {
            if (![self isFilterLog:log]) {
                return;
            }
            [_viewDataSource addObject:log];
        }
        [_tableView animateReloadData];
    });
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _viewDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _viewDataSource.count) {
        GYDLogTableViewCellModel *model = _viewDataSource[indexPath.row];
        CGFloat height = [model heightInTableView:tableView];
        if (model.isFolded) {
            return 40;
        } else {
            return height;
        }
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _viewDataSource.count) {
        GYDLogTableViewCellModel *model = _viewDataSource[indexPath.row];
        model.showFoldedButton = self.isLogInterfaceEnable;
        
        UITableViewCell *cell = [model cellInTableView:tableView];
        model.delegate = self;
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

- (void)cellModelNeedReloadData:(GYDTableViewCellModel *)model {
    [_tableView animateReloadData];
}

@end
