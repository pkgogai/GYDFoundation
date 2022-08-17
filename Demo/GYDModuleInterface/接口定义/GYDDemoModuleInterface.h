//
//  GYDDemoModuleInterface.h
//  GYDDevelopment
//
//  Created by gongyadong on 2021/6/19.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDModuleInterfaceDelegate.h"

@GYDModuleInterfaceRegister(GYDDemoModuleInterface)

- (nullable UIViewController *)createDemoViewController;

@end
