//
//  GYDWeakTimerDemoViewController.m
//  GYDFoundationDemo
//
//  Created by gongyadong on 2022/8/25.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDWeakTimerDemoViewController.h"
#import "GYDDemoMenu.h"
#import "GYDWeakTimer.h"

@implementation GYDWeakTimerDemoViewController
{
    GYDWeakTimer *_timer;
    UILabel *_label;
}

+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"GYDWeakTimer,GYDWeakDisplayLink" desc:@"可以阻碍导致延后执行的操作队列" order:70 vcClass:self];
    [menu addToMenu:GYDDemoMenuRootName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"启用计时" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(resetTimer) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(100, 100, 100, 40);
        [self.view addSubview:button];
    }
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"关闭计时" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(stopTimer) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(100, 200, 100, 40);
        [self.view addSubview:button];
    }
    _label = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.frame = CGRectMake(100, 300, 100, 40);
        label.text = @"0";
        label;
    });
    [self.view addSubview:_label];
}

- (void)resetTimer {
//    GYDWeakDisplayLink 用法相同
    _timer = [GYDWeakTimer timerStartWithTimeInterval:1 target:self selector:@selector(timeup) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    _timer = nil;
}

- (void)timeup {
    NSInteger value = [_label.text integerValue];
    value ++;
    _label.text = [NSString stringWithFormat:@"%zd", value];
}


@end
