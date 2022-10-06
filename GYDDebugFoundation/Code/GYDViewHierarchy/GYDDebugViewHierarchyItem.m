//
//  GYDDebugViewHierarchyItem.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/08/09.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDDebugViewHierarchyItem.h"
#import "GYDDebugWindow.h"
#import "GYDFoundationPrivateHeader.h"
#import "UIImage+GYDImage.h"
#import "UIView+GYDDebugInfo.h"

@implementation GYDDebugViewHierarchyItem

/** 获取指定view的视图层级 */
+ (instancetype)rootItemWithViewArray:(NSArray<UIView *> *)viewArray {
    GYDDebugViewHierarchyItem *root = [[self alloc] init];
    [UIView gyd_ignoreCreateInfoInBlock:^{
        for (UIView *view in viewArray) {
            if (view.hidden) {
                continue;
            }
            if (view.alpha < 0.01) {
                continue;
            }
            if (view.frame.size.width == 0 && view.frame.size.height == 0) {
                continue;
            }
            GYDDebugViewHierarchyItem *item = [self itemWithView:view];
            if (!root.childItems) {
                root.childItems = [NSMutableArray array];
            }
            [root.childItems addObject:item];
            item.parentItem = root;
        }
    }];
    return root;
}


+ (instancetype)itemWithView:(UIView *)view {
    
    NSInteger orderNumber = 0;
    
    GYDDebugViewHierarchyItem *item = [[self alloc] init];
    item.orderNumber = orderNumber++;
    [item updateWithView:view];
    
    NSMutableArray *viewArray = [NSMutableArray arrayWithObject:view];
    NSMutableArray *itemArray = [NSMutableArray arrayWithObject:item];
    
    while (viewArray.count > 0) {
        UIView *view = viewArray[0];
        [viewArray removeObjectAtIndex:0];
        GYDDebugViewHierarchyItem *item = itemArray[0];
        [itemArray removeObjectAtIndex:0];
        
        for (UIView *subview in view.subviews) {
            
            GYDDebugViewHierarchyItem *subItem = [[self alloc] init];
            subItem.parentItem = item;
            subItem.orderNumber = orderNumber++;
            if (subview.hidden) {
                subItem.isHidden = YES;
            }
            if (subview.alpha < 0.01) {
                subItem.isHidden = YES;
            }
//            if (subview.frame.size.width == 0 && subview.frame.size.height == 0) {
//                subItem.isHidden = YES;
//            }
            if (!item.childItems) {
                item.childItems = [NSMutableArray array];
            }
            [item.childItems addObject:subItem];
            
            [subItem updateWithView:subview];
            if (subview.subviews.count > 0) {
                [viewArray addObject:subview];
                [itemArray addObject:subItem];
            }
        }
    }
    
    return item;
}



- (void)updateWithView:(UIView *)view {
    
    self.targetView = view;
    
    CGRect frame = view.bounds;
    UIScreen *screen = [UIScreen mainScreen];
//    frame = [view convertRect:frame toView:view.window];
    frame = [view convertRect:frame toCoordinateSpace:screen.coordinateSpace];
    self.viewFrame = frame;
    self.viewClass = NSStringFromClass([view class]);
    if ([view.nextResponder isKindOfClass:[UIViewController class]]) {
        self.viewControllerClass = NSStringFromClass(view.nextResponder.class);
    }
    self.viewDesc = view.gyd_debugDescription;// [view description];
    
    CGSize windowSize = screen.bounds.size;
    
    if (frame.origin.x + frame.size.width > windowSize.width) {
        frame.size.width = windowSize.width - frame.origin.x;
    }
    if (frame.origin.x < 0) {
        frame.size.width += frame.origin.x;
        frame.origin.x = - frame.origin.x;
    } else {
        frame.origin.x = 0;
    }
    
    if (frame.origin.y + frame.size.height > windowSize.height) {
        frame.size.height = windowSize.height - frame.origin.y;
    }
    if (frame.origin.y < 0) {
        frame.size.height += frame.origin.y;
        frame.origin.y = - frame.origin.y;
    } else {
        frame.origin.y = 0;
    }
    /*
     拉伸、旋转等会影响frame，这样截图有问题，还得反过来处理一下坐标
     */
    self.imageFrame = frame;

    self.displayView = [[GYDDebugViewHierarchyItemView alloc] initWithFrame:CGRectZero];
    self.displayView.model = self;
//    self.displayView.backgroundColor = view.backgroundColor;
    
    GYDDebugViewHierarchyItemConfig *config = [[GYDDebugViewHierarchyItemConfig alloc] init];
    config.showFrame = NO;
    config.showBorderLine = YES;
    config.showDesc = NO;
    config.showClass = YES;
//    if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[UITextField class]]) {
//        config.showImage = YES;
//    }
    config.showImage = YES;
    self.displayConfig = config;
    
    [self.displayView updateConfig];
}

/** 重置视图的显隐 */
- (void)resetHiddenItemsShowIgnoreView:(BOOL)showIgnore showHiddenView:(BOOL)showHidden isSuperViewHidden:(BOOL)isSuperViewHidden ignoreClassNameSet:(NSSet<NSString *> *)ignoreClassNameArray {
    
    for (GYDDebugViewHierarchyItem *item in self.childItems) {
        BOOL show = YES;
        BOOL superHidden = isSuperViewHidden;
        if (isSuperViewHidden) {
            show = NO;
        }
        if (show && !showHidden) {
            if (item.isHidden) {
                show = NO;
                superHidden = YES;
            }
        }
        if (show && !showIgnore) {
            show = ![ignoreClassNameArray containsObject:item.viewClass];
//            if (delegate) {
//                [delegate view:item.targetView defaultIgnore:&show];
//            }
        }
        item.displayConfig.show = show;
        item.level = self.level + (show ? 1 : 0);
        if (item.childItems.count) {
            [item resetHiddenItemsShowIgnoreView:showIgnore showHiddenView:showHidden isSuperViewHidden:superHidden ignoreClassNameSet:ignoreClassNameArray];
        }
    }
}

/** 加载图片，这个比较耗时，改为延后 */
- (void)asyncLoadImageWithIgnoreClassNameSet:(NSSet<NSString *> *)ignoreClassNameArray {
    NSMutableArray<GYDDebugViewHierarchyItem *> *arr = [self.childItems mutableCopy];
    @autoreleasepool {
        for (NSInteger i = 0; i < arr.count ; i++) {
            NSMutableArray *subArr = arr[i].childItems;
            if (subArr.count > 0) {
                [arr addObjectsFromArray:subArr];
            }
        }
    }

    CGFloat scale = [UIScreen mainScreen].scale;
    if (scale > 2) {
        scale = 2;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (arr.count > 0) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                for (NSInteger i = 0; arr.count > 0 && i < 20; i++) {
                    @autoreleasepool {
                        GYDDebugViewHierarchyItem *item = arr[0];
                        [arr removeObjectAtIndex:0];
                        UIView *view = item.targetView;
                        if (!view) {
                            continue;
                        }
                        CGRect frame = item.imageFrame;
                        if (frame.size.width > 0 && frame.size.height > 0) {
                            
                            
                            BOOL viewHidden = view.hidden;
                            CGFloat viewAlpha = view.alpha;
                            if (viewHidden) {
                                view.hidden = NO;
                            }
                            if (viewAlpha < 1) {
                                view.alpha = 1;
                            }
                            item.viewCompleteImage = [UIImage gyd_imageWithView:view scale:scale rect:frame];
                            
                            NSMutableArray *subViews = [NSMutableArray array];
                            for (UIView *sub in view.subviews) {
                                if (sub.hidden) {
                                    continue;
                                }
                                if ([ignoreClassNameArray containsObject:NSStringFromClass(sub.class)]) {
                                    continue;
                                }
                                sub.hidden = YES;
                                [subViews addObject:sub];
                            }
                            item.viewPartImage = [UIImage gyd_imageWithView:view scale:scale rect:frame];
                            for (UIView *sub in subViews) {
                                sub.hidden = NO;
                            }
                            if (viewHidden) {
                                view.hidden = YES;
                            }
                            if (viewAlpha < 1) {
                                view.alpha = viewAlpha;
                            }
                            [item.displayView updateImage];
                        }
                    }
                }
            });
        }
    });
}

/** 并重新调整层级 */
- (NSInteger)resetViewHierarchyReturnTopLevel {
    NSArray<GYDDebugViewHierarchyItem *> *childItems = self.childItems;
    NSInteger level = self.hierarchyIndex;
    NSInteger maxLevel = level;
    NSInteger intersectionIndex = 0;
    
    NSMutableArray<GYDDebugViewHierarchyItem *> *leftItems = [self.childItems mutableCopy];
    while (leftItems.count > 0) {
        NSMutableArray<GYDDebugViewHierarchyItem *> *compareItems = [NSMutableArray array];
        for (NSInteger i = 0; i < leftItems.count; i++) {
            GYDDebugViewHierarchyItem *item = leftItems[i];
            if (!item.displayConfig.show) {
                item.hierarchyIndex = level;
                [leftItems removeObjectAtIndex:i];
                i--;
                [compareItems addObject:item];
            } else {
                CGRect frame = item.viewFrame;
                BOOL intersection = NO;
                for (GYDDebugViewHierarchyItem *compare in compareItems) {
                    CGRect tmpFrame = compare.viewFrame;
                    
                    if (CGRectGetMinX(frame) >= CGRectGetMaxX(tmpFrame) && CGRectGetMaxX(frame) > CGRectGetMaxX(tmpFrame)) {
                        continue;
                    }
                    if (CGRectGetMinY(frame) >= CGRectGetMaxY(tmpFrame) && CGRectGetMaxY(frame) > CGRectGetMaxY(tmpFrame)) {
                        continue;
                    }
                    if (CGRectGetMinX(tmpFrame) >= CGRectGetMaxX(frame) && CGRectGetMaxX(tmpFrame) > CGRectGetMaxX(frame)) {
                        continue;
                    }
                    if (CGRectGetMinY(tmpFrame) >= CGRectGetMaxY(frame) && CGRectGetMaxY(tmpFrame) > CGRectGetMaxY(frame)) {
                        continue;
                    }
                    intersection = YES;
                    break;
                }
                if (intersection) {
                    continue;
                }
                item.hierarchyIndex = level + 1;
                [leftItems removeObjectAtIndex:i];
                i--;
                [compareItems addObject:item];
            }

            NSInteger topLevel = [item resetViewHierarchyReturnTopLevel];
            if (topLevel > maxLevel) {
                maxLevel = topLevel;
            }
        }
        level = maxLevel;
    }
    return maxLevel;
}

- (void)enumerateChildItemsUsingBlock:(void (^)(GYDDebugViewHierarchyItem *item, BOOL *stop))block {
    
    NSMutableArray *arr = [self.childItems mutableCopy];
    BOOL stop = NO;
    while (arr.count > 0 && !stop) {
        GYDDebugViewHierarchyItem *item = arr[0];
        [arr removeObjectAtIndex:0];
        block(item, &stop);
        if (stop) {
            return;
        }
        if (item.childItems) {
            [arr addObjectsFromArray:item.childItems];
        }
    }
}

- (NSDictionary<NSString *, NSNumber *> *)viewClassCount {
    NSMutableDictionary<NSString *, NSNumber *> *viewCount = [NSMutableDictionary dictionary];
    [self enumerateChildItemsUsingBlock:^(GYDDebugViewHierarchyItem * _Nonnull item, BOOL * _Nonnull stop) {
        viewCount[item.viewClass] = @([viewCount[item.viewClass] integerValue] + 1);
        if (item.viewControllerClass.length > 0) {
            viewCount[item.viewControllerClass] = @([viewCount[item.viewControllerClass] integerValue] + 1);
        }
    }];
    return viewCount;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", self.viewClass, NSStringFromCGRect(self.viewFrame)];
}
- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@ %@", self.viewClass, NSStringFromCGRect(self.viewFrame)];
}


@end
