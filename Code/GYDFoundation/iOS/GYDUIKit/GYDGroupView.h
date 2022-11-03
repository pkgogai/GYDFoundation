//
//  GYDGroupView.h
//  GYDFoundation
//
//  Created by gongyadong on 2022/11/3.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 本身不响应事件，而子view可正常响应事件。
 为了方便给view分组，可以把一组view加到同一个父view上处理，然后父view本身不响应事件，就成了这个view
 */
@interface GYDGroupView : UIView

@end

NS_ASSUME_NONNULL_END
