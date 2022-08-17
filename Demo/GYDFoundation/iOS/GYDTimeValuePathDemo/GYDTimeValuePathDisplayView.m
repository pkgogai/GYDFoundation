//
//  GYDTimeValuePathDisplayView.m
//  GYDTimeValuePath
//
//  Created by 宫亚东 on 2018/4/28.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTimeValuePathDisplayView.h"

@implementation GYDTimeValuePathDisplayView
{
    UILabel *_leftTopLabel;
    UILabel *_rightTopLabel;
    UILabel *_leftBottomLabel;
    UILabel *_rightBottomLabel;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _leftTopLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor blackColor];
            [self addSubview:label];
            label;
        });
        _rightTopLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor blackColor];
            [self addSubview:label];
            label;
        });
        _leftBottomLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor blackColor];
            [self addSubview:label];
            label;
        });
        _rightBottomLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor blackColor];
            [self addSubview:label];
            label;
        });
        
    }
    return self;
}
- (void)setTimeValuePath:(GYDTimeValuePath *)timeValuePath {
    _timeValuePath = timeValuePath;
    [self setNeedsDisplay];
}
- (void)setTimeValueFrame:(CGRect)timeValueFrame {
    _timeValueFrame = timeValueFrame;
    
    _leftBottomLabel.text = [NSString stringWithFormat:@"(%.2f,%.2f)", timeValueFrame.origin.x, timeValueFrame.origin.y];
    _rightBottomLabel.text = [NSString stringWithFormat:@"(%.2f,%.2f)", timeValueFrame.origin.x + timeValueFrame.size.width, timeValueFrame.origin.y];
    _leftTopLabel.text = [NSString stringWithFormat:@"(%.2f,%.2f)", timeValueFrame.origin.x, timeValueFrame.origin.y + timeValueFrame.size.height];
    _rightTopLabel.text = [NSString stringWithFormat:@"(%.2f,%.2f)", timeValueFrame.origin.x + timeValueFrame.size.width, timeValueFrame.origin.y + timeValueFrame.size.height];
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    CGSize viewSize = self.frame.size;
    CGSize size = [_leftTopLabel sizeThatFits:CGSizeZero];
    _leftTopLabel.frame = CGRectMake(0, 0, size.width, size.height);
    
    size = [_rightTopLabel sizeThatFits:CGSizeZero];
    _rightTopLabel.frame = CGRectMake(viewSize.width - size.width, 0, size.width, size.height);
    
    size = [_leftBottomLabel sizeThatFits:CGSizeZero];
    _leftBottomLabel.frame = CGRectMake(0, viewSize.height - size.height, size.width, size.height);
    
    size = [_rightBottomLabel sizeThatFits:CGSizeZero];
    _rightBottomLabel.frame = CGRectMake(viewSize.width - size.width, viewSize.height - size.height, size.width, size.height);
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    CGSize size = self.frame.size;
    CGRect timeValueFrame = [self timeValueFrame];
    CGSize tSize = CGSizeMake(timeValueFrame.size.width / size.width, timeValueFrame.size.height / size.height);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);

    [[UIColor grayColor] setStroke];
    [[UIColor grayColor] setFill];
    
    CGContextMoveToPoint(context, (timeValueFrame.origin.x + timeValueFrame.size.width) / tSize.width, 0);
    CGContextAddLineToPoint(context, (timeValueFrame.origin.x + timeValueFrame.size.width) / tSize.width, size.height);
    
    CGContextMoveToPoint(context, 0, (timeValueFrame.origin.y + timeValueFrame.size.height) / tSize.height);
    CGContextAddLineToPoint(context, size.width, (timeValueFrame.origin.y + timeValueFrame.size.height) / tSize.height);
    
    CGContextStrokePath(context);
    CGContextSetLineWidth(context, 2);
    
    [[UIColor redColor] setStroke];
    [[UIColor redColor] setFill];
    
    GYDTimeValuePath *path = self.timeValuePath;
    CGContextMoveToPoint(context, 0, (timeValueFrame.origin.y + timeValueFrame.size.height - [path valueAtTime:timeValueFrame.origin.x]) / tSize.height);
    
    for (int i = 1; i < size.width; i++) {
        CGContextAddLineToPoint(context, i, (timeValueFrame.origin.y + timeValueFrame.size.height - [path valueAtTime:timeValueFrame.origin.x + i * tSize.width]) / tSize.height);
    }
    CGContextStrokePath(context);
}

@end
