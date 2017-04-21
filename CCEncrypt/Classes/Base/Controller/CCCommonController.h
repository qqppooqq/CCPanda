//
//  CCCommonController.h
//  CCEncrypt
//
//  Created by MTCC on 16/11/15.
//  Copyright © 2016年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 标准协议
/**
 * 规定控制器标准协议
 */
@protocol CCControllerCriterionProtocol <NSObject>

/**
 * 控制器个性初始化
 * viewDidLoad 中执行
 */
- (void)controllerSpecialInit;

/**
 * 控制器布局
 * viewWillLayoutSubviews 中执行
 */
- (void)controllerLayoutSubviews;

@end


#pragma mark - 自定义控制器基类
/**
 * 标准_控制器个性初始化
 */
@interface CCCommonController : UIViewController <CCControllerCriterionProtocol>

@end
