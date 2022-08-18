//
//  GYDTimeValuePathItemView.m
//  GYDTimeValuePath
//
//  Created by 宫亚东 on 2018/4/28.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTimeValuePathItemView.h"
#import "GYDTimeValuePathDisplayView.h"
#import "GYDUIKit.h"

@implementation GYDTimeValuePathItemView
{
    UILabel *_titleLabel;
    UILabel *_descLabel;
    GYDTimeValuePathDisplayView *_displayView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor blackColor];
            label.numberOfLines = 1;
            [self addSubview:label];
            label;
        });
        _descLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor blackColor];
            label.numberOfLines = 1;
            [self addSubview:label];
            label;
        });
        _displayView = ({
            GYDTimeValuePathDisplayView *view = [[GYDTimeValuePathDisplayView alloc] initWithFrame:CGRectZero];
            [self addSubview:view];
            view;
        });
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    CGFloat layoutY = 0;
    if (_titleLabel.text.length > 0) {
        _titleLabel.frame = CGRectMake(0, layoutY, size.width, 16);
        layoutY = _titleLabel.gyd_bottomY;
    }
    if (_descLabel.text.length > 0) {
        _descLabel.frame = CGRectMake(0, layoutY, size.width, 16);
        layoutY = _descLabel.gyd_bottomY;
    }
    _displayView.frame = CGRectMake(0, layoutY, size.width, size.height - layoutY);
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}
- (NSString *)title {
    return _titleLabel.text;
}

- (void)setTimeValuePath:(GYDTimeValuePath *)timeValuePath {
    _displayView.timeValuePath = timeValuePath;
    _descLabel.text = [timeValuePath description];
}
- (GYDTimeValuePath *)timeValuePath {
    return _displayView.timeValuePath;
}
- (void)setTimeValueFrame:(CGRect)timeValueFrame {
    _displayView.timeValueFrame = timeValueFrame;
}
- (CGRect)timeValueFrame {
    return _displayView.timeValueFrame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
