//
//  GYDSafeAreaExampleViewController.m
//  iOSExample
//
//  Created by 宫亚东 on 2018/10/31.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDSafeAreaExampleViewController.h"
#import "UIView+GYDSafeArea.h"
#import "GYDSafeAreaDemoDisplayView.h"

#import "GYDDebugViewTipsDisplayView.h"
#import "GYDDemoMenu.h"
#import "gyd_timekeeper.h"

@interface GYDSafeAreaExampleViewController ()

@end

@implementation GYDSafeAreaExampleViewController
{
    GYDSafeAreaDemoDisplayView *_safeAreaView;
    GYDSafeAreaDemoDisplayView *_view[3];
    UILabel *_readmeLabel;
}

+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"安全区" desc:@"和系统的安全区规则不同" order:90 vcClass:self];
    [menu addToMenu:GYDDemoMenuRootName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _safeAreaView = [[GYDSafeAreaDemoDisplayView alloc] initWithFrame:CGRectZero];
    _safeAreaView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:1];
    [self.view addSubview:_safeAreaView];
    
    for (NSInteger i = 0; i < 3; i++) {
        _view[i] = [[GYDSafeAreaDemoDisplayView alloc] initWithFrame:CGRectMake(50, 240 - i * 180, 200, 300)];
        _view[i].backgroundColor = [UIColor colorWithRed:0 green:2 - i blue:i alpha:0.4];
        if (i > 0) {
            [_view[i - 1] addSubview:_view[i]];
        } else {
            [self.view addSubview:_view[i]];
        }
    }
    _readmeLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:16];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.view addSubview:_readmeLabel];
    _readmeLabel.text = @"注意：gyd_safeAreaInsets与系统自带的安全区规则不同！！！\n以安全区.top为例，黄色区域为手机安全区，3个嵌套的view安全区如下：\n左边为gyd_safeAreaInsets.top的值\n右边为系统safeAreaInsets.top的值\n单指移动，双指缩放或旋转";
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGSize viewSize = self.view.bounds.size;
    
    //为了方便展示，强制safeArea.top为330
    if (@available(iOS 11.0, *)) {
        self.additionalSafeAreaInsets = UIEdgeInsetsMake(330 + self.additionalSafeAreaInsets.top - self.view.safeAreaInsets.top, 0, 0, 0);
    } else {
        // Fallback on earlier versions
    }
    [self.view gyd_setSafeAreaInsets:UIEdgeInsetsMake(330, 0, 0, 0)];
    
    CGSize readmeSize = [_readmeLabel sizeThatFits:CGSizeMake(viewSize.width - 100, 0)];
    _readmeLabel.frame = CGRectMake((viewSize.width - readmeSize.width) / 2, 60, readmeSize.width, readmeSize.height);
    
    _safeAreaView.frame = CGRectMake(0, 0, viewSize.width, self.view.gyd_safeAreaInsets.top);
    [_safeAreaView updateSafeAreaValue];
    
    for (NSInteger i = 0; i < 3; i++) {
        [_view[i] updateSafeAreaValue];
    }
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    NSLog(@"%s", __func__);
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
