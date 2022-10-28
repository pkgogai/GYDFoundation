//
//  GYDScrollViewVisibleRectDemoViewController2.m
//  GYDFoundationDemo
//
//  Created by gongyadong on 2022/10/28.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDScrollViewVisibleRectDemoViewController2.h"
#import "GYDUIKit.h"
#import "GYDDemoMenu.h"
#import "UIScrollView+GYDScrollVisible.h"

@interface GYDScrollViewVisibleRectDemoViewController2 ()<UITextFieldDelegate, UIScrollViewDelegate>

@end

@implementation GYDScrollViewVisibleRectDemoViewController2
{
    UIView *_controlView;
    UIView *_dirctionView;
    UITextField *_editingTextField;
    UIScrollView *_sv;
}
+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"ScrollView可视区(旋转)" desc:@"通过修改contentOffset和contentInset将指定区域移入可视范围" order:50 vcClass:self];
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
    
    for (NSInteger x = 0; x < 10; x++) {
        for (NSInteger y = 0; y < 10; y++) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x * 100 + 2, y * 100 + 2, 100 - 4, 100 - 4)];
            textField.tag = y * 20 + x + 100;
            textField.delegate = self;
            textField.backgroundColor = [UIColor gyd_colorWithRGBValue:[self randColorValueForIndex:textField.tag] alpha:0.3];
            textField.text = [NSString stringWithFormat:@"第%zd个", y * 20 + x];
            textField.returnKeyType = UIReturnKeyNext;
            [_sv addSubview:textField];
        }
    }
    
    _sv.contentSize = CGSizeMake(10 * 100, 10 * 100);
    

    _dirctionView = [[UIView alloc] initWithFrame:CGRectMake(70, 0, 180, 180)];
    [_dirctionView addSubview:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(62, 2, 56, 56);
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"↑" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeTop) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];

    [_dirctionView addSubview:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 62, 56, 56);
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"←" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeLeft) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];
    [_dirctionView addSubview:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(62, 62, 56, 56);
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"收键盘" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeNull) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];
    [_dirctionView addSubview:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(122, 62, 56, 56);
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"→" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeRight) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];
    
    [_dirctionView addSubview:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(62, 122, 56, 56);
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"↓" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeBottom) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];
    [_dirctionView addSubview:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(122, 62, 56, 56);
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"→" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeRight) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];
    
    
    _controlView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 320, 180)];
    [_controlView addSubview:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(2, 62, 56, 56);
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"↪️" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(turnLeft) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];
    
    [_controlView addSubview:_dirctionView];
    
    [_controlView addSubview:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(262, 62, 56, 56);
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"↩️" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(turnRight) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];
    
    
    [self.view addSubview:_controlView];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.view.bounds;
    UIEdgeInsets safeArea = self.view.gyd_safeAreaInsets;
    frame = UIEdgeInsetsInsetRect(frame, safeArea);
    CGPoint center = CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2);
    
    _controlView.center = CGPointMake(center.x, frame.origin.y + 90);
    
    CGFloat width = MIN(frame.size.width, frame.size.height) * 0.8;
    _sv.gyd_boundsSizeInt = CGSizeMake(width, width);
    _sv.center = center;
    
    CGRect visibleRect = _sv.gyd_visibleRect;
    if (!CGRectIsNull(visibleRect)) {
        _sv.gyd_visibleRect = visibleRect;
    }
}

- (void)changeEditingView:(void(^)(NSInteger *x, NSInteger *y))action {
    NSInteger x = 0;
    NSInteger y = 0;
    if (_editingTextField) {
        NSInteger tag = _editingTextField.tag;
        tag -= 100;
        y = tag / 20;
        x = tag - y * 20;
    }
    action(&x, &y);
    UIView *view = [self->_sv viewWithTag:y * 20 + x + 100];
    [view becomeFirstResponder];
}
- (void)changeLeft {
    [self changeEditingView:^(NSInteger *x, NSInteger *y) {
        if (*x > 0) {
            *x -= 1;
        } else {
            *x = 9;
        }
    }];
}
- (void)changeRight {
    [self changeEditingView:^(NSInteger *x, NSInteger *y) {
        if (*x < 9) {
            *x += 1;
        } else {
            *x = 0;
        }
    }];
}
- (void)changeTop {
    [self changeEditingView:^(NSInteger *x, NSInteger *y) {
        if (*y > 0) {
            *y -= 1;
        } else {
            *y = 9;
        }
    }];
}
- (void)changeBottom {
    [self changeEditingView:^(NSInteger *x, NSInteger *y) {
        if (*y < 9) {
            *y += 1;
        } else {
            *y = 0;
        }
    }];
}
- (void)changeNull {
    [self.view endEditing:YES];
}

- (void)turnLeft {
    _dirctionView.transform = CGAffineTransformRotate(_dirctionView.transform, -M_PI / 10);
    _sv.transform = _dirctionView.transform;
}
- (void)turnRight {
    _dirctionView.transform = CGAffineTransformRotate(_dirctionView.transform, M_PI / 10);
    _sv.transform = _dirctionView.transform;
}

- (uint32_t)randColorValueForIndex:(NSUInteger)index {
    index = index % 6 + 1;
    return ((index & 1) ? 0xff0000 : 0) + ((index & 2) ? 0x00ff00 : 0) + ((index & 4) ? 0x0000ff : 0);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _editingTextField = textField;
    [UIView animateWithDuration:0.2 animations:^{
        textField.backgroundColor = [UIColor redColor];
        self->_sv.gyd_visibleRect = textField.frame;
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    _editingTextField = nil;
    [UIView animateWithDuration:0.2 animations:^{
        textField.backgroundColor = [UIColor gyd_colorWithRGBValue:[self randColorValueForIndex:textField.tag] alpha:0.3];
        self->_sv.gyd_visibleRect = CGRectNull;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self changeBottom];
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //既然要滑动位置了，那可视区域的处理就应该去掉，所以下面二选一
    [self.view endEditing:YES];
//    _sv.gyd_visibleRect = CGRectNull;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
}

@end
