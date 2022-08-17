//
//  GYDDebugViewHierarchyItemView.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/08/09.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDDebugViewHierarchyItemView.h"
#import "GYDUIKit.h"

#import "GYDDebugViewHierarchyItem.h"

@implementation GYDDebugViewHierarchyItemView
{
    UIImageView *_borderLineView;
    UIImage *_borderLineViewImage;
    UIImageView *_imageView;
    UILabel *_frameLabel;
    UILabel *_classLabel;
    UILabel *_descLabel;
    UILabel *_vcClassLabel;
    
    UIImageView *_descImageView;
}

#pragma mark - UI
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        UIColor *backgroundColor = [UIColor whiteColor];//[UIColor colorWithWhite:1 alpha:1];
        _imageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            imageView;
        });
        [self addSubview:_imageView];
        
        _frameLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = backgroundColor;
            label.font = [UIFont systemFontOfSize:10];
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label.numberOfLines = 1;
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
        [self addSubview:_frameLabel];
        
        _classLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = backgroundColor;
            label.font = [UIFont systemFontOfSize:10];
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label.numberOfLines = 1;
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
        [self addSubview:_classLabel];
        
        _descLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = backgroundColor;
            label.font = [UIFont systemFontOfSize:10];
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
        [self addSubview:_descLabel];
        
        _borderLineView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            imageView;
        });
        [self addSubview:_borderLineView];
        
        _descImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            imageView;
        });
        [self addSubview:_descImageView];
        
        _descImageView.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_borderLineView && !_borderLineView.hidden) {
        _borderLineView.frame = self.bounds;
    }
    if (_imageView && !_imageView.hidden) {
        CGSize sSize = self.model.viewFrame.size;
        CGSize oSize = self.bounds.size;
        CGSize scaleSize = CGSizeZero;
        if (sSize.width > 0) {
            scaleSize.width = oSize.width / sSize.width;
        }
        if (sSize.height > 0) {
            scaleSize.height = oSize.height / sSize.height;
        }
        CGRect frame = self.model.imageFrame;
        frame.origin.x *= scaleSize.width;
        frame.origin.y *= scaleSize.height;
        frame.size.width *= scaleSize.width;
        frame.size.height *= scaleSize.height;
        _imageView.frame = frame;
    }
    CGFloat layoutY = 0;
    if (_frameLabel && !_frameLabel.hidden) {
        CGSize size = [_frameLabel sizeThatFits:CGSizeZero];
        layoutY -= size.height;
        _frameLabel.frame = CGRectMake(0, layoutY, size.width, size.height);
//        layoutY += size.height;
    }
    if (_classLabel && !_classLabel.hidden) {
        CGSize size = [_classLabel sizeThatFits:CGSizeZero];
        layoutY -= size.height;
        _classLabel.frame = CGRectMake(0, layoutY, size.width, size.height);
//        layoutY += size.height;
    }
    if (_descLabel && !_descLabel.hidden) {
        CGSize size = [_descLabel sizeThatFits:CGSizeMake(MAX(self.frame.size.width, 120), 0)];
//        CGSize size = [_descLabel sizeThatFits:CGSizeMake(200, 0)];
        _descLabel.frame = CGRectMake(0, 0, size.width, size.height);
//        layoutY += size.height;
    }
//    if (_vcClassLabel && !_vcClassLabel.hidden) {
//        CGSize size = [_vcClassLabel sizeThatFits:CGSizeZero];
//        _vcClassLabel.frame = CGRectMake(0, -size.height, size.width, size.height);
//    }

    
}

#pragma mark - 数据

- (void)setModel:(GYDDebugViewHierarchyItem *)model {
    _model = model;
    CGRect frame = model.viewFrame;
    CGFloat red = 1 - ((model.level + 4) % 5) / 4.0;
    CGFloat green = (model.level / 5) % 5 / 4.0;
    CGFloat blue = 1- red;//((model.level ) / 4) % 2 / 1.0;
    
//    CGFloat red = (model.level % 2) / 1.0;
//    CGFloat green = ((model.level ) / 2) % 2 / 1.0;
//    CGFloat blue = ((model.level ) / 4) % 2 / 1.0;
    
//    CGFloat red = (model.hierarchyIndex % 3) / 2.0;
//    CGFloat green = ((model.hierarchyIndex + 7) / 3) % 9 / 2.0;
//    CGFloat blue = ((model.hierarchyIndex + 20 ) / 9) % 27 / 2.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
//    color = GYDColorGray(33);
    _borderLineViewImage = [[UIImage gyd_imageWithRectWidth:3 height:3 cornerRadius:0 borderColor:color fillColor:nil lineWidth:1 dashWidth:0 dashClearWidth:0] gyd_stretchableImageFromCenter];
//    _imageView.image = model.viewPartImage;
    [self resetBorderLineImage];
    _frameLabel.text = [NSString stringWithFormat:@"(%.1f,%.1f)-(%.1f,%.1f)", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
    _frameLabel.textColor = color;
    
    if (model.viewControllerClass.length > 0) {
        _classLabel.text = [NSString stringWithFormat:@"%@(%@)", model.viewControllerClass, model.viewClass];
    } else {
        _classLabel.text = model.viewClass;
    }
    _classLabel.textColor = color;
    
//    if (model.viewControllerClass.length > 0) {
//        _vcClassLabel.text = model.viewControllerClass;
//        _vcClassLabel.textColor = color;
//        _vcClassLabel.layer.borderColor = color.CGColor;
//    } else {
//        _vcClassLabel.hidden = YES;
//    }
    
    _descLabel.text = model.viewDesc;
    _descLabel.textColor = color;
//    @autoreleasepool {
//        CGSize size = [_descLabel sizeThatFits:CGSizeMake(200, 0)];
//        _descLabel.frame = CGRectMake(0, 0, size.width, size.height);
//        _descLabel.hidden = NO;
////        UIImage *image = [UIImage gyd_imageWithView:_descLabel];
////        _descImageView.image = image;
////        _descImageView.frame = CGRectMake(0, 0, size.width, size.height);
////        _descLabel.text = nil;
//    }

    [self setNeedsLayout];
}

- (void)updateConfig {
    GYDDebugViewHierarchyItemConfig *config = self.model.displayConfig;
    _borderLineView.hidden = !config.showBorderLine;
    _imageView.hidden = !config.showImage;
    _frameLabel.hidden = !config.showFrame;
    _classLabel.hidden = !config.showClass;
    _descLabel.hidden = !config.showDesc;
//    _descLabel.hidden = YES;
    _descImageView.hidden = YES;
//    _descImageView.hidden = !config.showDesc;
    [self setNeedsLayout];
}

- (void)setUseCompleteImage:(BOOL)useCompleteImage {
    _useCompleteImage = useCompleteImage;
    [self updateImage];
}

- (void)updateImage {
    _imageView.image = _useCompleteImage ? self.model.viewCompleteImage : self.model.viewPartImage;
}

- (void)setIsSelected:(BOOL)isSelected {
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
        [self resetBorderLineImage];
    }
}

- (void)resetBorderLineImage {
    if (_isSelected) {
        static UIImage *selectedImage = nil;
        if (!selectedImage) {
            selectedImage = [[UIImage gyd_imageWithRectWidth:5 height:5 cornerRadius:0 borderColor:[UIColor blueColor] fillColor:nil lineWidth:2 dashWidth:0 dashClearWidth:0] gyd_stretchableImageFromCenter];
        }
        _borderLineView.image = selectedImage;
    } else {
        _borderLineView.image = _borderLineViewImage;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
