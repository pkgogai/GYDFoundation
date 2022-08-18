//
//  GYDHorizontalTreeViewDemoViewController.m
//  GYDDebugFoundation
//
//  Created by gongyadong on 2022/8/5.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDHorizontalTreeViewDemoViewController.h"
#import "GYDHorizontalTreeView.h"
#import "UIView+GYDFrame.h"
#import "GYDDemoMenu.h"

@interface GYDHorizontalTreeViewDemoViewController ()

@end

@implementation GYDHorizontalTreeViewDemoViewController
{
    UIScrollView *_scrollView;
}

+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"HorizontalTree" desc:@"横过来的树型结构图" order:80 vcClass:self];
    [menu addToMenu:GYDDemoMenuRootName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.contentInset = UIEdgeInsetsMake(60, 60, 60, 60);
    [self.view addSubview:_scrollView];
    
    GYDHorizontalTreeView *view = [[GYDHorizontalTreeView alloc] initWithFrame:CGRectZero];
    
    [_scrollView addSubview:view];
    
    GYDHorizontalTreeViewItem *root = ({
        GYDHorizontalTreeViewItem *item = [[GYDHorizontalTreeViewItem alloc] init];
        item.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        item.view.backgroundColor = [UIColor redColor];
        item;
    });
    
    root.children = @[
        ({
            GYDHorizontalTreeViewItem *item = [[GYDHorizontalTreeViewItem alloc] init];
            item.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
            item.view.backgroundColor = [UIColor blueColor];
            item;
        }),
        ({
            GYDHorizontalTreeViewItem *item = [[GYDHorizontalTreeViewItem alloc] init];
            item.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
            item.view.backgroundColor = [UIColor grayColor];
            item.children = @[
                ({
                    GYDHorizontalTreeViewItem *item = [[GYDHorizontalTreeViewItem alloc] init];
                    item.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
                    item.view.backgroundColor = [UIColor blueColor];
                    item.children = @[
                        ({
                            GYDHorizontalTreeViewItem *item = [[GYDHorizontalTreeViewItem alloc] init];
                            item.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
                            item.view.backgroundColor = [UIColor blueColor];
                            item;
                        }),
                        ({
                            GYDHorizontalTreeViewItem *item = [[GYDHorizontalTreeViewItem alloc] init];
                            item.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
                            item.view.backgroundColor = [UIColor grayColor];
                            item;
                        }),
                        ({
                            GYDHorizontalTreeViewItem *item = [[GYDHorizontalTreeViewItem alloc] init];
                            item.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
                            item.view.backgroundColor = [UIColor yellowColor];
                            item;
                        })
                    ];
                    item;
                }),
                ({
                    GYDHorizontalTreeViewItem *item = [[GYDHorizontalTreeViewItem alloc] init];
                    item.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
                    item.view.backgroundColor = [UIColor grayColor];
                    item;
                }),
                ({
                    GYDHorizontalTreeViewItem *item = [[GYDHorizontalTreeViewItem alloc] init];
                    item.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
                    item.view.backgroundColor = [UIColor yellowColor];
                    item.children = @[
                        ({
                            GYDHorizontalTreeViewItem *item = [[GYDHorizontalTreeViewItem alloc] init];
                            item.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
                            item.view.backgroundColor = [UIColor blueColor];
                            item;
                        }),
                        ({
                            GYDHorizontalTreeViewItem *item = [[GYDHorizontalTreeViewItem alloc] init];
                            item.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
                            item.view.backgroundColor = [UIColor grayColor];
                            item;
                        }),
                        ({
                            GYDHorizontalTreeViewItem *item = [[GYDHorizontalTreeViewItem alloc] init];
                            item.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
                            item.view.backgroundColor = [UIColor yellowColor];
                            item;
                        })
                    ];
                    item;
                })
            ];
            item;
        }),
        ({
            GYDHorizontalTreeViewItem *item = [[GYDHorizontalTreeViewItem alloc] init];
            item.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
            item.view.backgroundColor = [UIColor yellowColor];
            item;
        })
    ];
    
    view.rootItem = root;
    [view layoutAndChangeSize];
    view.gyd_origin = CGPointMake(0, 0);
    _scrollView.contentSize = view.gyd_size;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _scrollView.frame = self.view.bounds;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
