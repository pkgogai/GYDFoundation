//
//  GYDDebugViewHierarchySelectView.h
//  GYDFoundation
//
//  Created by gongyadong on 2022/7/4.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYDDebugViewHierarchySelectView : UIView

@property (nonatomic, readonly) CGRect selectFrame;

- (void)setTarget:(id)target selectAction:(SEL)action;

@end

NS_ASSUME_NONNULL_END
