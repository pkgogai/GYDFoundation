//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

#import "___VARIABLE_productName___Model.h"
#import "___VARIABLE_productName___View.h"

@implementation ___VARIABLE_productName___Model

- (Class)viewClass {
    return [___VARIABLE_productName___View class];
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
- (NSComparisonResult)sortToModel:(nonnull ___VARIABLE_productName___Model *)model {
    if (![model isKindOfClass:[___VARIABLE_productName___Model class]]) {
        return NSOrderedSame;
    }
    return NSOrderedSame;
}
*/

@end
