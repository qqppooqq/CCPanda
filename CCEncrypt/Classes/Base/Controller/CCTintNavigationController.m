//
//  CCTintNavigationController.m
//  CCEncrypt
//
//  Created by 陈超 on 17/3/12.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCTintNavigationController.h"

#import <YYKit/UIImage+YYAdd.h>

#import "CCDefines.h"


@interface CCTintNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

/** Pan Gesture */
@property (nullable, nonatomic, weak) UIPanGestureRecognizer *panGesture;

/** is Pushing */
@property (nonatomic, assign) BOOL pushing;

@end


@implementation CCTintNavigationController

#pragma mark -
+ (instancetype)navigationRootCtrl:(UIViewController *)rootCtrl {
    return [[CCTintNavigationController alloc] initWithRootViewController:rootCtrl];
}


#pragma mark - Overload
// Init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navCommonInit];
}


// Logic
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self _pushViewCtrl:viewController animated:animated];
}

// StatusBar
/// 返回的子控制器会执行自身的 - (UIStatusBarStyle)preferredStatusBarStyle 方法
//- (UIViewController *)childViewControllerForStatusBarStyle {
//    return self.topViewController;
//}
/***
 * 默认并不会自动调用子控制器的 - preferredStatusBarStyle 方法, 如果不是状态栏多变的情况
 * 推荐在 NavigationCtrl 中实现下面方法即可,
 * 可以省去实现上面方法后逐个调用子控制器的 - preferredStatusBarStyle 方法
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}


#pragma mark - Special
- (void)navCommonInit {
    self.delegate = self;
    self.panGesture.enabled = YES;
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)_pushViewCtrl:(UIViewController *)ctrl animated:(BOOL)animated {
    _pushing = YES;
    if (self.childViewControllers.count > 0) {
        ctrl.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:ctrl animated:animated];
}


#pragma mark - Protocol
/// UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.childViewControllers.count != 1 && !_pushing;
}

/// UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    _pushing = NO;
}


#pragma mark - Lazy
- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        id target = self.interactivePopGestureRecognizer.delegate;
        SEL action = NSSelectorFromString(@"handleNavigationTransition:");
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
        panGesture.delegate = self;
        [self.view addGestureRecognizer:panGesture];
        _panGesture = panGesture;
    }
    return _panGesture;
}

@end

