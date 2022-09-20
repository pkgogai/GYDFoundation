//
//  UIView+GYDDebugInfo.h
//  GYDFoundation
//
//  Created by gongyadong on 2022/6/30.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 注意：UI操作必须在主线程进行
 
 还可以继续hook label的settext，imageView的 setimage和sd_setxxxx，等记录对主要内容进行设置的代码。
 
 
 */
@interface UIView (GYDDebugInfo)

#pragma mark - 调试信息组装
/**
 创建信息\n
 属性信息\n
 其它信息
 */
@property (nonatomic, readonly, copy) NSString *gyd_debugDescription;

#pragma mark - 创建时的信息
@property (nonatomic, copy) NSString *gyd_createInfo;

/**
 替换和还原initWithFrame方法，
 还原的时候可能对别人替换initWithFrame方法产生干扰，所以要不要把还原去掉呢
 再三考虑，既然加了这个设置，那就不留后患，一旦替换了方法，就不再还原，只用个bool值记录状态。
 */
@property (nonatomic, class) BOOL gyd_recordCreateInfo;

+ (void)gyd_ignoreCreateInfoInBlock:(void(^)(void))block;

#pragma mark - 在其它视图中的属性名

@property (nonatomic, readonly, nonnull) NSMutableSet<NSString *> *gyd_propertyNames;

+ (void)gyd_updateSubviewPropertyNameForView:(UIView *)view;

#pragma mark - 自定义信息

/**
 如： "text:123"，"image:icon1"，"url:xxx"等
 不直接为UIImageView等类扩展，是方便别人想重写这个方法时还能调super，之后应该会把这个方法放到NSObject类别
 */
- (NSString *)gyd_otherDebugInfo;

@end

NS_ASSUME_NONNULL_END

