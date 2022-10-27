//
//  GYDScrollViewVisibleRectDemoViewController.m
//  GYDDevelopment
//
//  Created by gongyadong on 2022/10/26.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDScrollViewVisibleRectDemoViewController.h"
#import "GYDUIKit.h"
#import "GYDDemoMenu.h"
#import "UIScrollView+GYDScrollVisible.h"

@interface GYDScrollViewVisibleRectDemoViewController ()<UITextFieldDelegate, UIScrollViewDelegate>

@end

@implementation GYDScrollViewVisibleRectDemoViewController
{
    UIScrollView *_sv;
}
+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"ScrollView可视区" desc:@"通过修改contentOffset和contentInset将指定区域移入可视范围" order:51 vcClass:self];
    [menu addToMenu:@"屏幕区域"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _sv = ({
        UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectZero];
        sv.delegate = self;
        sv.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        if (@available(iOS 11.0, *)) {
            sv.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        sv;
    });
    [self.view addSubview:_sv];
    
    for (NSInteger i = 0; i < 20; i++) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(5, i * 85, 270, 80)];
        textField.tag = i + 100;
        textField.delegate = self;
        textField.backgroundColor = [UIColor gyd_colorWithRGBValue:[self randColorValueForIndex:i] alpha:1];
        [self randColorValueForIndex:i];
        textField.text = [NSString stringWithFormat:@"第%zd行", i];
        textField.returnKeyType = UIReturnKeyNext;
        [_sv addSubview:textField];
    }
    _sv.contentSize = CGSizeMake(280, 20 * 85);
    
    UIButton *button = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(300, 100, 100, 100);
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"收键盘" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(aaaa) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.view addSubview:button];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.view.bounds;
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.width = 290;
    frame.size.height -= 20;
    _sv.frame = frame;
    _sv.contentInset = _sv.gyd_safeAreaInsets;
    _sv.gyd_visibleSafeArea = UIEdgeInsetsMake(_sv.gyd_safeAreaInsets.top, 0, 20, 0);
}

- (void)aaaa {
    [self.view endEditing:YES];
}

- (uint32_t)randColorValueForIndex:(NSUInteger)index {
    index = index % 6 + 1;
    return ((index & 1) ? 0xff0000 : 0) + ((index & 2) ? 0x00ff00 : 0) + ((index & 4) ? 0x0000ff : 0);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.2 animations:^{
        self->_sv.gyd_visibleRect = textField.frame;
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.2 animations:^{
        self->_sv.gyd_visibleRect = CGRectNull;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger tag = textField.tag;
    tag ++;
    if (tag >= 20 + 100) {
        tag = 100;
    }
    UIView *tf = [_sv viewWithTag:tag];
    [tf becomeFirstResponder];
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //既然要滑动位置了，那可视区域的处理就应该去掉，所以下面二选一
    [self.view endEditing:YES];
//    _sv.gyd_visibleRect = CGRectNull;
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
