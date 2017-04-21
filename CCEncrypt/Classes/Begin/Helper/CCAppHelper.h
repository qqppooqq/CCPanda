//
//  CCAppHelper.h
//  CCEncrypt
//
//  Created by 陈超 on 17/3/13.
//  Copyright © 2017年 CC. All rights reserved.
//

/**
 * App协助者 - 程序层级的协助者
 * AppDelegate 中第三方回调代理的实现
 * 初始化 / 执行第三方SDK
 */

#import <UIKit/UIKit.h>
#import "CCSingleDefines.h"

@interface CCAppHelper : NSObject

#pragma mark - Single
/**
 * 可能用到, 也可能用不到
 */
SingleInterFace(CCAppHelper);

#pragma mark - Application Help Method
/**
 * 决定window的rootViewController
 */
+ (UIViewController *)showViewController;

/**
 * 初始化第三方SDK的便捷方法类
 */
+ (void)appHelperDecideThreeSDK;

@end
