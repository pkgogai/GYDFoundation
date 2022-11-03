//
//  GYDSafeAreaDemoDisplayView.m
//  GYDFoundationDemo
//
//  Created by gongyadong on 2022/9/25.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDSafeAreaDemoDisplayView.h"
#import "GYDUIKit.h"

@implementation GYDSafeAreaDemoDisplayView
{
    //[0=gyd_safeArea,1=safeArea][0=top,1=left,2=bottom,3=right]
    UIView *_benginLineView[2][4];
    UIView *_endLineView[2][4];
    UIView *_valueLineView[2][4];
    UILabel *_safeAreaLabel[2][4];
    
    UIView *_gestureRecognizerView;
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ([super pointInside:point withEvent:event]) {
        return YES;
    }
    //让超出范围的子view也能响应手势
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
        for (NSInteger i = 0; i < 8; i++) {
            UIColor *color = i < 4 ? [UIColor redColor] : [UIColor blueColor];
            
            _benginLineView[0][i] = ({
                UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
                view.backgroundColor = color;
                [self addSubview:view];
                view;
            });
            _endLineView[0][i] = ({
                UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
                view.backgroundColor = color;
                [self addSubview:view];
                view;
            });
            _valueLineView[0][i] = ({
                UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
                view.backgroundColor = color;
                [self addSubview:view];
                view;
            });
            
            _safeAreaLabel[0][i] = ({
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.font = [UIFont systemFontOfSize:16];
                label.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
                label.textColor = color;
                label.numberOfLines = 1;
                [self addSubview:label];
                label;
            });
        }
        
        _gestureRecognizerView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor clearColor];
            [self addSubview:view];
            view;
        });
        
        __weak typeof(self) weakSelf = self;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithActionBlock_gyd:^(UIGestureRecognizer * _Nonnull gr) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gr;
            CGPoint p = [pan translationInView:strongSelf.superview];
            
            CGPoint center = strongSelf.center;
            center.x += p.x;
            center.y += p.y;
            strongSelf.center = center;
            [pan setTranslation:CGPointZero inView:strongSelf.superview];
            [strongSelf gyd_layoutViewSetNeedsLayout];
        }];
        [_gestureRecognizerView addGestureRecognizer:pan];
        
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithActionBlock_gyd:^(UIGestureRecognizer * _Nonnull gr) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            UIPinchGestureRecognizer *pinch = (UIPinchGestureRecognizer *)gr;
            strongSelf.transform = CGAffineTransformScale(strongSelf.transform, pinch.scale, pinch.scale);
            pinch.scale = 1;
            [strongSelf gyd_layoutViewSetNeedsLayout];
        }];
        [_gestureRecognizerView addGestureRecognizer:pinch];
        
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
        [_gestureRecognizerView addGestureRecognizer:rotation];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _gestureRecognizerView.frame = self.bounds;
}

- (void)updateSafeAreaValue {
    [self updateSafeArea:self.gyd_safeAreaInsets toViewIndex:0];
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    [self updateSafeArea:self.safeAreaInsets toViewIndex:1];
}

- (void)updateSafeArea:(UIEdgeInsets)safeArea toViewIndex:(NSInteger)index {
    CGSize size = self.bounds.size;
    CGSize textSize;
    CGFloat offset;
    NSInteger n;
    GYDUIStructUnion safeAreaToArray;
    safeAreaToArray.edgeInsetsValue = safeArea;
    CGFloat *safeAreaValue = safeAreaToArray.arrayValue;
    
    n = 0;
    offset = size.width / 2 + (index ? 60 : -60);
    _benginLineView[index][n].frame = CGRectMake(offset, 0, 11, 1);
    _endLineView[index][n].frame = CGRectMake(offset,safeAreaValue[n] - 1, 11, 1);
    _valueLineView[index][n].frame = CGRectMake(offset + 5, 0, 1, safeAreaValue[n]);
    _safeAreaLabel[index][n].text = [NSString stringWithFormat:@"%.f", safeAreaValue[n]];
    textSize = [_safeAreaLabel[index][n] sizeThatFits:CGSizeZero];
    _safeAreaLabel[index][n].frame = CGRectMake(offset + 10, (safeAreaValue[n] - textSize.height) / 2, textSize.width, textSize.height);
    
    n = 1;
    offset = size.height / 2 + (index ? 100 : -100);
    _benginLineView[index][n].frame = CGRectMake(0, offset, 1, 11);
    _endLineView[index][n].frame = CGRectMake(safeAreaValue[n] - 1, offset, 1, 11);
    _valueLineView[index][n].frame = CGRectMake(0, offset + 5, safeAreaValue[n], 1);
    _safeAreaLabel[index][n].text = [NSString stringWithFormat:@"%.f", safeAreaValue[n]];
    textSize = [_safeAreaLabel[index][n] sizeThatFits:CGSizeZero];
    _safeAreaLabel[index][n].frame = CGRectMake((safeAreaValue[n] - textSize.width) / 2, offset + 10, textSize.width, textSize.height);
    
    n = 2;
    offset = size.width / 2 + (index ? 60 : -60);
    _benginLineView[index][n].frame = CGRectMake(offset, size.height - safeAreaValue[n], 11, 1);
    _endLineView[index][n].frame = CGRectMake(offset,  size.height - 1, 11, 1);
    _valueLineView[index][n].frame = CGRectMake(offset + 5, size.height - safeAreaValue[n], 1, safeAreaValue[n]);
    _safeAreaLabel[index][n].text = [NSString stringWithFormat:@"%.f", safeAreaValue[n]];
    textSize = [_safeAreaLabel[index][n] sizeThatFits:CGSizeZero];
    _safeAreaLabel[index][n].frame = CGRectMake(offset + 10, size.height - (safeAreaValue[n] + textSize.height) / 2, textSize.width, textSize.height);
    
    n = 3;
    offset = size.height / 2 + (index ? 100 : -100);
    _benginLineView[index][n].frame = CGRectMake(size.width - safeAreaValue[n], offset, 1, 11);
    _endLineView[index][n].frame = CGRectMake(size.width - 1, offset, 1, 11);
    _valueLineView[index][n].frame = CGRectMake(size.width - safeAreaValue[n], offset + 5, safeAreaValue[n], 1);
    _safeAreaLabel[index][n].text = [NSString stringWithFormat:@"%.f", safeAreaValue[n]];
    textSize = [_safeAreaLabel[index][n] sizeThatFits:CGSizeZero];
    _safeAreaLabel[index][n].frame = CGRectMake(size.width - (safeAreaValue[n] + textSize.width) / 2, offset + 10, textSize.width, textSize.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
