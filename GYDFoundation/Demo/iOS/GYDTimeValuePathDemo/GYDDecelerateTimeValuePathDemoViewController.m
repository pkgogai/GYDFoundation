//
//  GYDDecelerateTimeValuePathDemoViewController.m
//  GYDFoundation
//
//  Created by gongyadong on 2021/7/1.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDDecelerateTimeValuePathDemoViewController.h"
#import "GYDUIKit.h"
#import "GYDDecelerateTimeValuePath.h"
#import "GYDTimeValuePathTimer.h"

@interface GYDDecelerateTimeValuePathDemoViewController ()<UIScrollViewDelegate, GYDTimeValuePathTimerDelegate>

@end

@implementation GYDDecelerateTimeValuePathDemoViewController
{
    UILabel *_targetValueTitleLabel;
    UIScrollView *_targetValueScrollView;
    
    UILabel *_demoTitleLabel;
    UIScrollView *_demoScrollView;
    
    GYDTimeValuePathTimer *_scrollViewDecelerateTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _targetValueTitleLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 1;
        label.text = @"下次停止的位置";
        label;
    });
    [self.view addSubview:_targetValueTitleLabel];
    
    _targetValueScrollView = ({
        UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectZero];
        NSInteger i = 0;
        CGFloat itemWidth = 100;
        for (i = 0; i < 40; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, 60)];
            label.backgroundColor = [UIColor colorWithRed:(1.0 * (i % 3) / 2)
                                                    green:(1.0 * (i % 5) / 2)
                                                     blue:(1.0 * (i % 7) / 2)
                                                    alpha:1];
            label.textColor = [UIColor colorWithRed:(1.0 * ((i+1) % 3) / 2)
                                              green:(1.0 * ((i+2) % 5) / 2)
                                               blue:(1.0 * ((i+3) % 7) / 2)
                                              alpha:1];
            label.font = [UIFont systemFontOfSize:30];
            label.text = [NSString stringWithFormat:@"%zd", i];
            label.textAlignment = NSTextAlignmentCenter;
            [sv addSubview:label];
        }
        sv.contentSize = CGSizeMake(itemWidth * i, 0);
        sv;
    });
    [self.view addSubview:_targetValueScrollView];
    
    _demoTitleLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 1;
        label.text = @"来滑动吧";
        label;
    });
    [self.view addSubview:_demoTitleLabel];
    
    _demoScrollView = ({
        UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectZero];
        NSInteger i = 0;
        CGFloat itemWidth = 100;
        for (i = 0; i < 40; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, 60)];
            label.backgroundColor = [UIColor colorWithRed:(1.0 * (i % 3) / 2)
                                                    green:(1.0 * (i % 5) / 2)
                                                     blue:(1.0 * (i % 7) / 2)
                                                    alpha:1];
            label.textColor = [UIColor colorWithRed:(1.0 * ((i+1) % 3) / 2)
                                              green:(1.0 * ((i+2) % 5) / 2)
                                               blue:(1.0 * ((i+3) % 7) / 2)
                                              alpha:1];
            label.font = [UIFont systemFontOfSize:30];
            label.text = [NSString stringWithFormat:@"%zd", i];
            label.textAlignment = NSTextAlignmentCenter;
            [sv addSubview:label];
        }
        sv.contentSize = CGSizeMake(itemWidth * i, 0);
        sv;
    });
    [self.view addSubview:_demoScrollView];
    
    _demoScrollView.delegate = self;
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGSize viewSize = self.view.bounds.size;
    CGFloat layoutY = 60;
    _targetValueTitleLabel.frame = CGRectMake(0, layoutY, viewSize.width, 20);
    layoutY = _targetValueTitleLabel.bottomY;
    _targetValueScrollView.frame = CGRectMake(0, layoutY, viewSize.width, 60);
    layoutY = _targetValueScrollView.bottomY;
    
    layoutY += 20;
    _demoTitleLabel.frame = CGRectMake(0, layoutY, viewSize.width, 20);
    layoutY = _demoTitleLabel.bottomY;
    _demoScrollView.frame = CGRectMake(0, layoutY, viewSize.width, 60);
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //停掉自定义减速动画
    _scrollViewDecelerateTimer = nil;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"offset: %lf", scrollView.contentOffset.x);
    //以_targetValueScrollView的位置为准，所以让_targetValueScrollView不要再滚动了
    [_targetValueScrollView setContentOffset:_targetValueScrollView.contentOffset animated:YES];
    
    //设置自定义减速参数
    GYDDecelerateTimeValuePath *path = [[GYDDecelerateTimeValuePath alloc] init];
    path.normalAcceleratedVelocity = 0.5 * 1000;
    path.maxAcceleratedVelocity = 5 * 1000;
    path.backAcceleratedVelocity = 60 * 1000;
    path.minUniformVelocity = 1 * 1000;
    path.startTime = 0;
    
    [path startDecelerateWithVelocity:velocity.x * 1000 value:scrollView.contentOffset.x targetTimeValue:^(NSTimeInterval offsetTime, CGFloat * _Nonnull value) {
        //不担心循环引用
        *value = self->_targetValueScrollView.contentOffset.x;
    }];
    
    _scrollViewDecelerateTimer = [[GYDTimeValuePathTimer alloc] init];
    _scrollViewDecelerateTimer.delegate = self;
    _scrollViewDecelerateTimer.timeValuePath = path;
    _scrollViewDecelerateTimer.time = 0;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //开始自定义减速动画
    [_scrollViewDecelerateTimer startCallback];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    //停掉自带的减速动画
    [scrollView setContentOffset:scrollView.contentOffset animated:YES];
}

#pragma mark - GYDTimeValuePathTimerDelegate
- (void)timeValuePathTimer:(GYDTimeValuePathTimer *)timer didUpdateValue:(CGFloat)value {
    [_demoScrollView setContentOffset:CGPointMake(value, 0) animated:NO];
}

- (void)timeValuePathTimer:(GYDTimeValuePathTimer *)timer didStopAtValue:(CGFloat)value {
    [_demoScrollView setContentOffset:CGPointMake(value, 0) animated:NO];
    _scrollViewDecelerateTimer = nil;
}


@end
