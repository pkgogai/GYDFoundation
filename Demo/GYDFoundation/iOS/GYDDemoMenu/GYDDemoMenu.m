//
//  GYDDemoMenu.m
//  GYDDevelopment
//
//  Created by gongyadong on 2020/12/24.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDDemoMenu.h"

NSString * const GYDDemoMenuRootName = @"Root";
NSString * const GYDDemoMenuOtherName = @"other";

@implementation GYDDemoMenu

+ (instancetype)menuWithName:(NSString *)name desc:(NSString *)desc order:(double)order {
    GYDDemoMenu *menu = [[GYDDemoMenu alloc] init];
    menu.name = name;
    menu.desc = desc;
    menu.order = order;
    return menu;
}

+ (instancetype)menuWithName:(NSString *)name desc:(NSString *)desc order:(double)order vcClass:(Class)vcClass {
    GYDDemoMenu *menu = [[GYDDemoMenu alloc] init];
    menu.name = name;
    menu.desc = desc;
    menu.order = order;
    menu.vcClass = vcClass;
    return menu;
}

static NSMutableDictionary<NSString *, NSMutableArray *> *demoMenuDic = nil;

- (void)addToMenu:(NSString *)menu {
    if (!menu) {
        menu = @"";
    }
    NSMutableArray *arr = demoMenuDic[menu];
    if (!arr) {
        if (!demoMenuDic) {
            demoMenuDic = [[NSMutableDictionary alloc] init];
        }
        arr = [[NSMutableArray alloc] init];
        demoMenuDic[menu] = arr;
    }
    [arr addObject:self];
}

- (NSArray *)chirdren {
    return demoMenuDic[self.name ?: @""];
}

+ (NSArray<NSString *> *)unusedMenuNames {
    if (!demoMenuDic) {
        return @[];
    }
    NSMutableSet *used = [NSMutableSet set];
    NSMutableArray *enumArray = [demoMenuDic[GYDDemoMenuRootName] mutableCopy];
    while (enumArray.count) {
        GYDDemoMenu *m = enumArray[0];
        [enumArray removeObjectAtIndex:0];
        NSString *name = m.name ?: @"";
        if ([used containsObject:name]) {
            continue;
        }
        [used addObject:name];
        
        NSArray *sub = demoMenuDic[name];
        if (sub) {
            [enumArray addObjectsFromArray:sub];
        }
    }
    NSMutableSet *all = [NSMutableSet setWithArray:demoMenuDic.allKeys];
    [all minusSet:used];
    
    return all.allObjects;
}

+ (void)setMenuDictionary:(NSMutableDictionary<NSString *,NSMutableArray *> *)menuDictionary {
    demoMenuDic = menuDictionary;
}
+ (NSMutableDictionary<NSString *,NSMutableArray *> *)menuDictionary {
    return demoMenuDic;
}

@end

