//
//  GYDTableViewCellExampleView.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/9/20.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTableViewCellExampleView.h"
#import "GYDUIKit.h"

@implementation GYDTableViewCellExampleView
{
    GYDTableViewCellExampleModel *_model;
    UILabel *_label;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.font = [UIFont systemFontOfSize:20];
            label.textColor = [UIColor redColor];
            label.numberOfLines = 0;
            label;
        });
        [self addSubview:_label];
    }
    return self;
}

- (CGFloat)updateWithModel:(GYDTableViewCellExampleModel *)model width:(CGFloat)width onlyCalculateHeight:(BOOL)onlyCalculateHeight {
    
    if (!onlyCalculateHeight) { //如果是只用来计算高度，背景色之类的肯定不用处理了
        _model = model;
        self.backgroundColor = model.backColor;
    }
    
    _label.text = model.title;
    _label.gyd_size = [_label sizeThatFits:CGSizeMake(width, 0)];
    return _label.gyd_bottomY + 2;
}
- (void)setNeedsLayout {
    [super setNeedsLayout];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    //要是有cell高度变化动画之类的，别忘了在这里写变化的布局
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
