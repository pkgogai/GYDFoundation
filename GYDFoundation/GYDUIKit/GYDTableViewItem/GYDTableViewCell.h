//
//  GYDTableViewCell.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/8/29.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTableViewBaseCell.h"

/**
 指定高亮背景的cell，也是GYDTableViewCellModel默认使用的cell
 */
@interface GYDTableViewCell : GYDTableViewBaseCell

@property (nonatomic, nonnull) UIColor *highlightedColor;

@end
