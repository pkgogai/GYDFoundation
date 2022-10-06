//
//  GYDSafeAreaDemoDisplayView.m
//  GYDFoundationDemo
//
//  Created by gongyadong on 2022/9/25.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDSafeAreaDemoDisplayView.h"
#import "UIView+GYDSafeArea.h"
#import "UIView+GYDPanToMove.h"
#import "GYDUIKit.h"

@implementation GYDSafeAreaDemoDisplayView
{
    UILabel *_safeAreaLabel1;
    UIView *_topLineView1;
    UIView *_bottomLineView1;
    UIView *_valueLineView1;
    
    UILabel *_safeAreaLabel2;
    UIView *_topLineView2;
    UIView *_bottomLineView2;
    UIView *_valueLineView2;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ([super pointInside:point withEvent:event]) {
        return YES;
    }
    for (UIView *view in self.subviews) {
        if ([view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
            return YES;
        }
    }
    return NO;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _topLineView1 = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor redColor];
            view;
        });
        [self addSubview:_topLineView1];
        _bottomLineView1 = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor redColor];
            view;
        });
        [self addSubview:_bottomLineView1];
        _valueLineView1 = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor redColor];
            view;
        });
        [self addSubview:_valueLineView1];
        
        _safeAreaLabel1 = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.font = [UIFont systemFontOfSize:16];
            label.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
            label.textColor = [UIColor redColor];
            label.numberOfLines = 1;
            label;
        });
        [self addSubview:_safeAreaLabel1];
        
        _topLineView2 = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor redColor];
            view;
        });
        [self addSubview:_topLineView2];
        _bottomLineView2 = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor redColor];
            view;
        });
        [self addSubview:_bottomLineView2];
        _valueLineView2 = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor redColor];
            view;
        });
        [self addSubview:_valueLineView2];
        
        _safeAreaLabel2 = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.font = [UIFont systemFontOfSize:16];
            label.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
            label.textColor = [UIColor redColor];
            label.numberOfLines = 1;
            label;
        });
        [self addSubview:_safeAreaLabel2];
        
        
        [self gyd_setMovePanGestureRecognizerEnable:YES action:^(UIView * _Nonnull view, CGPoint from, CGPoint * _Nonnull to) {
            [view gyd_layoutViewSetNeedsLayout];
        }];
        
        __weak typeof(self) weakSelf = self;
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithActionBlock_gyd:^(UIGestureRecognizer * _Nonnull gr) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            UIPinchGestureRecognizer *pinch = (UIPinchGestureRecognizer *)gr;
            strongSelf.transform = CGAffineTransformScale(self.transform, pinch.scale, pinch.scale);
            pinch.scale = 1;
            [strongSelf gyd_layoutViewSetNeedsLayout];
        }];
        [self addGestureRecognizer:pinch];
        
        UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithActionBlock_gyd:^(UIGestureRecognizer * _Nonnull gr) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            UIRotationGestureRecognizer *rotation = (UIRotationGestureRecognizer *)gr;
            strongSelf.transform = CGAffineTransformRotate(strongSelf.transform, rotation.rotation);
            rotation.rotation = 0;
            [strongSelf gyd_layoutViewSetNeedsLayout];
        }];;
        [self addGestureRecognizer:rotation];
        
    }
    return self;
}

- (void)updateSafeAreaValue {
    CGFloat top1 = self.gyd_safeAreaInsets.top;
    _topLineView1.frame = CGRectMake(0, 0, 11, 1);
    _bottomLineView1.frame = CGRectMake(0, top1 - 1, 11, 1);
    _valueLineView1.frame = CGRectMake(5, 0, 1, top1);
    _safeAreaLabel1.text = [NSString stringWithFormat:@"%.f", top1];
    CGSize textSize = [_safeAreaLabel1 sizeThatFits:CGSizeZero];
    _safeAreaLabel1.frame = CGRectMake(10, (top1 - textSize.height) / 2, textSize.width, textSize.height);
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    CGSize size = self.bounds.size;
    CGFloat top2 = self.safeAreaInsets.top;
    _topLineView2.frame = CGRectMake(size.width - 11, 0, 11, 1);
    _bottomLineView2.frame = CGRectMake(size.width - 11, top2 - 1, 11, 1);
    _valueLineView2.frame = CGRectMake(size.width - 6, 0, 1, top2);
    _safeAreaLabel2.text = [NSString stringWithFormat:@"%.f", top2];
    CGSize textSize = [_safeAreaLabel2 sizeThatFits:CGSizeZero];
    _safeAreaLabel2.frame = CGRectMake(size.width - textSize.width - 10, (top2 - textSize.height) / 2, textSize.width, textSize.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
