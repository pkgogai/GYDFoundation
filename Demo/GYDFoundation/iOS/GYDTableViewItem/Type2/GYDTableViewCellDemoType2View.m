//
//  GYDTableViewCellDemoType2View.m
//  GYDDevelopment
//
//  Created by gongyadong on 2022/8/17.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDTableViewCellDemoType2View.h"

@implementation GYDTableViewCellDemoType2View
{
    GYDTableViewCellDemoType2Model *_model;
}
/** 创建子view */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

/** 更新model，返回值作为理想高度来用，onlyForHeight==YES时表示专为计算高度调用，只要能返回正确高度即可，不影响高度的细节可以不去处理 */
- (CGFloat)updateWithModel:(nonnull GYDTableViewCellDemoType2Model *)model width:(CGFloat)width onlyCalculateHeight:(BOOL)onlyCalculateHeight {
    if (!onlyCalculateHeight) {
        _model = model;
        
    }
    self.backgroundColor = [UIColor redColor];
    return 10;   //最后返回view的高度
}

//要是有cell高度变化动画之类的，别忘了在这里写变化的布局
/*
- (void)layoutSubviews {
    [super layoutSubviews];
    
}
 */

@end
