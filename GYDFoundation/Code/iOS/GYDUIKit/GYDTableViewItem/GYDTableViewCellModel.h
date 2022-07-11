//
//  GYDTableViewCellModel.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/8/29.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDTableViewCell.h"

@class GYDTableViewCellModel;

@protocol GYDTableViewCellModelDelegate<NSObject>

@optional

/** 需要 tableview 调用 beginUpdates 和 endUpdates */
- (void)cellModelNeedUpdateCellHeight:(nonnull GYDTableViewCellModel *)model;

/** 需要 tableview 调用 reloadData */
- (void)cellModelNeedReloadData:(nonnull GYDTableViewCellModel *)model;

//下面这种用通知吧，数据还是全局同步的好一点
///** 需要插入对象 */
//- (void)cellModel:(GYDTableViewCellModel *)model needInsertModel:(GYDTableViewCellModel *)aModel offsetIndex:(NSInteger)index;
//
///** 需要删除自己 */
//- (void)cellModelNeedRemove:(GYDTableViewCellModel *)model;

@end

#pragma mark - Model需要继承此父类

/**
 用于列表的基类model，viewClass的返回值对class类型用协议看起来怪怪的，但先这么用着
 */
@interface GYDTableViewCellModel : NSObject

@property (nonatomic, weak, nullable)   id<GYDTableViewCellModelDelegate> delegate;

//高度缓存，与宽度相对应
@property (nonatomic) CGFloat cachedHeight;

/** 获取显示此model的cell */
- (nonnull GYDTableViewCell *)cellInTableView:(nonnull UITableView *)tableView;
/** 获取此model的高度（会缓存到cellHeight中） */
- (CGFloat)heightInTableView:(nonnull UITableView *)tableView;
/** 清除高度缓存 */
- (void)clearCachedHeight;

#pragma mark - 以下是需要子类实现的方法

/** cell类型， */
- (nonnull Class)cellClass;

/** cell复用的id */
- (nonnull NSString *)cellReuseId;

/** cell上与此model对应的view类型 */
- (nonnull Class<GYDTableViewCellViewProtocol>)viewClass;

/** 是否允许点击 */
- (BOOL)shouldClick;
/** 处理点击事件 */
- (void)handleClickEvent;

/** 数据的标识，用于判断是否是同一条数据，例如职位数据，则可用职位id作为标识，没有标识的则返回nil，表示各不相同 */
- (nullable NSString *)identifier;

/** 与另一个model比较，self 比 model 大，则为升序 NSOrderedAscending */
- (NSComparisonResult)sortToModel:(nonnull __kindof GYDTableViewCellModel *)model;


@end
