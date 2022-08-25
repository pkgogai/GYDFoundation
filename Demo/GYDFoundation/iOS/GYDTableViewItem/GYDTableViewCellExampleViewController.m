//
//  GYDTableViewCellExampleViewController.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/9/20.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTableViewCellExampleViewController.h"
#import "GYDTableViewCellExampleModel.h"
#import "GYDTableViewCellExampleView.h"
#import "GYDLogExample.h"
#import "GYDTableViewCellDemoType2Model.h"
#import "GYDDemoMenu.h"

@interface GYDTableViewCellExampleViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray<GYDTableViewCellModel *> *_dataArray;
}

@end

@implementation GYDTableViewCellExampleViewController

+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"CellModel" desc:@"通过Model指定Cell，TableView中只使用Model" order:85 vcClass:self];
    [menu addToMenu:GYDDemoMenuRootName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < 12; i ++) {
        [_dataArray addObject:({
            GYDTableViewCellExampleModel *model = [[GYDTableViewCellExampleModel alloc] init];
            model.title = [NSString stringWithFormat:@"title: %d", (int)i];
            model.backColor = [UIColor whiteColor];
            model;
        })];
        
        [_dataArray addObject:({
            GYDTableViewCellDemoType2Model *model = [[GYDTableViewCellDemoType2Model alloc] init];
            model;
        })];
    }
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor grayColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsMultipleSelection = NO;
    _tableView.exclusiveTouch = YES;
    _tableView.multipleTouchEnabled = NO;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    if (@available(iOS 11, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.frame = self.view.bounds;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
    _tableView.contentInset = self.view.gyd_safeAreaInsets;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _dataArray.count) {
        GYDTableViewCellModel *model = _dataArray[indexPath.row];
        return [model heightInTableView:tableView];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _dataArray.count) {
        //凡是从GYDTableViewCellModel派生出的model，都当成一种来用。
        return [_dataArray[indexPath.row] cellInTableView:tableView];
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < _dataArray.count) {
        GYDTableViewCellModel *model = _dataArray[indexPath.row];
        [model handleClickEvent];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _dataArray.count) {
        GYDTableViewCellModel *model = _dataArray[indexPath.row];
        return [model shouldClick];
    }
    return NO;
}

@end
