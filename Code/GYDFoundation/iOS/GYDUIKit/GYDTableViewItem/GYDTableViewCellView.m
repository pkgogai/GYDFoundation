//
//  GYDTableViewCellView.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/8/30.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTableViewCellView.h"

@implementation GYDTableViewCellView


/** 更新model，返回值作为理想高度来用，onlyCalculateHeight表示专为计算高度调用，不影响高度的细节可以不去处理 */
- (CGFloat)updateWithModel:(nonnull GYDTableViewCellModel *)model width:(CGFloat)width onlyCalculateHeight:(BOOL)onlyCalculateHeight {
    return 0;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
