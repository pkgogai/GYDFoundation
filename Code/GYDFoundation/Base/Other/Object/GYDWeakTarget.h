//
//  GYDWeakTarget.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/11/19.
//

#import <Foundation/Foundation.h>

@interface GYDWeakTarget : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic)       SEL selector;

@property (nonatomic, copy) void(^action)(id obj);
@property (nonatomic, assign)   id selectorObject;

- (void)setWeakTarget:(id)target selector:(SEL)selector;

- (void)callOnceWithSelectorObject:(id)obj;

- (void)callOnce;   //使用 self.selectorObject 调用

@end
