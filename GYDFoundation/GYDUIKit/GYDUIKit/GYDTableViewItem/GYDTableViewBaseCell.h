//
//  GYDTableViewBaseCell.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/29.
//

#import <UIKit/UIKit.h>

@class GYDTableViewCellModel;

#pragma mark - View需要实现此协议

/*
 如果有需要通过tableview的beginUpdates 和 endUpdates来做调整高度的动画，可以在view的layoutSubviews中处理动画效果
 */
@protocol GYDTableViewCellViewProtocol<NSObject>

/** 更新model，返回值作为理想高度来用，onlyCalculateHeight表示专为计算高度调用，不影响高度的细节可以不去处理 */
- (CGFloat)updateWithModel:(nonnull GYDTableViewCellModel *)model width:(CGFloat)width onlyCalculateHeight:(BOOL)onlyCalculateHeight;

@end;

/**
 最原始的系统cell，可以被继承，并在 GYDTableViewCellModel 的 cellClass 中指定cell类型
 */
@interface GYDTableViewBaseCell : UITableViewCell

@property (nonatomic, nonnull)  UIView<GYDTableViewCellViewProtocol> *cellView;

@end
