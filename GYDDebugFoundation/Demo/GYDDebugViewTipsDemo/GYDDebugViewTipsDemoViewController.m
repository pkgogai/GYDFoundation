//
//  GYDDebugViewTipsDemoViewController.m
//  GYDDebugFoundationDemo
//
//  Created by gongyadong on 2022/8/16.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDDebugViewTipsDemoViewController.h"
#import "GYDDebugViewTipsDisplayViewModel.h"
#import "GYDDebugViewTipsDisplayView.h"
#import "GYDDemoMenu.h"

@interface GYDDebugViewTipsDemoViewController ()

@end

@implementation GYDDebugViewTipsDemoViewController
{
    GYDDebugViewTipsDisplayView *_tipsView;
    UILabel *_messageLabel;
    NSInteger _index;
}

+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"ViewTips" desc:@"在屏幕上为指定view添加提示语" order:100 vcClass:self];
    [menu addToMenu:@"图形"];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _index = 0;
    _messageLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentLeft;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.text = @"点击屏幕添加提示语";
        [label sizeToFit];
        label;
    });
    [self.view addSubview:_messageLabel];
    
    _tipsView = [[GYDDebugViewTipsDisplayView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tipsView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.view.bounds;
    
    _tipsView.frame = frame;
    _messageLabel.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
    
    
}

- (void)tap:(UITapGestureRecognizer *)tap {
    _index ++;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = [NSString stringWithFormat:@"这是第%zd条提示", _index];
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    CGPoint local = [tap locationInView:_tipsView];
    
    GYDDebugViewTipsDisplayViewModel *model = [[GYDDebugViewTipsDisplayViewModel alloc] init];
    model.locationRect = CGRectMake(local.x - 20, local.y - 20, 40, 40);
    model.tipsCenter = local;
    model.tipsView = label;
    model.colorRGBValue = [self randColorValueForIndex:_index];
    [_tipsView addItem:model];
}

- (uint32_t)randColorValueForIndex:(NSUInteger)index {
    index = index % 6 + 1;
    return ((index & 1) ? 0xff0000 : 0) + ((index & 2) ? 0x00ff00 : 0) + ((index & 4) ? 0x0000ff : 0);
}

@end
