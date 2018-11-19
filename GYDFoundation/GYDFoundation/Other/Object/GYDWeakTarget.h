//
//  GYDWeakTarget.h
//  FMDB
//
//  Created by 宫亚东 on 2018/11/19.
//

#import <Foundation/Foundation.h>

@interface GYDWeakTarget : NSObject

- (void)setWeakTarget:(id)target selector:(SEL)selector;

- (void)callOnceWithSelectorObject:(id)obj;

@end
