//
//  GYDTimeValuePathDemoViewController.m
//  GYDFoundation
//
//  Created by gongyadong on 2021/7/1.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDTimeValuePathDemoViewController.h"
#import "GYDTimeValuePathTestView.h"
#import "GYDDemoMenu.h"

@interface GYDTimeValuePathDemoViewController ()

@end

@implementation GYDTimeValuePathDemoViewController

+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"TimeValuePath" desc:@"全动画路径效果" order:120 vcClass:self];
    [menu addToMenu:GYDDemoMenuRootName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    GYDTimeValuePathTestView *view = [[GYDTimeValuePathTestView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:view];
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
