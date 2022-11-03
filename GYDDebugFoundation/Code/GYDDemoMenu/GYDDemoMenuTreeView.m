//
//  GYDDemoMenuTreeView.m
//  GYDFoundation
//
//  Created by gongyadong on 2022/8/17.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDDemoMenuTreeView.h"
#import "GYDUIKit.h"
#import "GYDHorizontalTreeView.h"

@implementation GYDDemoMenuTreeView
{
    GYDHorizontalTreeView *_displayView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _displayView = [[GYDHorizontalTreeView alloc] initWithFrame:CGRectZero];
        [self addSubview:_displayView];
        [self updateMenus];
    }
    return self;
}

/*
 没测
 */
- (void)updateMenus {
    
    NSMutableDictionary<NSString *,NSMutableArray *> *menuDic = [GYDDemoMenu menuDictionary];
    NSMutableSet *allMenus = [NSMutableSet set];
    for (NSArray *arr in menuDic.allValues) {
        [allMenus addObjectsFromArray:arr];
    }
    
    GYDHorizontalTreeViewItem *root = [[GYDHorizontalTreeViewItem alloc] init];
    root.view = [self viewWithName:@"菜单" desc:nil];
    
    NSMutableDictionary *treeNoteDic = [NSMutableDictionary dictionary];
    treeNoteDic[GYDDemoMenuRootName] = root;
    
    NSMutableArray *enumArray = [NSMutableArray arrayWithObject:GYDDemoMenuRootName];
    while (enumArray.count) {
        NSString *name = enumArray[0];
        [enumArray removeObjectAtIndex:0];
        
        NSMutableArray *children = [NSMutableArray array];
        
        for (GYDDemoMenu *menu in [self sortMenus:menuDic[name]]) {
            NSString *subName = menu.name ?: @"";
            [allMenus removeObject:menu];
            GYDHorizontalTreeViewItem *item = [[GYDHorizontalTreeViewItem alloc] init];
            item.view = [self viewWithName:menu.name desc:menu.desc vcClass:menu.vcClass action:menu.action];
            
            [children addObject:item];
            
            if (!treeNoteDic[subName]) {
                treeNoteDic[subName] = item;
                [enumArray addObject:subName];
            }
        }
        GYDHorizontalTreeViewItem *supItem = treeNoteDic[name];
        supItem.children = children;
    }
    if (allMenus.count > 0) {
        GYDHorizontalTreeViewItem *other = [[GYDHorizontalTreeViewItem alloc] init];
        other.view = [self viewWithName:@"其它" desc:nil];
        NSMutableArray *otherChildren = [NSMutableArray array];
        
        for (GYDDemoMenu *menu in [self sortMenus:[allMenus allObjects]]) {
            GYDHorizontalTreeViewItem *item = [[GYDHorizontalTreeViewItem alloc] init];
            item.view = [self viewWithName:menu.name desc:menu.desc vcClass:menu.vcClass action:menu.action];
            [otherChildren addObject:item];
        }
        other.children = otherChildren;
        
        NSMutableArray *children = [root.children mutableCopy];
        if (!children) {
            children = [NSMutableArray array];
        }
        
        [children addObject:other];
        root.children = children;
    }
    
    _displayView.rootItem = root;
    [_displayView layoutAndChangeSize];
    _displayView.gyd_origin = CGPointMake(0, 0);
    self.contentSize = _displayView.gyd_size;
}

- (NSArray<GYDDemoMenu *> *)sortMenus:(NSArray<GYDDemoMenu *> *)menus {
    return [menus sortedArrayUsingComparator:^NSComparisonResult(GYDDemoMenu * _Nonnull obj1, GYDDemoMenu * _Nonnull obj2) {
        return obj2.order - obj1.order;
    }];
}

- (UIView *)viewWithName:(NSString *)name desc:(NSString *)desc {
    return [self viewWithName:name desc:desc vcClass:nil action:nil];
}
- (UIView *)viewWithName:(NSString *)name desc:(NSString *)desc vcClass:(Class)vcClass action:(void(^)(void))action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UILabel *nameLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentLeft;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label;
    });
    [button addSubview:nameLabel];
    
    UILabel *descLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentLeft;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label;
    });
    [button addSubview:descLabel];
    
    UILabel *classLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentLeft;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label;
    });
    [button addSubview:classLabel];
    
    nameLabel.text = name;
    descLabel.text = desc;
    classLabel.text = vcClass ? NSStringFromClass(vcClass) : @"";
    
    nameLabel.gyd_size = [nameLabel sizeThatFits:CGSizeMake(300, 0)];
    nameLabel.gyd_origin = CGPointMake(5, 5);
    descLabel.gyd_size = [descLabel sizeThatFits:CGSizeMake(300, 0)];
    descLabel.gyd_origin = CGPointMake(5, nameLabel.gyd_bottomY);
    classLabel.gyd_size = [classLabel sizeThatFits:CGSizeMake(300, 0)];
    classLabel.gyd_origin = CGPointMake(5, descLabel.gyd_bottomY);
    
    button.gyd_size = CGSizeMake(MAX(MAX(nameLabel.gyd_width, descLabel.gyd_width), classLabel.gyd_width) + 10, classLabel.gyd_bottomY + 5);
    
    static UIImage *vcImage = nil;
    static UIImage *actionImage = nil;
    static UIImage *disableImage = nil;
    if (!vcImage) {
        vcImage = [[UIImage gyd_imageWithRectWidth:5 height:5 cornerRadius:1 borderColor:[UIColor grayColor] fillColor:GYDColorRGB(99ff99) lineWidth:1 dashWidth:0 dashClearWidth:0] gyd_stretchableImageFromCenter];
        actionImage = [[UIImage gyd_imageWithRectWidth:5 height:5 cornerRadius:1 borderColor:[UIColor grayColor] fillColor:GYDColorRGB(99ffff) lineWidth:1 dashWidth:0 dashClearWidth:0] gyd_stretchableImageFromCenter];
        disableImage = [[UIImage gyd_imageWithRectWidth:5 height:5 cornerRadius:1 borderColor:[UIColor grayColor] fillColor:nil lineWidth:1 dashWidth:0 dashClearWidth:0] gyd_stretchableImageFromCenter];
    }
    //是否考虑view
    if (action) {
        [button gyd_setClickActionBlock:^(UIButton * _Nonnull button) {
            action();
        }];
        [button setBackgroundImage:actionImage forState:UIControlStateNormal];
    } else if ([vcClass isSubclassOfClass:[UIViewController class]]) {
        [button gyd_setClickActionBlock:^(UIButton * _Nonnull button) {
            UIViewController *vc = [[vcClass alloc] init];
            [UINavigationController gyd_pushViewController:vc animated:YES];
        }];
        [button setBackgroundImage:vcImage forState:UIControlStateNormal];
    } else if ([vcClass isSubclassOfClass:[UIView class]]) {
        [button gyd_setClickActionBlock:^(UIButton * _Nonnull button) {
            UIViewController *vc = [[GYDViewController alloc] init];
            vc.view = [[vcClass alloc] initWithFrame:CGRectZero];
            [UINavigationController gyd_pushViewController:vc animated:YES];
        }];
        [button setBackgroundImage:vcImage forState:UIControlStateNormal];
    } else {
        [button setBackgroundImage:disableImage forState:UIControlStateNormal];
    }
    
    return button;
}



@end
