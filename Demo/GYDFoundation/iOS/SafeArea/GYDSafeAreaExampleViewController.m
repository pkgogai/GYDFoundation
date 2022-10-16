//
//  GYDSafeAreaExampleViewController.m
//  iOSExample
//
//  Created by 宫亚东 on 2018/10/31.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDSafeAreaExampleViewController.h"
#import "GYDUIKit.h"
#import "GYDRectShape.h"
#import "GYDSafeAreaDemoDisplayView.h"
#import "GYDDebugViewTipsDisplayView.h"
#import "GYDDemoMenu.h"
#import "gyd_timekeeper.h"

@interface GYDSafeAreaExampleViewController ()

@end

@implementation GYDSafeAreaExampleViewController
{
    GYDSafeAreaDemoDisplayView *_safeAreaView;
    GYDShapeView *_safeAreaBackgroundView;
    GYDRectShape *_safeAreaShape;
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    _safeAreaBackgroundView = [[GYDShapeView alloc] initWithFrame:CGRectZero];
    _safeAreaBackgroundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:1];
    _safeAreaShape = [[GYDRectShape alloc] init];
    _safeAreaShape.fillColor = [UIColor whiteColor];
    [_safeAreaBackgroundView addShape:_safeAreaShape];
    [self.view addSubview:_safeAreaBackgroundView];
    
    
    _safeAreaView = [[GYDSafeAreaDemoDisplayView alloc] initWithFrame:CGRectZero];
    _safeAreaView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_safeAreaView];
    
    for (NSInteger i = 0; i < 3; i++) {
        _view[i] = [[GYDSafeAreaDemoDisplayView alloc] initWithFrame:CGRectMake(30, 240 - i * 180, 200, 300)];
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
        label.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.view addSubview:_readmeLabel];
    _readmeLabel.text = @"黄色区域为手机安全区，3个嵌套的view安全区如下：\n红色为gyd_safeAreaInsets的值\n蓝色为系统safeAreaInsets的值\n单指移动，双指缩放或旋转";
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGSize viewSize = self.view.bounds.size;
    
    UIEdgeInsets safeArea = self.view.gyd_safeAreaInsets;
    safeArea.top = 330;
    safeArea.left = 50;
    safeArea.right = 50;
    safeArea.bottom = 100;
    [self.view gyd_setSafeAreaInsets:safeArea];
    
    //为了方便展示，强制safeArea.top为330
    if (@available(iOS 11.0, *)) {
        GYDUIStructToArray fromSafeArea;
        fromSafeArea.edgeInsetsValue = self.view.safeAreaInsets;
        GYDUIStructToArray toSafeArea;
        toSafeArea.edgeInsetsValue = safeArea;
        GYDUIStructToArray additionalSafeAreaInsets;
        additionalSafeAreaInsets.edgeInsetsValue = self.additionalSafeAreaInsets;
        
        for (NSInteger i = 0; i < 4; i++) {
            additionalSafeAreaInsets.arrayValue[i] = toSafeArea.arrayValue[i] + additionalSafeAreaInsets.arrayValue[i] - fromSafeArea.arrayValue[i];
        }
        self.additionalSafeAreaInsets = additionalSafeAreaInsets.edgeInsetsValue;
    } else {
        // Fallback on earlier versions
    }

    
    CGSize readmeSize = [_readmeLabel sizeThatFits:CGSizeMake(viewSize.width - 100, 0)];
    _readmeLabel.frame = CGRectMake((viewSize.width - readmeSize.width) / 2, 60, readmeSize.width, readmeSize.height);
    
    _safeAreaBackgroundView.frame = self.view.bounds;
    _safeAreaShape.rectValue = CGRectMake(safeArea.left, safeArea.top, viewSize.width - safeArea.left - safeArea.right, viewSize.height - safeArea.top - safeArea.bottom);
    [_safeAreaBackgroundView setNeedsDisplay];
    
    _safeAreaView.frame = self.view.bounds;
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
