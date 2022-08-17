//
//  GYDDebugViewTipsDisplayViewModel.h
//  GYDDevelopment
//
//  Created by gongyadong on 2020/12/30.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDDebugViewTipsShape.h"

NS_ASSUME_NONNULL_BEGIN
/**
 给视图做出提示所用的数据。
 */
@interface GYDDebugViewTipsDisplayViewModel : NSObject

#pragma mark - 外部赋值

/** 提示语view，size有效，坐标内部会进行调整 */
@property (nonatomic) UIView *tipsView;

/**
 目标view，提示语跟着这个view走。
 
 想要跟踪，目前只能在trackView对应的window上创建一个隐藏的view，
 用mas建立约束，让view和trackView屏幕坐标一致，
 然后KVO监听view的frame，center，bounds来实时获取坐标变化。
 还没想到更好的方法，所以干脆更暴力一点，用displayLink每次都计算。
 */
@property (nonatomic, weak) UIView *trackView;
/** 目标位置（优先使用trackView，trackView无值才用这个） */
@property (nonatomic) CGRect locationRect;

/** 颜色，这里给RGB颜色，内部根据情况处理透明度 */
@property (nonatomic) uint32_t colorRGBValue;

#pragma mark - 内部处理

/** 内部计算的提示语应该出现的位置中心点 */
@property (nonatomic) CGPoint tipsCenter;

/** 有个动画效果 */
- (void)tipsAnimateToCenter:(CGPoint)tipsCenter;
/** 这个是动画中的实时位置，需要动画的话，displayLink中取这个值，没有动画或动画停止后值是tipsRect */
@property (nonatomic, readonly) CGPoint tipsAnimateCenter;

/** 根据缩放、移动等数据处理的最终图形 */
@property (nonatomic) GYDDebugViewTipsShape *shape;


@end

NS_ASSUME_NONNULL_END
