//
//  JSONExample.m
//  iOSExample
//
//  Created by 宫亚东 on 2018/10/31.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "JSONExample.h"
#import "GYDJSONExampleModel.h"

@implementation JSONExample

+ (void)test {
    GYDJSONExampleModel *model = [[GYDJSONExampleModel alloc] init];
    model.key1 = @"value1";
    model.key2 = 123;
    model.stringArray = @[@"str1", @"str2"];
    model.modelArray = @[
                         ({
                             GYDJSONExampleModel *model = [[GYDJSONExampleModel alloc] init];
                             model.key1 = @"array1's model1";
                             model;
                         }),
                         ({
                             GYDJSONExampleModel *model = [[GYDJSONExampleModel alloc] init];
                             model.key1 = @"array1's model2";
                             model;
                         })
                         ];
    //转JSON
    NSDictionary *dic = [model gyd_JSONDictionary];
    NSString *str = [model gyd_JSONString];
    NSData *data = [model gyd_JSONData];
    
    //转Model
    model = [GYDJSONExampleModel gyd_modelWithJSONDictionary:dic];
    model = [GYDJSONExampleModel gyd_modelWithJSONString:str];
    model = [GYDJSONExampleModel gyd_modelWithJSONData:data];
}

@end
