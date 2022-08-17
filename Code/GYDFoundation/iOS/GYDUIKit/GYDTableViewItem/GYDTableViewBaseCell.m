//
//  GYDTableViewBaseCell.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/29.
//

#import "GYDTableViewBaseCell.h"

@implementation GYDTableViewBaseCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.cellView.frame = self.contentView.bounds;
}

@end
