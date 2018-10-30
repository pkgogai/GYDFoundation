//
//  GYDTableViewCell.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/8/29.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTableViewCell.h"


@implementation GYDTableViewCell
{
    UIView *_highlightedView;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        if (!_highlightedView) {
            _highlightedView = [[UIView alloc] initWithFrame:self.contentView.bounds];
            _highlightedView.backgroundColor = self.highlightedColor;
            _highlightedView.userInteractionEnabled = NO;
        }
        _highlightedView.frame = self.contentView.bounds;
        [self.contentView addSubview:_highlightedView];
    } else {
        if (_highlightedView) {
            [_highlightedView removeFromSuperview];
        }
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.highlightedColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_highlightedView.superview) {
        _highlightedView.frame = self.contentView.bounds;
    }
}

@end
