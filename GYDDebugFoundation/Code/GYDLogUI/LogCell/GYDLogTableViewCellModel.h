//
//  GYDLogTableViewCellModel.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/9/25.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTableViewCellModel.h"
#import "GYDLog.h"

@interface GYDLogTableViewCellModel : GYDTableViewCellModel<GYDLogItemModelProtocol>

/** LOG种类 */
@property (nonatomic)   NSString *type;
/** 级别 */
@property (nonatomic)   NSInteger lv;
/** 时间 */
@property (nonatomic)   NSDate *date;
/** 来自函数 */
@property (nonatomic)   const char *fun;
/** log内容 */
@property (nonatomic)   NSString *msg;

@property (nonatomic)   BOOL isFolded;

@property (nonatomic)   BOOL showFoldedButton;

- (NSMutableAttributedString *)attText;

@end
