//
//  GYDDebugUnreadCountTreeViewItem.m
//  GYDDevelopment
//
//  Created by gongyadong on 2021/3/30.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDDebugUnreadCountTreeViewItem.h"
#import "GYDUIKit.h"
@implementation GYDDebugUnreadCountTreeViewItem

+ (instancetype)viewItemWithManager:(GYDUnreadCountManager *)manager type:(NSString *)type {
    GYDDebugUnreadCountTreeViewItem *item = [[GYDDebugUnreadCountTreeViewItem alloc] init];
    //view随便写写就好
    item.view = ({
        UIButton *button = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            static UIImage *borderImage = nil;
            if (!borderImage) {
                borderImage = [[UIImage gyd_imageWithRectWidth:5 height:5 cornerRadius:1 borderColor:[UIColor grayColor] fillColor:nil lineWidth:1 dashWidth:0 dashClearWidth:0] gyd_stretchableImageFromCenter];
            }
            [button setBackgroundImage:borderImage forState:UIControlStateNormal];
            [button gyd_setClickActionBlock:^(UIButton * _Nonnull button) {
                NSInteger value = [manager selfValueForType:type];
                if (value > 2) {
                    value = 2;
                } else if (value < 0) {
                    value = 2;
                } else {
                    value --;
                }
                [manager setValue:value forType:type];
            }];
            button;
        });
        
        UILabel *typeLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.numberOfLines = 1;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:16];
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
        [button addSubview:typeLabel];
        
        UILabel *redLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.numberOfLines = 1;
            label.backgroundColor = [UIColor redColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:10];
            label.textAlignment = NSTextAlignmentCenter;
            label.clipsToBounds = YES;
            label;
        });
        [button addSubview:redLabel];
        
        NSString *desc = type;
        NSInteger value = [manager selfValueForType:type];
        if (value != 0) {
            desc = [desc stringByAppendingFormat:@"(%@)", @(value)];
        }
        typeLabel.text = desc;
        typeLabel.gyd_size = [typeLabel sizeThatFits:CGSizeZero];
        if (typeLabel.gyd_width < 20) {
            typeLabel.gyd_width = 20;
        }
        NSInteger allValue = [manager valueForType:type];
        if (allValue < 0) {
            redLabel.hidden = NO;
            redLabel.text = nil;
            redLabel.gyd_size = CGSizeMake(10, 10);
            redLabel.layer.cornerRadius = 5;
        } else if (allValue == 0) {
            redLabel.hidden = YES;
        } else {
            redLabel.hidden = NO;
            redLabel.text = [NSString stringWithFormat:@"%zd", allValue];
            CGSize size = [redLabel sizeThatFits:CGSizeZero];
            size.width += 2;
            size.height += 2;
            if (size.width < size.height) {
                size.width = size.height;
            }
            redLabel.gyd_size = size;
            redLabel.layer.cornerRadius = size.height / 2;
        }
        
        typeLabel.gyd_origin = CGPointMake(2, 2);
        int width = typeLabel.gyd_rightX + 2;
        if (redLabel.gyd_noHidden) {
            redLabel.gyd_x = width + 2;
            redLabel.gyd_centerY = (int)typeLabel.gyd_centerY;
            width = redLabel.gyd_rightX + 2;
        }
        button.frame = CGRectMake(0, 0, width, (int)(typeLabel.gyd_bottomY / 2) * 2 + 2);
        
        button;
    });
    
    return item;
}

@end
