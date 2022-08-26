//
//  GYDDebugUnreadCountRootView.m
//  GYDDevelopment
//
//  Created by gongyadong on 2021/3/30.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDDebugUnreadCountRootView.h"
#import "GYDHorizontalTreeView.h"
#import "GYDDebugUnreadCountTreeViewItem.h"
#import "GYDUIKit.h"

@implementation GYDDebugUnreadCountRootView
{
    GYDHorizontalTreeView *_displayView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentInset = UIEdgeInsetsMake(60, 60, 60, 60);
        _displayView = [[GYDHorizontalTreeView alloc] initWithFrame:CGRectZero];
        _displayView.lineColor = [UIColor grayColor];
        _displayView.backgroundColor = [UIColor clearColor];
        [self addSubview:_displayView];
    }
    return self;
}

- (void)setWhiteStyle:(BOOL)whiteStyle {
    _whiteStyle = whiteStyle;
    _displayView.lineColor = _whiteStyle ? [UIColor whiteColor] : [UIColor grayColor];
}

- (void)updateWithUnreadCountManager:(GYDUnreadCountManager *)manager {
    [self gyd_defaultNotificationCenterRemoveObserver];
    __weak typeof(self) weakSelf = self;
    [self gyd_unreadCountAddNotificationForType:nil manager:manager callNow:NO action:^(GYDUnreadCountManagerActionParameter arg) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf updateWithUnreadCountManager:manager];
    }];
    NSMutableDictionary<NSString *, NSMutableSet *> *superTypes = manager->_superTypes;
    NSMutableDictionary<NSString *, NSMutableSet *> *subTypes = manager->_subTypes;
    NSMutableDictionary<NSString *, NSNumber *> *values = manager->_values;
    
    //收集所有用到的类型
    NSMutableSet *allTypes = [NSMutableSet set];
    
    if (superTypes.count) {
        [allTypes addObjectsFromArray:superTypes.allKeys];
    }
    if (subTypes.count) {
        [allTypes addObjectsFromArray:subTypes.allKeys];
    }
    if (values.count) {
        [allTypes addObjectsFromArray:values.allKeys];
    }
    
    
    /*
     遍历每一个节点，并拼接层级关系。
     在处理的过程中，使用 headTypes 随时记录所有头部节点，使用 tailTypes 随时记录所有尾部节点。
     */
    
    NSMutableDictionary<NSString *, GYDDebugUnreadCountTreeViewItem *> *headTypes = [NSMutableDictionary dictionary];
    NSMutableDictionary<NSString *, GYDDebugUnreadCountTreeViewItem *> *tailTypes = [NSMutableDictionary dictionary];
    
    while (allTypes.count > 0) {
        NSString *type = [allTypes anyObject];
        [allTypes removeObject:type];
        GYDDebugUnreadCountTreeViewItem *item = tailTypes[type];
        if (item) {
            tailTypes[type] = nil;
        } else {
            item = [GYDDebugUnreadCountTreeViewItem viewItemWithManager:manager type:type];
            headTypes[type] = item;
        }
        
        NSMutableArray *list = [NSMutableArray array];
        for (NSString *subType in subTypes[type]) {
            GYDDebugUnreadCountTreeViewItem *subItem = headTypes[subType];
            if (subItem && ![self isViewItem:item contentHeadItem:subItem]) {
                headTypes[subType] = nil;
            } else {
                subItem = [GYDDebugUnreadCountTreeViewItem viewItemWithManager:manager type:subType];
                tailTypes[subType] = subItem;
            }
            [list addObject:subItem];
            subItem.superItem = item;
        }
        item.children = list;
    }
    //创建个根节点
    GYDDebugUnreadCountTreeViewItem *root = [GYDDebugUnreadCountTreeViewItem viewItemWithManager:nil type:@"红点"];
    root.children = [headTypes allValues];
    _displayView.rootItem = root;
    [_displayView layoutAndChangeSize];
    _displayView.gyd_origin = CGPointMake(0, 0);
    self.contentSize = _displayView.frame.size;
}


//用于上面方法中检查是否发生循环。
- (BOOL)isViewItem:(GYDDebugUnreadCountTreeViewItem *)item contentHeadItem:(GYDDebugUnreadCountTreeViewItem *)head {
    while (item) {
        if (item.superItem == head) {
            return YES;
        }
        item = item.superItem;
    }
    return NO;
}


@end
