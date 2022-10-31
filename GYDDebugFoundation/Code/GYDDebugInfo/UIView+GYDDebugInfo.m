//
//  UIView+GYDDebugInfo.m
//  GYDFoundation
//
//  Created by gongyadong on 2022/6/30.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "UIView+GYDDebugInfo.h"
#import <objc/runtime.h>
#include "gyd_class_property.h"
#import <execinfo.h>
#import "GYDFoundationPrivateHeader.h"
#import "UIImage+GYDDebugInfo.h"

@implementation UIView (GYDDebugInfo)

#pragma mark - 调试信息组装

- (NSString *)gyd_debugDescription {
    NSMutableString *desc = [NSMutableString stringWithString:self.gyd_createInfo ?: @""];
    for (NSString *name in self.gyd_propertyNames) {
        if (desc.length > 0) {
            [desc appendString:@"\n"];
        }
        [desc appendString:name];
    }
    NSString *other = [self gyd_otherDebugInfo];
    if (other.length > 0) {
        if (desc.length > 0) {
            [desc appendString:@"\n"];
        }
        [desc appendString:other];
    }
    return desc;
}


#pragma mark - 创建时的信息
static char CreateInfoKey;
- (void)setGyd_createInfo:(NSString *)gyd_createInfo {
    objc_setAssociatedObject(self, &CreateInfoKey, gyd_createInfo, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)gyd_createInfo {
    return objc_getAssociatedObject(self, &CreateInfoKey);
}


static BOOL RecordCreateInfo = NO;
+ (void)setGyd_recordCreateInfo:(BOOL)gyd_recordCreateInfo {
    RecordCreateInfo = gyd_recordCreateInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gyd_exchangeSelector(self, @selector(initWithFrame:), self, @selector(initWithFrame_GYDDebugInfo:));
    });
}
+ (BOOL)gyd_recordCreateInfo {
    return RecordCreateInfo;
}


static NSInteger ignoreIndex = 0;
+ (void)gyd_ignoreCreateInfoInBlock:(void (^)(void))block {
    NSInteger lastIndex = ignoreIndex;
    ignoreIndex ++;
    block();
    ignoreIndex --;
    if (lastIndex != ignoreIndex) {
        GYDFoundationError(@"在非UI线程用过？");
    }
}


- (instancetype)initWithFrame_GYDDebugInfo:(CGRect)frame {
    UIView *view = [self initWithFrame_GYDDebugInfo:frame];
    if (!RecordCreateInfo || ignoreIndex > 0) {
        return view;
    }
    NSString *selfClass = NSStringFromClass([self class]);
    int length = 8;
    void *          callstack[length];
    int             frames    = backtrace(callstack, length);
    char **         strs      = backtrace_symbols(callstack, frames);
    for (int i = 1; i < frames; i++) {
//        printf("%d:%s\n", i, strs[i]);
        char *p1 = strstr(strs[i], "[");
        if (!p1) {
            continue;
        }
        p1++;
        char *leftParenthesis = strstr(p1, "(");
        char *space = strstr(p1, " ");
        char *p2 = strstr(p1, "]");
        if (!space) {
            continue;
        }
        if (!p2) {
            continue;
        }
        NSString *className = [NSString gyd_stringWithCString:p1 length:(leftParenthesis ?: space) - p1];
        
        if (isClassFamily(selfClass, className)) {
            continue;
        }
        view.gyd_createInfo = [NSString gyd_stringWithCString:p1 length:p2 - p1];
        break;
    }
    free(strs);
    return view;
}

static BOOL isClassFamily(NSString *c, NSString *f) {
    static NSMutableDictionary *dic = nil;
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
    }
    NSMutableSet *set = dic[c];
    if (!set) {
        set = [NSMutableSet set];
        dic[c] = set;
        Class cls = NSClassFromString(c);
        while (cls != NULL) {
            [set addObject:NSStringFromClass(cls)];
            cls = class_getSuperclass(cls);
        }
    }
    return [set containsObject:f];
}


#pragma mark - 在其它视图中的属性名

- (NSMutableSet<NSString *> *)gyd_propertyNames {
    static char PropertyNameKey;
    NSMutableSet *set = objc_getAssociatedObject(self, &PropertyNameKey);
    if (!set) {
        set = [NSMutableSet set];
        objc_setAssociatedObject(self, &PropertyNameKey, set, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return set;
}

+ (void)gyd_updateSubviewPropertyNameForView:(UIView *)view {
    NSMutableDictionary *classIvarNameDic = [NSMutableDictionary dictionary];
    
    NSMutableArray *viewArray = [NSMutableArray arrayWithObject:view];
    while (viewArray.count > 0) {
        UIView *view = viewArray[0];
        [viewArray removeObjectAtIndex:0];
        
        if (view.subviews.count > 0) {
            [viewArray addObjectsFromArray:view.subviews];
        }
        
        updateViewPropertyName(view, classIvarNameDic);
        
        if ([view.nextResponder isKindOfClass:[UIViewController class]]) {
            updateViewPropertyName(view.nextResponder, classIvarNameDic);
        }
        
    }
}

static void updateViewPropertyName(NSObject *view, NSMutableDictionary<NSString *, NSMutableSet *> *classIvarNameDic) {
    NSString *className = NSStringFromClass(view.class);
    NSMutableSet *ivarNameSet = classIvarNameDic[className];
    if (!ivarNameSet) {
        ivarNameSet = [NSMutableSet set];
        classIvarNameDic[className] = ivarNameSet;
        enumerateIvarName(view.class, ^(const char * _Nonnull name) {
            if (strcmp(name, "_placeholderLabel") == 0) {
                return;
            }
            [ivarNameSet addObject:[NSString stringWithUTF8String:name]];
        });
    }
    for (NSString *key in ivarNameSet) {
        UIView *subView = [view valueForKey:key];
        if ([subView isKindOfClass:[UIView class]]) {
            NSMutableSet *names = subView.gyd_propertyNames;
            if (names.count < 5) {
                [names addObject:[NSString stringWithFormat:@"%@ > %@", className, key]];
            }
        }
    }
}

/** 遍历本类的所有成员变量名 */
static void enumerateIvarName(Class _Nonnull c, void (^ _Nonnull block)(const char * _Nonnull name)) {
    if (!block) {
        return;
    }
    unsigned int count = 0;
    Ivar *list = class_copyIvarList(c, &count);
    for (int i = 0; i < count; i++) {
        const char *type = ivar_getTypeEncoding(list[i]);
        if (type[0] != '@') {
            continue;
        }
        block(ivar_getName(list[i]));
    }
    if (list) {
        free(list);
    }
    if (c == [UIView class]) {
        return;
    }
    
    Class superClass = class_getSuperclass(c);
    if (superClass) {
        enumerateIvarName(superClass, block);
    }
}

#pragma mark - 自定义信息

- (NSString *)gyd_otherDebugInfo {
    NSString *other = nil;
    NSString *title = nil;
    if ([self isKindOfClass:[UILabel class]]) { //label
        other = [(UILabel *)self text];
        if (other.length > 20) {
            other = [[other substringWithRange:NSMakeRange(0, 20)] stringByAppendingString:@"..."];
        }
        title = @"text:";
    } else if ([self isKindOfClass:[UIButton class]]) { //button
        other = [(UIButton *)self titleForState:((UIButton *)self).state];
        title = @"titile:";
    } else if ([self isKindOfClass:[UIImageView class]]) {
        other = ((UIImageView *)self).image.gyd_imageName;
        title = @"image:";
    }
    if (other.length > 0) {
        return [title stringByAppendingString:other];
    }
    return nil;
}

@end


//@interface NSObject (GYDDebugInfo)
//
//
//
//
//@end
//@implementation NSObject (GYDDebugInfo)
//
//- (id)valueForUndefinedKey:(NSString *)key {
//    return nil;
//}
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    return;
//}
//
//@end
