//
//  GYDDemoMenu.h
//  GYDDevelopment
//
//  Created by gongyadong on 2020/12/24.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const GYDDemoMenuRootName; //根

extern NSString * const GYDDemoMenuOtherName; //没归类的菜单

/**
 demo的菜单项
 每个菜单项都要调用addToMenu:添加到菜单树中，可以重名，可以添加到多个位置。
 最终从root菜单项开始检索，所有无法检索到的都放到other菜单下。
 如：
 a addTo b
 a addTo c
 b addTo root
 则最终菜单效果：
 root > b > a
 other > c > a
 */
@interface GYDDemoMenu : NSObject

@property (nonatomic, nonnull)  NSString *name;

@property (nonatomic, nullable) NSString *desc;

/* 排序依据，大的在前 */
@property (nonatomic) double order;

/** 点击处理，没有则检查vcClass */
@property (nonatomic, nullable) void(^action)(void);

/** 在action=nil的情况下，点击时有vcClass值则弹出vc，没值则当做目录 */
@property (nonatomic, nullable) Class vcClass;

+ (instancetype)menuWithName:(NSString *)name desc:(nullable NSString *)desc order:(double)order;

/**  */
+ (instancetype)menuWithName:(NSString *)name desc:(nullable NSString *)desc order:(double)order vcClass:(nullable Class)vcClass;

/** 任何一个菜单项都要添加到一个菜单之下，最终无法从root菜单检索到的都放到other菜单下 */
- (void)addToMenu:(NSString *)menu;

- (NSArray *)chirdren;

/** other菜单使用 */
+ (NSArray<NSString *> *)unusedMenuNames;

/** 方便调试 */
@property (nonatomic, class, nullable) NSMutableDictionary<NSString *, NSMutableArray *> *menuDictionary;

@end

NS_ASSUME_NONNULL_END
