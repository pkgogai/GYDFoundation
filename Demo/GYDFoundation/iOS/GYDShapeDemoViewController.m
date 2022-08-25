//
//  GYDShapeDemoViewController.m
//  GYDFoundationDemo
//
//  Created by gongyadong on 2022/8/25.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDShapeDemoViewController.h"
#import "GYDDemoMenu.h"

#import "GYDShapeView.h"
#import "GYDRectShape.h"
#import "GYDLineShape.h"
#import "GYDCircleShape.h"
#import "GYDRectArrowShape.h"

@implementation GYDShapeDemoViewController

+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"GYDShape" desc:@"绘制常见的形状" order:45 vcClass:self];
    [menu addToMenu:@"图形"];
    
    menu = [GYDDemoMenu menuWithName:@"图形" desc:nil order:95];
    [menu addToMenu:GYDDemoMenuRootName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 400)];
    label.font = [UIFont systemFontOfSize:80];
    label.textColor = [UIColor grayColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.text = @"123456789012345678901234567890";
    [self.view addSubview:label];
    
    GYDShapeView *view = [[GYDShapeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    
    GYDLineShape *line = [[GYDLineShape alloc] init];
    line.lineColor = [UIColor blackColor];
    line.lineWidth = 5;
    line.point1 = CGPointMake(10, 80);
    line.point2 = CGPointMake(300, 280);
    [view addShape:line];
    
    GYDRectShape *rect = [[GYDRectShape alloc] init];
    rect.lineColor = [UIColor blueColor];
    rect.fillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.8];
    rect.rectValue = CGRectMake(50, 100, 200, 150);
    [view addShape:rect];
    
    GYDCircleShape *circle = [[GYDCircleShape alloc] init];
    circle.drawMode = GYDDrawModeClear;
    circle.fillColor = [UIColor blackColor];
    circle.centerX = 150;
    circle.centerY = 160;
    circle.r = 50;
    [view addShape:circle];
    
    GYDRectArrowShape *arrow = [[GYDRectArrowShape alloc] init];
    arrow.lineColor = [UIColor blackColor];
    arrow.fillColor = [UIColor grayColor];
    arrow.rectValue = CGRectMake(50, 300, 200, 50);
    arrow.cornerRadius = 4;
    arrow.arrowLocation = CGPointMake(100, 290);
    [view addShape:arrow];
}


@end
