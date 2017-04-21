//
//  CCTintNavigationController.h
//  CCEncrypt
//
//  Created by 陈超 on 17/3/12.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCTintNavigationController : UINavigationController

/**
 * 创建指定rootController的导航控制器
 */
+ (instancetype)navigationRootCtrl:(UIViewController *)rootCtrl;

@end
