//
//  GYDLogTableViewCellView.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/9/25.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDLogTableViewCellView.h"

@implementation GYDLogTableViewCellView
{
    GYDLogTableViewCellModel *_model;
    UILabel *_funLabel; //函数那行
    UILabel *_msgLabel;    //信息
    UIView *_lineView;
    UIButton *_foldButton;  //折叠展开按钮
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _funLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 1;
            label.font = [UIFont systemFontOfSize:16];
            label.backgroundColor = [UIColor clearColor];
            [self addSubview:label];
            label;
        });
        _msgLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:14];
            label.backgroundColor = [UIColor clearColor];
            [self addSubview:label];
            label;
        });
        
        _lineView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithRed:0.7 green:0.5 blue:0.7 alpha:1];
            [self addSubview:view];
            view;
        });
        _foldButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
            //文字
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [button setTitle:@"折叠" forState:UIControlStateNormal];
            [button setTitle:@"展开" forState:UIControlStateSelected];
            //事件
            [button addTarget:self action:@selector(foldButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            button;
        });
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerAction:)];
        [self addGestureRecognizer:longPress];
        
    }
    return self;
}
- (CGFloat)updateWithModel:(nonnull GYDLogTableViewCellModel *)model width:(CGFloat)width onlyCalculateHeight:(BOOL)onlyCalculateHeight {
    _model = model;
    _funLabel.text = [NSString stringWithUTF8String:model.fun];
    _msgLabel.text = model.msg;
    CGSize funSize = [_funLabel sizeThatFits:CGSizeZero];
    CGSize msgSize = [_msgLabel sizeThatFits:CGSizeMake(width, 0)];
    if (!onlyCalculateHeight) {
        _lineView.frame = CGRectMake(0, 0, width, 2);
        _funLabel.frame = CGRectMake(0, 2, width, funSize.height);
        _msgLabel.frame = CGRectMake(0, 2 + funSize.height, width, msgSize.height);
        
        _msgLabel.attributedText = model.attText;
        if (model.lv < 1) {
            _funLabel.textColor = [UIColor redColor];
        } else if (model.lv == 1) {
            _funLabel.textColor = [UIColor yellowColor];
        } else if (model.lv == 2) {
            _funLabel.textColor = [UIColor greenColor];
        } else {
            _funLabel.textColor = [UIColor whiteColor];
        }
        if (model.showFoldedButton) {
            _foldButton.hidden = NO;
            _foldButton.frame = CGRectMake(width - 60, 0, 40, 30);
            _foldButton.selected = _model.isFolded;
        } else {
            _foldButton.hidden = YES;
        }
    }
    
    CGFloat height = funSize.height + msgSize.height + 6;
    return height;
}

- (void)foldButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    _model.isFolded = button.selected;
    [_model.delegate cellModelNeedReloadData:_model];
}

- (void)longPressGestureRecognizerAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state != UIGestureRecognizerStateBegan) {
        return;
    }
    UIPasteboard *pasteBoard =  [UIPasteboard generalPasteboard];
    NSString *msg = [NSString stringWithFormat:@"%s\n%@", _model.fun, _model.msg];
    pasteBoard.string = msg;
    self.backgroundColor = [UIColor blueColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.backgroundColor = [UIColor clearColor];
    });
}

@end
