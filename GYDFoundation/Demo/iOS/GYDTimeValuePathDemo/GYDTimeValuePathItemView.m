//
//  GYDTimeValuePathItemView.m
//  GYDTimeValuePath
//
//  Created by 宫亚东 on 2018/4/28.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTimeValuePathItemView.h"
#import "GYDTimeValuePathDisplayView.h"

@implementation GYDTimeValuePathItemView
{
    UILabel *_titleLabel;
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
    _titleLabel.frame = CGRectMake(0, 0, size.width, 20);
    if (size.height > 20) {
        size.height -= 20;
    } else {
        size.height = 0;
    }
    _displayView.frame = CGRectMake(0, 20, size.width, size.height);
}

- (void)setTimeValuePath:(GYDTimeValuePath *)timeValuePath {
    _displayView.timeValuePath = timeValuePath;
    _titleLabel.text = [timeValuePath description];
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
