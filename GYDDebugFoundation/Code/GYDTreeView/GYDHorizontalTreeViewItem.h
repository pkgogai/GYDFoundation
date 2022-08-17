//
//  GYDHorizontalTreeViewItem.h
//  GYDDevelopment
//
//  Created by gongyadong on 2021/3/31.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYDHorizontalTreeViewItem : NSObject

/**  */
@property (nonatomic, copy) NSArray<GYDHorizontalTreeViewItem *> *children;

@property (nonatomic, strong) UIView *view;

@end

NS_ASSUME_NONNULL_END
