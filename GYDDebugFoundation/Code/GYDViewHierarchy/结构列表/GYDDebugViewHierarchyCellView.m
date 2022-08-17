//
//  GYDDebugViewHierarchyCellView.m
//  GYDFoundation
//
//  Created by gongyadong on 2022/7/5.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDDebugViewHierarchyCellView.h"
#import "UIView+GYDCustomFunction.h"

@implementation GYDDebugViewHierarchyCellView
{
    GYDDebugViewHierarchyCellModel *_model;
    //预览图
    UIImageView *_imageView;
    UILabel *_classLabel;
    UILabel *_frameLabel;
    UILabel *_detailLabel;
    
    UIButton *_showButton;
    UIButton *_lockButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView;
        });
        [self addSubview:_imageView];
        
        _classLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = [UIColor blackColor];
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentLeft;
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label;
        });
        [self addSubview:_classLabel];
        
        _frameLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = [UIColor blackColor];
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentLeft;
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label;
        });
        [self addSubview:_frameLabel];
        
        _detailLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = [UIColor blackColor];
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentLeft;
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label;
        });
        [self addSubview:_detailLabel];
        
        _showButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor blueColor];
            [button setTitle:@"显" forState:UIControlStateNormal];
            [button setTitle:@"隐" forState:UIControlStateSelected];
            [button addTarget:self action:@selector(showButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        [self addSubview:_showButton];
        
    }
    return self;
}

- (CGFloat)updateWithModel:(nonnull GYDDebugViewHierarchyCellModel *)model width:(CGFloat)width onlyCalculateHeight:(BOOL)onlyCalculateHeight {
    _model = model;
    GYDDebugViewHierarchyItem *item = model.data;
    if (item.viewControllerClass.length > 0) {
        _classLabel.text = [NSString stringWithFormat:@"%@(%@)", item.viewControllerClass, item.viewClass];
    } else {
        _classLabel.text = item.viewClass;
    }
    CGRect frame = item.viewFrame;
    _frameLabel.text = [NSString stringWithFormat:@"(%.1f,%.1f)-(%.1f,%.1f)", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
    
    _detailLabel.text = item.viewDesc;
    
    _showButton.selected = !item.displayConfig.show;
    _showButton.frame = CGRectMake(width - 30, 10, 20, 20);
    width = width - 30;
    
    CGSize fitSize = CGSizeMake((width - 15) * 0.7, 0);
    CGFloat layoutY = 3;
    CGSize size = [_classLabel sizeThatFits:fitSize];
    _classLabel.frame = CGRectMake(5, layoutY, size.width, size.height);
    layoutY += (NSInteger)size.height + 3;
    
    size = [_frameLabel sizeThatFits:fitSize];
    _frameLabel.frame = CGRectMake(5, layoutY, size.width, size.height);
    layoutY += size.height + 3;
    
    size = [_detailLabel sizeThatFits:fitSize];
    _detailLabel.frame = CGRectMake(5, layoutY, size.width, size.height);
    layoutY += size.height;
    
    CGSize imageSize = item.viewCompleteImage.size;
    CGSize imageViewSize;
    imageViewSize.width = (width - 15) * 0.3;
    if (imageSize.width > 0) {
        imageViewSize.height = imageSize.height / imageSize.width * imageViewSize.width;
    } else {
        imageViewSize.height = 50;
    }
    
    if (layoutY < imageViewSize.height + 3) {
//        layoutY = MIN(imageViewSize.height, MAX(layoutY, 200));
        if (layoutY < 160) {
            layoutY = 160;
        }
        if (layoutY > imageViewSize.height + 3) {
            layoutY = imageViewSize.height + 3;
        } else {
            imageViewSize.height = layoutY - 3;
        }
    }
    
    if (!onlyCalculateHeight) {
        _imageView.image = item.viewCompleteImage;
        _imageView.frame = CGRectMake(fitSize.width + 10, 3, imageViewSize.width, imageViewSize.height);
    }
    return layoutY + 3;
}

- (void)showButtonAction:(UIButton *)button {
    _model.data.displayConfig.show = !_model.data.displayConfig.show;
    _showButton.selected = !_model.data.displayConfig.show;
    [self gyd_inViewTreeCallFunctionIfExists:@"layoutHierarchyItemViews" withArg:nil exist:NULL];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
