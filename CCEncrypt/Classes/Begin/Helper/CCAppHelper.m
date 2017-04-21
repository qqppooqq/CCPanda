//
//  CCAppHelper.m
//  CCEncrypt
//
//  Created by 陈超 on 17/3/13.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCAppHelper.h"

//#import <我是第三方SDK>
#import "CCBaseTabBarController.h"

@implementation CCAppHelper

#pragma mark - Single
SingleImplementation(CCAppHelper);

#pragma mark - Application Help Method / Special
+ (UIViewController *)showViewController {
    // 判断是否有新特性 / 广告等界面的展示, 已决定返回的控制器
    return [CCBaseTabBarController new];
}

+ (void)appHelperDecideThreeSDK {
    // 初始化第三方SDK
}


@end
