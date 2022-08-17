//
//  GYDTableViewCellDemoType2Model.m
//  GYDDevelopment
//
//  Created by gongyadong on 2022/8/17.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDTableViewCellDemoType2Model.h"
#import "GYDTableViewCellDemoType2View.h"

@implementation GYDTableViewCellDemoType2Model

- (Class)viewClass {
    return [GYDTableViewCellDemoType2View class];
}


/*
// cell类型
- (nonnull Class)cellClass {
    return [GYDTableViewCell class];
}
// cell复用的id
- (nonnull NSString *)cellReuseId {
    return NSStringFromClass([self viewClass]);
}

// 是否允许点击
- (BOOL)shouldClick {
    return YES;
}
// 处理点击事件
- (void)handleClickEvent {
    
}
// 数据的标识，用于判断是否是同一条数据，例如人名，则可用"name_{人名}"作为标识，没有标识的则返回nil，表示各不相同
- (nullable NSString *)identifier {
    return nil;
}

// 与另一个model比较，self 比 model 大，则为升序 NSOrderedAscending
- (NSComparisonResult)sortToModel:(nonnull GYDTableViewCellDemoType2Model *)model {
    if (![model isKindOfClass:[GYDTableViewCellDemoType2Model class]]) {
        return NSOrderedSame;
    }
    return NSOrderedSame;
}
*/

@end
