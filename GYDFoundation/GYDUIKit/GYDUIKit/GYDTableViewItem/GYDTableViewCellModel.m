//
//  GYDTableViewCellModel.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/8/29.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTableViewCellModel.h"
#import "GYDTableViewCellView.h"

@implementation GYDTableViewCellModel
{
    CGFloat _cachedWidth;   //缓存高度时要记录对应的宽度，当宽度改变后就需要重新计算高度
}

static NSMutableDictionary *_CellCacheDictionary = nil;

/** 获取显示此model的cell */
- (nonnull GYDTableViewCell *)cellInTableView:(nonnull UITableView *)tableView {
    
    NSString *cellId = [self cellReuseId];
    
    GYDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        Class viewClass = [self viewClass];
        Class cellClass = [self cellClass];
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UIView<GYDTableViewCellViewProtocol> *view = [[viewClass alloc] initWithFrame:CGRectZero];
        [cell.contentView addSubview:view];
        cell.cellView = view;
    }
    CGFloat viewHeight = [cell.cellView updateWithModel:self width:tableView.frame.size.width onlyCalculateHeight:NO];
    cell.cellView.frame = CGRectMake(0, 0, tableView.frame.size.width, viewHeight);
    return cell;
}
/** 获取此model的高度（会缓存到cellHeight中） */
- (CGFloat)heightInTableView:(nonnull UITableView *)tableView {
    if (tableView.frame.size.width != _cachedWidth) {
        _cachedWidth = tableView.frame.size.width;
        
        NSString *cellId = [self cellReuseId];
        if (!_CellCacheDictionary) {
            _CellCacheDictionary = [NSMutableDictionary dictionary];
        }
        GYDTableViewCell *cell = [_CellCacheDictionary objectForKey:cellId];
        if (!cell) {
            Class viewClass = [self viewClass];
            Class cellClass = [self cellClass];
            cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            UIView<GYDTableViewCellViewProtocol> *view = [[viewClass alloc] initWithFrame:CGRectZero];
            [cell.contentView addSubview:view];
            cell.cellView = view;
            _CellCacheDictionary[cellId] = cell;
        }
        _cachedHeight = [cell.cellView updateWithModel:self width:_cachedWidth onlyCalculateHeight:YES];
    }
    return _cachedHeight;
}

/** 清除高度缓存 */
- (void)clearCachedHeight {
    _cachedHeight = 0;
    _cachedWidth = 0;
}

/** cell类型 */
- (nonnull Class)cellClass {
    return [GYDTableViewCell class];
}

/** cell复用的id */
- (nonnull NSString *)cellReuseId {
    return NSStringFromClass([self viewClass]);
}

- (nonnull Class)viewClass {
    NSAssert(0, @"子类必须实现");
    return [GYDTableViewCellView class];
}

/** 是否允许点击 */
- (BOOL)shouldClick {
    return YES;
}
/** 处理点击事件 */
- (void)handleClickEvent {
    
}

/** 数据的标识，用于判断是否是同一条数据，例如职位数据，则可用职位id作为标识，没有标识的则返回nil，表示各不相同 */
- (nullable NSString *)identifier {
    return nil;
}

/** 与另一个model比较，self 比 model 大，则为升序 NSOrderedAscending */
- (NSComparisonResult)sortToModel:(nonnull __kindof GYDTableViewCellModel *)model {
    return NSOrderedSame;
}

@end
