//
//  GYDDebugLogTableView.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/24.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 带锁底功能的tableView
 */
@interface GYDDebugLogTableView : UITableView

/** 根据用户滑动判断保持当前位置或最底部 */
- (void)animateReloadData;

@end

NS_ASSUME_NONNULL_END
