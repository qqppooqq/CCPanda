//
//  CCCommonController.m
//  CCEncrypt
//
//  Created by MTCC on 16/11/15.
//  Copyright © 2016年 CC. All rights reserved.
//

/**
 项目控制器公有的父类应该有的方法
 1. 存放当前控制器请求 NSURLSessionTask 对象的数组, 退出控制器的时候要清空 cancel 的
 2. 统一的提示样式, - alertSuccess; - alertError; - alertMessage:; 等等, 以保证所有控制器提示的样式统一
 3. 数据加载进度样式, 没有->提前扩展, 有->那更没有理由不搞啊, 同上保证样式统一
 */

#import "CCCommonController.h"

#import "CCToolDefines.h"

#import <YYKit/UIView+YYAdd.h>

@interface CCCommonController ()

@end

@implementation CCCommonController

#pragma mark - Reload
// 1.
//- (instancetype)init {
//    if (self = [super init]) {
//        
//    }
//    return self;
//}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super initWithCoder:aDecoder]) {
//        
//    }
//    return self;
//}
//
//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        
//    }
//    return self;
//}
//
// 2.
//- (void)loadView {
//    [super loadView];
//}

// 3.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self controllerCommonInit];
    
    [self controllerSpecialInit];
}

// 4.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

// 5.
- (void)viewWillLayoutSubviews {
    // UIViewController 中 viewWillLayoutSubviews 默认为空
    // [super viewWillLayoutSubviews];
    [self controllerLayoutSubviews];
}

// 6.
- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
}

// 7.
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

// 8.
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

// 9.
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Common
- (void)controllerCommonInit {
    self.view.backgroundColor = CCColorRGB(245, 245, 245);
    // 如果iOS7以后
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        [self setEdgesForExtendedLayout:UIRectEdgeAll];
    }
}

#pragma mark - Special
#pragma mark - Event
#pragma mark - Protocol
// CCControllerCriterionProtocol
- (void)controllerSpecialInit { /* 子类实现 */ }

- (void)controllerLayoutSubviews { /* 子类实现 */ }

#pragma mark - Lazy

@end



