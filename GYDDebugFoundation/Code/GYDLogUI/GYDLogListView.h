//
//  GYDLogListView.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/24.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYDLogListView : UIView

///** 是否隐藏详情级别的log */
//@property (nonatomic)   BOOL isLowLvLogHidden;

/** 初始化 */
- (instancetype)initWithFrame:(CGRect)frame;

/** 清空界面上的数据 */
- (void)clearData;

- (void)addLine;

/** 完整数据<GYDLogItemModelProtocol> */
- (NSMutableArray *)allData;

/** 筛选值 */
@property (nonatomic, readwrite)    NSArray *filterArray;

/** 是否是折叠的 */
@property (nonatomic)   BOOL isFolded;

/** 是否可交互 */
@property (nonatomic)   BOOL isLogInterfaceEnable;

@end
