//
//  GYDLogTableViewCellModel.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/9/25.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDLogTableViewCellModel.h"
#import "GYDLogTableViewCellView.h"
#import "GYDFoundation.h"

@implementation GYDLogTableViewCellModel
{
    NSMutableAttributedString *_attText;
}
- (GYDTableViewCell *)cellInTableView:(UITableView *)tableView {
    GYDTableViewCell *cell = [super cellInTableView:tableView];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (Class)viewClass {
    return [GYDLogTableViewCellView class];
}

- (NSMutableAttributedString *)attText {
    if (!_attText) {
        _attText = [[NSMutableAttributedString alloc] initWithString:_msg];
        if (self.lv < 1) {
            [_attText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, _attText.length)];
        } else if (self.lv == 1) {
            [_attText addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(0, _attText.length)];
        } else if (self.lv == 2) {
            [_attText addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, _attText.length)];
        } else {
            [_attText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, _attText.length)];
        }
        NSRange range = NSMakeRange(0, _msg.length);
        while (range.length > 0) {
            NSRange startRange = [_msg rangeOfString:@"[[" options:0 range:range];
            if (!startRange.length) {
                break;
            }
            range.location = startRange.location + startRange.length;
            range.length = _msg.length - range.location;
            NSRange endRange = [_msg rangeOfString:@"]]" options:0 range:range];
            if (!endRange.length) {
                break;
            }
            NSRange colorRange;
            colorRange.location = startRange.location + startRange.length;
            colorRange.length = endRange.location - colorRange.location;
            [_attText addAttributes:@{
                NSForegroundColorAttributeName : [UIColor redColor],
                NSBackgroundColorAttributeName : [UIColor whiteColor]
            } range:colorRange];

        }
    }
    return _attText;
}

@end
