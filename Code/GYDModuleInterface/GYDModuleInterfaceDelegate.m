//
//  GYDModuleInterfaceDelegate.m
//  GYDDevelopment
//
//  Created by gongyadong on 2019/6/9.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDModuleInterfaceDelegate.h"
#import "GYDFoundationPrivateHeader.h"

@implementation GYDModuleInterfaceDelegate
{
    NSString *_interfaceName;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _interfaceName = NSStringFromClass([self class]);
    }
    return self;
}

- (instancetype)initWithInterfaceName:(NSString *)interfaceName {
    self = [super init];
    if (self) {
        _interfaceName = interfaceName ?: NSStringFromClass([self class]);
    }
    return self;
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    GYDFoundationError(@"[接口缺少方法实现] %@ %@", _interfaceName, NSStringFromSelector(anInvocation.selector));
}

@end
