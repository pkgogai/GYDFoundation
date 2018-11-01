//
//  GYDTableViewCellExampleModel.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/9/20.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTableViewCellExampleModel.h"
#import "GYDTableViewCellExampleView.h"

@implementation GYDTableViewCellExampleModel

- (Class<GYDTableViewCellViewProtocol>)viewClass {
    return [GYDTableViewCellExampleView class];
}


- (void)handleClickEvent {

}

@end
