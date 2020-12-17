//
//  GYDShellTinifyFileItem.h
//  GYDFoundation
//
//  Created by gongyadong on 2020/12/17.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+GYDJSONObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellTinifyFileItem : NSObject

GYDJSONProperty(NSString *, name);

GYDJSONProperty(NSString *, path);

GYDJSONProperty(NSInteger, size);

GYDJSONProperty(NSString *, md5);

GYDJSONProperty(NSInteger, progress);

@end

NS_ASSUME_NONNULL_END
