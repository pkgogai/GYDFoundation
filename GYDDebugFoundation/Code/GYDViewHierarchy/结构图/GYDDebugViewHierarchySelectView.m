//
//  GYDDebugViewHierarchySelectView.m
//  GYDFoundation
//
//  Created by gongyadong on 2022/7/4.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDDebugViewHierarchySelectView.h"
#import "GYDUIKit.h"
#import "GYDWeakTarget.h"

@implementation GYDDebugViewHierarchySelectView
{
    CGRect _selectFrame;
    CGPoint _startPoint;
    CGPoint _endPoint;
    GYDWeakTarget *_weakTarget;
    UIImageView *_borderLineView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _weakTarget = [[GYDWeakTarget alloc] init];
        
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
//        [self addGestureRecognizer:pan];
        
        _borderLineView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            imageView;
        });
        [self addSubview:_borderLineView];
        
        _borderLineView.image = [[UIImage gyd_imageWithRectWidth:6 height:6 cornerRadius:0 borderColor:[UIColor blueColor] fillColor:nil lineWidth:2 dashWidth:0 dashClearWidth:0] gyd_stretchableImageFromCenter];
    }
    return self;
}

- (void)updateSelectFrame {
    if (_startPoint.x < _endPoint.x) {
        _selectFrame.origin.x = _startPoint.x;
        _selectFrame.size.width = _endPoint.x - _startPoint.x;
    } else {
        _selectFrame.origin.x = _endPoint.x;
        _selectFrame.size.width = _startPoint.x - _endPoint.x;
    }
    if (_startPoint.y < _endPoint.y) {
        _selectFrame.origin.y = _startPoint.y;
        _selectFrame.size.height = _endPoint.y - _startPoint.y;
    } else {
        _selectFrame.origin.y = _endPoint.y;
        _selectFrame.size.height = _startPoint.y - _endPoint.y;
    }
    _borderLineView.frame = _selectFrame;
    [_weakTarget callOnceWithSelectorObject:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    _startPoint = [touch locationInView:self];
    _endPoint = _startPoint;
    _borderLineView.hidden = NO;
    [self updateSelectFrame];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    _endPoint = [touch locationInView:self];
    [self updateSelectFrame];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    _endPoint = [touch locationInView:self];
    _borderLineView.hidden = YES;
    [self updateSelectFrame];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    _endPoint = [touch locationInView:self];
    _borderLineView.hidden = YES;
    [self updateSelectFrame];
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)pan {
    CGPoint local = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
        _selectFrame.origin.x = local.x;
        _selectFrame.origin.y = local.y;
        _selectFrame.size.width = 0;
        _selectFrame.size.height = 0;
        _borderLineView.hidden = NO;
    } else {
        _selectFrame.size.width = local.x - _selectFrame.origin.x;
        _selectFrame.size.height = local.y - _selectFrame.origin.y;
    }
    if (pan.state != UIGestureRecognizerStateBegan && pan.state != UIGestureRecognizerStateChanged) {
        _borderLineView.hidden = YES;
    } else {
        _borderLineView.frame = _selectFrame;
    }
    
    [_weakTarget callOnceWithSelectorObject:self];
}

- (void)setTarget:(id)target selectAction:(SEL)action {
    _weakTarget.target = target;
    _weakTarget.selector = action;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
