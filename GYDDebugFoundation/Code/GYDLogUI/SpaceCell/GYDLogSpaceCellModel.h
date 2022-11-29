//
//  GYDLogSpaceCellModel.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/25.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTableViewCellModel.h"
#import "GYDLog.h"

@interface GYDLogSpaceCellModel : GYDTableViewCellModel<GYDLogItemModelProtocol>

@property (nonatomic, nullable) UIColor *color;
@property (nonatomic) CGFloat height;

- (BOOL)shouldClick;
- (nullable NSString *)identifier;

#pragma mark - GYDLogItemModelProtocol
/** LOG种类 */
@property (nonatomic, nullable)   NSString *type;
/** 级别 */
@property (nonatomic)   NSInteger lv;
/** 时间 */
@property (nonatomic, nonnull)   NSDate *date;
/** 来自函数 */
@property (nonatomic, nonnull)   const char *fun;
/** log内容 */
@property (nonatomic, nullable)   NSString *msg;

@end
